import 'dart:async';

import 'package:flutter/material.dart';
import 'package:real_path_file_selector/real_path_file_selector_method_channel.dart';
import 'package:real_path_file_selector/ui/chooser/file_chooser_screen.dart';

class FileExplorer extends MethodChannelRealPathFileSelector {
  static final FileExplorer instance = FileExplorer._();
  FileExplorer._();
  factory FileExplorer() => instance;

  Future<List<String>> open(
    BuildContext context, {
    List<String>? mimeTypes,
    String? title,
  }) async {
    final completer = Completer<List<String>>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => FileChooserScreen(
              title: title,
              mimeTypes: mimeTypes,
              onSelected: completer.complete,
            ),
      ),
    );
    return completer.future;
  }
}
