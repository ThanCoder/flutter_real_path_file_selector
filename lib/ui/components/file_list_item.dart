import 'dart:io';

import 'package:flutter/material.dart';
import 'package:real_path_file_selector/ui/extensions/index.dart';
import 'package:real_path_file_selector/ui/models/file_model.dart';
import 'package:real_path_file_selector/ui/utils/index.dart';
import 'package:real_path_file_selector/ui/widgets/index.dart';

class FileListItem extends StatelessWidget {
  List<String>? mimeTypes;
  List<String>? extensions;
  String? thumbnailDirPath;
  FileModel file;
  void Function(FileModel file) onClicked;
  FileListItem({
    super.key,
    required this.file,
    required this.onClicked,
    this.mimeTypes,
    this.thumbnailDirPath,
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

  IconData _getIconData() {
    if (file.type == FileSystemEntityType.directory) {
      return Icons.folder;
    }
    if (file.mime.startsWith('video')) {
      return Icons.video_file_rounded;
    }
    if (file.mime.startsWith('audio')) {
      return Icons.audio_file_rounded;
    }
    if (file.mime.startsWith('image')) {
      return Icons.image;
    }
    if (file.mime.startsWith('application/pdf')) {
      return Icons.picture_as_pdf_rounded;
    }
    if (file.mime.startsWith('application/zip')) {
      return Icons.folder_zip_rounded;
    }

    return Icons.file_present_sharp;
  }

  Widget _getImage() {
    if (file.mime.startsWith('image')) {
      return MyImageFile(path: file.path);
    }
    if (file.mime.startsWith('video') && thumbnailDirPath != null) {
      return MyImageFile(
        path: '$thumbnailDirPath/${file.name.getName(withExt: false)}.png',
        width: 50,
        height: 50,
      );
    }

    return Icon(_getIconData(), size: 50);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      enabled: _isEnable(),
      selected: file.isSelected,
      onTap: () => onClicked(file),
      leading: _getImage(),
      title: Column(
        spacing: 5,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            file.name,
            style: TextStyle(fontSize: 14),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
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
