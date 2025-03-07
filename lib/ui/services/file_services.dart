import 'dart:io';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:real_path_file_selector/ui/enums/sort_types.dart';
import 'package:real_path_file_selector/ui/extensions/index.dart';
import 'package:real_path_file_selector/ui/models/file_model.dart';
import 'package:than_pkg/than_pkg.dart';

class FileServices {
  static final FileServices instance = FileServices._();
  FileServices._();
  factory FileServices() => instance;

  Future<List<FileModel>> getList(
    String path, {
    bool isShowHidden = false,
    required Map<SortTypes, bool> sortType,
  }) async {
    List<FileModel> fileList = [];

    final dir = Directory(path);
    if (!await dir.exists()) [];

    await for (var file in dir.list()) {
      fileList.add(
        FileModel(
          name: file.path.getName(),
          path: '$path/${file.path.getName()}',
          mime: lookupMimeType(file.path) ?? '',
          type: file.statSync().type,
          size: file.statSync().size,
          date: file.statSync().modified.millisecondsSinceEpoch,
        ),
      );
    }
    //hidden filter
    if (!isShowHidden) {
      //hidden file ကို hide ထားမယ်
      fileList = fileList.where((f) => !f.name.startsWith('.')).toList();
    }
    //sort လုပ်မယ်
    fileList = _sort(fileList);
    return fileList;
  }

  Future<List<FileModel>> scanList({
    required Map<SortTypes, bool> sortType,
    required String mimeType,
    bool isShowHidden = false,
  }) async {
    //filter dir for android,linux
    final home = await ThanPkg.platform.getAppExternalPath() ?? '';
    if (home.isEmpty) return [];
    List<String> filterDir = ['Android', 'DCMI'];
    List<String> scanHomeList = [];
    if (Platform.isAndroid) {
      scanHomeList.add(home);
    } else if (Platform.isLinux) {
      scanHomeList.add('$home/Downloads');
      scanHomeList.add('$home/Videos');
      scanHomeList.add('$home/Documents');
      scanHomeList.add('$home/Desktop');
      scanHomeList.add('$home/Music');
      scanHomeList.add('$home/Pictures');
    }

    return await Isolate.run<List<FileModel>>(() async {
      List<FileModel> fileList = [];
      try {
        //scan
        void scan(Directory dir) async {
          try {
            for (final file in dir.listSync()) {
              //skip hidden
              final name = file.path.getName();
              if (name.startsWith('.') || filterDir.contains(name)) continue;
              if (file.statSync().type == FileSystemEntityType.file) {
                //check
                final mime = lookupMimeType(file.path) ?? '';
                if (mime.isEmpty) continue;

                //mime type မတူရင် ကျော်မယ်
                if (!mime.contains(mimeType)) continue;
                fileList.add(
                  FileModel(
                    name: file.path.getName(),
                    path: file.path,
                    mime: lookupMimeType(file.path) ?? '',
                    type: file.statSync().type,
                    size: file.statSync().size,
                    date: file.statSync().modified.millisecondsSinceEpoch,
                  ),
                );
              } else if (file.statSync().type ==
                  FileSystemEntityType.directory) {
                scan(Directory(file.path));
              }
            }
          } catch (e) {
            debugPrint(e.toString());
          }
        }

        for (var homeDir in scanHomeList) {
          final dirPath = Directory(homeDir);
          if (await dirPath.exists()) {
            scan(dirPath);
          }
        }
      } catch (e) {
        debugPrint(e.toString());
      }
      return fileList;
    });
  }

  List<FileModel> _sort(List<FileModel> list) {
    list.sort((a, b) {
      bool isDotA = a.name.startsWith('.');
      bool isDotB = b.name.startsWith('.');
      bool isFolderA = a.type == FileSystemEntityType.directory;
      bool isFolderB = b.type == FileSystemEntityType.directory;
      //. ကို အပေါ်တင်မယ်
      if (isDotA && !isDotB) return -1; // a is hidden folder -> a to top
      if (!isDotA && isDotB) return 1; // a not hidden folder -> b to top
      //folder အပေါ်တင်မယ်
      if (isFolderA && !isFolderB) return -1;
      if (!isFolderA && isFolderB) return 1;

      //name ကို a-z sort လုပ်မယ်
      return a.name.toUpperCase().compareTo(b.name.toUpperCase());
    });
    return list;
  }
}
