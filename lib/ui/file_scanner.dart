import 'dart:async';

import 'package:flutter/material.dart';
import 'package:real_path_file_selector/real_path_file_selector_method_channel.dart';
import 'package:real_path_file_selector/ui/screens/file_scanner_screen.dart';

class FileScanner extends MethodChannelRealPathFileSelector {
  static final FileScanner instance = FileScanner._();
  FileScanner._();
  factory FileScanner() => instance;

  Future<List<String>> open(
    BuildContext context, {
    required String mimeType,
    String? title,
    String? thumbnailDirPath,
  }) async {
    final completer = Completer<List<String>>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => FileScannerScreen(
              title: title,
              mimeType: mimeType,
              onSelected: completer.complete,
              thumbnailDirPath: thumbnailDirPath,
            ),
      ),
    );
    return completer.future;
  }
}
