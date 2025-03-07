import 'dart:io';

import 'package:flutter/material.dart';
import 'package:real_path_file_selector/ui/extensions/string_extension.dart';
import 'package:real_path_file_selector/ui/models/file_model.dart';
import 'package:real_path_file_selector/ui/widgets/core/index.dart';

class FileGridItem extends StatelessWidget {
  List<String>? mimeTypes;
  List<String>? extensions;
  String? thumbnailDirPath;
  FileModel file;
  void Function(FileModel file) onClicked;
  FileGridItem({
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
      return MyImageFile(path: file.path, width: double.infinity);
    }
    if (file.mime.startsWith('video') && thumbnailDirPath != null) {
      return MyImageFile(
        path: '$thumbnailDirPath/${file.name.getName(withExt: false)}.png',
        width: double.infinity,
      );
    }

    return Icon(_getIconData(), size: 120);
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
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color:
                file.isSelected
                    ? Colors.teal
                    : const Color.fromARGB(45, 0, 0, 0),
          ),
          child: Stack(
            children: [
              Column(
                spacing: 5,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Expanded(child: _getImage())],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(195, 0, 0, 0),
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(5),
                      bottomLeft: Radius.circular(5),
                    ),
                  ),
                  child: Text(
                    file.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
