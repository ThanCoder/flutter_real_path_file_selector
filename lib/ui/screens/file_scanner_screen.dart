import 'dart:io';

import 'package:flutter/material.dart';
import 'package:real_path_file_selector/ui/components/file_grid_item.dart';
import 'package:real_path_file_selector/ui/components/file_list_item.dart';
import 'package:real_path_file_selector/ui/enums/list_styles.dart';
import 'package:real_path_file_selector/ui/enums/sort_types.dart';
import 'package:real_path_file_selector/ui/models/file_model.dart';
import 'package:real_path_file_selector/ui/services/file_services.dart';
import 'package:real_path_file_selector/ui/widgets/core/index.dart';
import 'package:than_pkg/than_pkg.dart';

class FileScannerScreen extends StatefulWidget {
  String? title;
  String mimeType;
  String? thumbnailDirPath;
  void Function(List<String> selectedPath) onSelected;

  FileScannerScreen({
    super.key,
    required this.onSelected,
    required this.mimeType,
    this.title,
    this.thumbnailDirPath,
  });

  @override
  State<FileScannerScreen> createState() => _FileScannerScreenState();
}

class _FileScannerScreenState extends State<FileScannerScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  List<FileModel> fileList = [];
  bool isLoading = false;
  bool isShowHidden = false;
  String rootPath = '';
  Map<SortTypes, bool> sortType = {SortTypes.date: false};
  int selectedCount = 0;
  ListStyles style = ListStyles.list;

  Future<void> init() async {
    try {
      if (Platform.isAndroid &&
          !await ThanPkg.android.permission.isStoragePermissionGranted()) {
        await ThanPkg.android.permission.requestStoragePermission();
        if (!mounted) return;
        Navigator.pop(context);
        return;
      }
      setState(() {
        isLoading = true;
      });
      fileList = await FileServices.instance.scanList(
        isShowHidden: isShowHidden,
        sortType: sortType,
        mimeType: widget.mimeType,
      );
      //gen cover
      if (widget.thumbnailDirPath != null) {
        final videoPathList =
            fileList
                .where((f) => f.mime.startsWith('video'))
                .map((f) => f.path)
                .toList();
        final pdfPathList =
            fileList
                .where((f) => f.mime.startsWith('application/pdf'))
                .map((f) => f.path)
                .toList();
        //gen video thumbnail
        await ThanPkg.platform.genVideoCover(
          outDirPath: widget.thumbnailDirPath!,
          videoPathList: videoPathList,
        );
        //gen pdf thumbnail
        await ThanPkg.platform.genPdfCover(
          outDirPath: widget.thumbnailDirPath!,
          pdfPathList: pdfPathList,
        );
      }

      if (!mounted) return;

      setState(() {
        isLoading = false;
        selectedCount = 0;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> scanPath(String path) async {
    try {
      FocusScope.of(context).unfocus();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // void _showMenu() {
  //   showDialog(
  //     context: context,
  //     // barrierDismissible: false,
  //     builder:
  //         (context) => StatefulBuilder(
  //           builder:
  //               (context, setState) => AlertDialog(
  //                 content: SingleChildScrollView(
  //                   child: Column(
  //                     children: [
  //                       CheckboxListTile(
  //                         title: Text('Is Show Hidden'),
  //                         value: isShowHidden,
  //                         onChanged: (value) {
  //                           setState(() {
  //                             isShowHidden = value!;
  //                           });
  //                         },
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 actions: [
  //                   TextButton(
  //                     onPressed: () {
  //                       Navigator.pop(context);
  //                       scanPath(currentPath);
  //                     },
  //                     child: Text('Apply'),
  //                   ),
  //                 ],
  //               ),
  //         ),
  //   );
  // }

  void _toggleSelect(FileModel file) {
    selectedCount = 0;
    final res =
        fileList.map((f) {
          if (f.path == file.path) {
            f.isSelected = !f.isSelected;
          }
          if (f.isSelected) {
            selectedCount++;
          }
          return f;
        }).toList();

    setState(() {
      fileList = res;
    });
  }

  void _choose() {
    Navigator.pop(context);
    final list =
        fileList.where((f) => f.isSelected).map((f) => f.path).toList();
    widget.onSelected(list);
  }

  Widget _getListWidget() {
    if (style == ListStyles.grid) {
      return GridView.builder(
        itemCount: fileList.length,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 150,
          mainAxisExtent: 150,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
        ),
        itemBuilder: (context, index) {
          return FileGridItem(
            thumbnailDirPath: widget.thumbnailDirPath,
            file: fileList[index],
            onClicked: (file) {
              if (file.type == FileSystemEntityType.directory) {
                scanPath(file.path);
                return;
              }
              if (file.type == FileSystemEntityType.file) {
                _toggleSelect(file);
              }
            },
          );
        },
      );
    }
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(),
      itemCount: fileList.length,
      itemBuilder: (context, index) {
        return FileListItem(
          thumbnailDirPath: widget.thumbnailDirPath,
          file: fileList[index],
          onClicked: (file) {
            if (file.type == FileSystemEntityType.directory) {
              scanPath(file.path);
              return;
            }
            if (file.type == FileSystemEntityType.file) {
              _toggleSelect(file);
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title == null ? 'File Scanner' : widget.title!),
        automaticallyImplyLeading: false,
        actions: [
          // IconButton(onPressed: _showMenu, icon: Icon(Icons.more_vert)),
          IconButton(
            onPressed: () {
              final res =
                  style == ListStyles.list ? ListStyles.grid : ListStyles.list;
              setState(() {
                style = res;
              });
            },
            icon: Icon(
              style == ListStyles.list ? Icons.grid_on_rounded : Icons.list,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          //list
          if (isLoading)
            Center(child: TLoader())
          else
            Expanded(
              child: RefreshIndicator.noSpinner(
                onRefresh: () async {
                  await init();
                },
                child: _getListWidget(),
              ),
            ),
          isLoading
              ? SizedBox.shrink()
              : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Close'),
                    ),
                    selectedCount != 0
                        ? ElevatedButton(
                          onPressed: _choose,
                          child: Text('Selected $selectedCount'),
                        )
                        : SizedBox.shrink(),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}
