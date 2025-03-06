import 'dart:io';

import 'package:flutter/material.dart';
import 'package:real_path_file_selector/ui/models/file_model.dart';
import 'package:real_path_file_selector/ui/utils/index.dart';

class FileListItem extends StatelessWidget {
  List<String>? mimeTypes;
  List<String>? extensions;
  FileModel file;
  void Function(FileModel file) onClicked;
  FileListItem({
    super.key,
    required this.file,
    required this.onClicked,
    this.mimeTypes,
  });

  bool _isEnable() {
    if (file.type == FileSystemEntityType.directory) {
      return true;
    }
    //mime type ရှိနေရင်
    if (mimeTypes != null && mimeTypes!.isNotEmpty) {
      return mimeTypes!.any((mime) => file.mime.startsWith(mime));
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      enabled: _isEnable(),
      selected: file.isSelected,
      onTap: () => onClicked(file),
      leading: Icon(
        file.type == FileSystemEntityType.directory
            ? Icons.folder
            : Icons.file_present_sharp,
        size: 40,
      ),
      title: Column(
        spacing: 5,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(file.name),
          // Text(file.mime),
          file.type == FileSystemEntityType.directory
              ? SizedBox()
              : Text(AppUtil.instance.getParseFileSize(file.size.toDouble())),
          Text(AppUtil.instance.getParseDate(file.date)),
        ],
      ),
    );
  }
}
