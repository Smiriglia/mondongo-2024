import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailService {
  Future<void> sendEmail(String to, String subject, String message) async {
    final url = Uri.parse('https://api.sendgrid.com/v3/mail/send');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${dotenv.env['SENDGRID_KEY']}',
      },
      body: jsonEncode({
        'personalizations': [
          {
            'to': [
              {'email': to}
            ],
            'subject': subject,
          }
        ],
        'from': {'email': 'mondongo.restaurante0@gmail.com'},
        'content': [
          {'type': 'text/html', 'value': _buildHtmlMessage(message)}
        ],
      }),
    );

    if (response.statusCode == 202) {
      print('Email enviado exitosamente');
    } else {
      print('Error enviando email: ${response.body}');
    }
  }

  String _buildHtmlMessage(String message) {
    return '''
    <!DOCTYPE html>
    <html>
      <head>
        <style>
          body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 20px;
            color: #333;
          }
          .container {
            max-width: 600px;
            margin: auto;
            background: #ffffff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
          }
          .header {
            text-align: center;
            padding-bottom: 20px;
          }
          .logo {
            width: 100px;
            height: auto;
          }
          .content {
            font-size: 16px;
            line-height: 1.6;
          }
          .footer {
            text-align: center;
            margin-top: 20px;
            font-size: 12px;
            color: #777;
          }
        </style>
      </head>
      <body>
        <div class="container">
          <div class="header">
            <img src="https://i.postimg.cc/ht8nZk6J/icon.png" alt="Logo" class="logo">
            <h2>Mondongo Restaurante</h2>
          </div>
          <div class="content">
            $message
          </div>
          <div class="footer">
            <p>Gracias por elegir Mondongo Restaurante.</p>
            <p>&copy; 2024 Mondongo Restaurante. Todos los derechos reservados.</p>
          </div>
        </div>
      </body>
    </html>
    ''';
  }
}
