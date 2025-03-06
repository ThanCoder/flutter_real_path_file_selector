import 'dart:async';

import 'package:flutter/material.dart';
import 'package:real_path_file_selector/real_path_file_selector_method_channel.dart';
import 'package:real_path_file_selector/ui/chooser/file_scanner_screen.dart';

class FileScanner extends MethodChannelRealPathFileSelector {
  static final FileScanner instance = FileScanner._();
  FileScanner._();
  factory FileScanner() => instance;

  Future<List<String>> open(
    BuildContext context, {
    required String mimeType,
    String? title,
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
            ),
      ),
    );
    return completer.future;
  }
}
