import 'package:flutter/material.dart';
import 'dart:async';

import 'package:real_path_file_selector/real_path_file_selector.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyApp(),
      // darkTheme: ThemeData.dark(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> _test() async {
    final scannerPathList = await RealPathFileSelector.openFileScanner.open(
      context,
      mimeType: 'video',
      thumbnailDirPath: '/home/thancoder/Documents',
    );
    debugPrint(scannerPathList.toString());

    // final pathList = await RealPathFileSelector.openFileExplorer.open(
    //   context,
    //   mimeTypes: ['video'],
    //   title: 'Choose Video File',
    //   thumbnailDirPath: '/home/thancoder/Documents',
    // );
    // debugPrint(pathList.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Real Path File Chooser')),
      body: Placeholder(),
      floatingActionButton: FloatingActionButton(
        onPressed: _test,
        child: Text('Test'),
      ),
    );
  }
}
