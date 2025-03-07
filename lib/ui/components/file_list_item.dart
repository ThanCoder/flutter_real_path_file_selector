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
  double size;
  FileModel file;
  void Function(FileModel file) onClicked;
  FileListItem({
    super.key,
    required this.file,
    required this.onClicked,
    this.mimeTypes,
    this.thumbnailDirPath,
    this.size = 80,
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
      return MyImageFile(path: file.path, width: size, height: size);
    }
    if (file.mime.startsWith('video') && thumbnailDirPath != null) {
      return MyImageFile(
        path: '$thumbnailDirPath/${file.name.getName(withExt: false)}.png',
        width: size,
        height: size,
      );
    }
    if (file.mime.startsWith('application/pdf') && thumbnailDirPath != null) {
      return MyImageFile(
        path: '$thumbnailDirPath/${file.name.getName(withExt: false)}.png',
        width: size,
        height: size,
      );
    }

    return Icon(_getIconData(), size: size);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_isEnable()) {
          onClicked(file);
        }
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          padding: EdgeInsets.all(5),
          duration: Duration(milliseconds: 1300),
          color:
              file.isSelected ? const Color.fromARGB(132, 52, 187, 173) : null,
          child: Row(
            spacing: 10,
            children: [
              _getImage(),
              Expanded(
                child: Column(
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
                        : Text(
                          AppUtil.instance.getParseFileSize(
                            file.size.toDouble(),
                          ),
                        ),
                    Text(AppUtil.instance.getParseDate(file.date)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    /*
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
    */
  }
}
