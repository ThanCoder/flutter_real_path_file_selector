# real_path_file_selector

## Initial Added

```Dart
final scannerPathList = await RealPathFileSelector.openFileScanner.open(
    context,
    mimeType: 'video',
);
debugPrint(scannerPathList.toString());

final pathList = await RealPathFileSelector.openFileExplorer.open(
    context,
    mimeTypes: ['video'],
    title: 'Choose Video File',
);
debugPrint(pathList.toString());
```
