import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;

class StorageService {
  final SupabaseClient _client = Supabase.instance.client;

  /// Sube una imagen de perfil y devuelve la URL pública
  Future<String?> uploadProfileImage(File file) async {
    try {
      final fileName = path.basename(file.path);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fullPath = 'usuario_$timestamp/$fileName';

      final storageResponse = await _client.storage
          .from('fotos_perfiles')
          .upload(
            fullPath,
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      if (storageResponse != null && storageResponse.isNotEmpty) {
        // Verificación correcta
        final String publicUrl =
            _client.storage.from('fotos_perfiles').getPublicUrl(fullPath);
        return publicUrl;
      } else {
        debugPrint('Error al subir la imagen de perfil: Upload falló');
        return null;
      }
    } catch (e) {
      debugPrint('Error al subir la imagen de perfil: $e');
      return null;
    }
  }

  Future<List<String>?> uploadProductImages(List<File> files) async {
    try {
      List<String> productImages = [];
      for (var file in files) {  
        final fileName = path.basename(file.path);
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final fullPath = '$timestamp-$fileName';

        final storageResponse = await _client.storage
            .from('productos')
            .upload(
              fullPath,
              file,
              fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
            );

        if (storageResponse.isNotEmpty) {
          final String publicUrl =
              _client.storage.from('productos').getPublicUrl(fullPath);
          productImages.add(publicUrl);
        } else {
          debugPrint('Error al subir la imagen de perfil: Upload falló');
          return null;
        }
      }
      return productImages;
    } catch (e) {
      debugPrint('Error al subir la imagen de perfil: $e');
      return null;
    }
  }

  /// Elimina una imagen de perfil
  Future<bool> deleteProfileImage(String pathName) async {
    try {
      final List<FileObject> response =
          await _client.storage.from('fotos_perfiles').remove([pathName]);

      if (response.isEmpty) {
        return true;
      } else {
        debugPrint('Error al eliminar la imagen de perfil: Eliminación falló');
        return false;
      }
    } catch (e) {
      debugPrint('Error al eliminar la imagen de perfil: $e');
      return false;
    }
  }

  /// Obtiene la URL pública de una imagen de perfil
  Future<String?> getProfileImageUrl(String path) async {
    try {
      final String publicUrl =
          _client.storage.from('fotos_perfiles').getPublicUrl(path);
      return publicUrl;
    } catch (e) {
      debugPrint('Error al obtener la URL de la imagen de perfil: $e');
      return null;
    }
  }

  /// Actualiza una imagen de perfil existente
  Future<String?> updateProfileImage(File file, String oldPath) async {
    try {
      // Primero elimina la imagen anterior
      await deleteProfileImage(oldPath);

      // Luego sube la nueva imagen
      return await uploadProfileImage(file);
    } catch (e) {
      debugPrint('Error al actualizar la imagen de perfil: $e');
      return null;
    }
  }
}
