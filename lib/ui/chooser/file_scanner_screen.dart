import 'dart:io';

import 'package:flutter/material.dart';
import 'package:real_path_file_selector/ui/components/file_list_item.dart';
import 'package:real_path_file_selector/ui/enums/sort_types.dart';
import 'package:real_path_file_selector/ui/models/file_model.dart';
import 'package:real_path_file_selector/ui/services/file_services.dart';
import 'package:real_path_file_selector/ui/widgets/core/index.dart';
import 'package:than_pkg/than_pkg.dart';

class FileScannerScreen extends StatefulWidget {
  String? title;
  String mimeType;
  void Function(List<String> selectedPath) onSelected;
  FileScannerScreen({
    super.key,
    required this.onSelected,
    required this.mimeType,
    this.title,
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

  final TextEditingController pathController = TextEditingController();
  String currentPath = '';
  List<FileModel> fileList = [];
  bool isLoading = false;
  bool isShowHidden = false;
  String rootPath = '';
  Map<SortTypes, bool> sortType = {SortTypes.date: false};
  int selectedCount = 0;

  void init() async {
    try {
      if (Platform.isAndroid &&
          !await ThanPkg.android.permission.isStoragePermissionGranted()) {
        await ThanPkg.android.permission.requestStoragePermission();
        if (!mounted) return;
        Navigator.pop(context);
        return;
      }
      rootPath = await ThanPkg.platform.getAppExternalPath() ?? '';
      setState(() {
        currentPath = rootPath;
      });
      pathController.text = rootPath;
      scanPath(rootPath);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> scanPath(String path) async {
    try {
      FocusScope.of(context).unfocus();

      setState(() {
        isLoading = true;
      });
      fileList = await FileServices.instance.scanList(
        path,
        isShowHidden: isShowHidden,
        sortType: sortType,
        mimeType: widget.mimeType,
      );

      setState(() {
        isLoading = false;
        currentPath = path;
        selectedCount = 0;
      });
      pathController.text = path;
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
          if (f.name == file.name) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title == null ? 'File Scanner' : widget.title!),
        // actions: [
        //   IconButton(onPressed: _showMenu, icon: Icon(Icons.more_vert)),
        // ],
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
                  await scanPath(currentPath);
                },
                child: ListView.separated(
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: fileList.length,
                  itemBuilder: (context, index) {
                    return FileListItem(
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
                ),
              ),
            ),
          selectedCount != 0
              ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: _choose,
                      child: Text('Selected $selectedCount'),
                    ),
                  ],
                ),
              )
              : SizedBox(),
        ],
      ),
    );
  }
}
