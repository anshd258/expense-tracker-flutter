import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class FileDownloadHelper {
  static Future<void> downloadFile({
    required Uint8List bytes,
    required String fileName,
  }) async {
    if (kIsWeb) {
      // Web implementation would go here, but since this is mobile-only
      throw UnimplementedError('File download not implemented for web platform');
    } else {
      await _downloadFileMobile(bytes, fileName);
    }
  }

  static Future<void> _downloadFileMobile(Uint8List bytes, String fileName) async {
    try {
      // Get the temporary directory
      final Directory tempDir = await getTemporaryDirectory();
      final String tempPath = tempDir.path;
      final String filePath = '$tempPath/$fileName';
      
      // Create the file
      final File file = File(filePath);
      await file.writeAsBytes(bytes);
      
      // Use share_plus to share the file
      // This will open the native share sheet where users can:
      // - Save to Files app (iOS)
      // - Save to Downloads or share via other apps (Android)
      final XFile xFile = XFile(filePath);
      
      await Share.shareXFiles(
        [xFile],
        subject: 'Expense Report Export',
        text: 'Your expense report has been exported to CSV format.',
      );
      
      // Clean up the temp file after a delay
      // The share sheet copies the file, so we can delete the temp
      Future.delayed(const Duration(seconds: 30), () {
        if (file.existsSync()) {
          file.deleteSync();
        }
      });
    } catch (e) {
      throw Exception('Failed to save file: $e');
    }
  }
}