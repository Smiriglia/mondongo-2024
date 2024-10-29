import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;
import 'package:mondongo/models/dueno_supervisor.dart';
import 'package:logging/logging.dart';

class DuenoSupervisorService {
  final SupabaseClient _client = Supabase.instance.client;
  final _logger = Logger('DuenoSupervisorService');

  Future<String?> uploadFoto(File file, String dni) async {
    try {
      final fileName = path.basename(file.path);
      final storageResponse = await _client.storage
          .from('fotos_perfiles')
          .upload('dueños_supervisores/$dni/$fileName', file);

      if (storageResponse != null) {
        final urlResponse = _client.storage
            .from('fotos_perfiles')
            .getPublicUrl('dueños_supervisores/$dni/$fileName');

        return urlResponse;
      }
      return null;
    } catch (e) {
      _logger.severe('Error al subir la foto: $e');
      return null;
    }
  }

  Future<bool> crearDuenoSupervisor(DuenoSupervisor dueno) async {
    try {
      final response =
          await _client.from('dueños_supervisores').insert(dueno.toJson());

      return response.status == 201;
    } catch (e) {
      _logger.severe('Error al crear dueño/supervisor: $e');
      return false;
    }
  }
}
