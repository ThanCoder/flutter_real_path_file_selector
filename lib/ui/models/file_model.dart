// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

class FileModel {
  String name;
  String path;
  String mime;
  FileSystemEntityType type;
  int size;
  int date;
  bool isSelected = false;
  FileModel({
    required this.name,
    required this.path,
    required this.mime,
    required this.type,
    required this.size,
    required this.date,
  });
}
