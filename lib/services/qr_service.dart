import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;

class QRService {
  final SupabaseClient _client = Supabase.instance.client;

  /// Genera un código QR a partir de los datos proporcionados y lo sube al bucket especificado.
  Future<String?> generateAndUploadQRCode(
      String data, String bucket, String pathName) async {
    try {
      // Genera el QR directamente como una imagen usando QrPainter
      final qrPainter = QrPainter(
        data: data,
        version: QrVersions.auto,
        gapless: false,
      );

      // Crear la imagen del QR
      final qrImage = await qrPainter.toImage(200);
      final byteData = await qrImage.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        debugPrint('Error: No se pudo generar la imagen del QR');
        return null;
      }

      final pngBytes = byteData.buffer.asUint8List();

      // Guarda la imagen temporalmente
      final tempDir = await getTemporaryDirectory();
      final filePath = path.join(tempDir.path, '${pathName.split('/').last}.png');
      final file = File(filePath);
      await file.writeAsBytes(pngBytes);

      final storageResponse = await _client.storage.from(bucket).upload(
          '$pathName.png', file,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: false));

      if (storageResponse.isNotEmpty) {
        final String publicUrl =
            _client.storage.from(bucket).getPublicUrl('$pathName.png');
        return publicUrl;
      } else {
        debugPrint('Error al subir el QR al bucket');
        return null;
      }
    } catch (e) {
      debugPrint('Error en generación de QR: $e');
      return null;
    } finally {
      // Limpieza del archivo temporal si existe
      final tempDir = await getTemporaryDirectory();
      final filePath = path.join(tempDir.path, '$pathName.png');
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
    }
  }
}
