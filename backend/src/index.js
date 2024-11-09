const express = require('express');
const admin = require('firebase-admin');
const cors = require('cors');
require('dotenv').config();

const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// Initialize Firebase Admin
admin.initializeApp({
  credential: admin.credential.cert({
    projectId: process.env.FIREBASE_PROJECT_ID,
    clientEmail: process.env.FIREBASE_CLIENT_EMAIL,
    privateKey: process.env.FIREBASE_PRIVATE_KEY?.replace(/\\n/g, '\n')
  })
});

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// Send notification to a topic
app.post('/api/notify', async (req, res) => {
  try {
    const { topic, title, body, data } = req.body;

    if (!topic || !title || !body) {
      return res.status(400).json({ 
        error: 'Missing required fields: topic, title, body' 
      });
    }

    const message = {
      notification: {
        title,
        body,
      },
      data: data || {},
      topic,
    };

    const response = await admin.messaging().send(message);
    res.json({ 
      success: true, 
      messageId: response,
      timestamp: new Date().toISOString()
    });

  } catch (error) {
    console.error('Error sending notification:', error);
    res.status(500).json({ 
      error: error.message,
      timestamp: new Date().toISOString()
    });
  }
});

// Subscribe tokens to topic
app.post('/api/subscribe', async (req, res) => {
  try {
    const { tokens, topic } = req.body;

    if (!tokens || !topic) {
      return res.status(400).json({ 
        error: 'Missing required fields: tokens, topic' 
      });
    }

    const response = await admin.messaging().subscribeToTopic(tokens, topic);
    res.json({ 
      success: true, 
      result: response,
      timestamp: new Date().toISOString()
    });

  } catch (error) {
    console.error('Error subscribing to topic:', error);
    res.status(500).json({ 
      error: error.message,
      timestamp: new Date().toISOString()
    });
  }
});

const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});