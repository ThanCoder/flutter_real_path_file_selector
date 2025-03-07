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
  Future<void> _fileExplor() async {
    final pathList = await RealPathFileSelector.openFileExplorer.open(
      context,
      // mimeTypes: ['video'],
      title: 'Choose Video File',
      thumbnailDirPath: '/home/thancoder/Documents',
    );
    debugPrint(pathList.toString());
  }

  void _scanVideo() async {
    final scannerPathList = await RealPathFileSelector.openFileScanner.open(
      context,
      mimeType: 'application/pdf',
      thumbnailDirPath: '/home/thancoder/Documents',
    );
    debugPrint(scannerPathList.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Real Path File Chooser')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            TextButton(onPressed: _scanVideo, child: Text('Scan Video')),
            TextButton(onPressed: _fileExplor, child: Text('File Explorer')),
          ],
        ),
      ),
    );
  }
}
