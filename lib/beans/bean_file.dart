
import 'dart:io';


class FileItem {

  File file;
  String name;
  String date;
  String path;
  bool isSelected;

  FileItem({
    required this.file,
    this.name = "",
    this.date = "",
    this.path = "",
    this.isSelected = false
  });

  @override
  bool operator == (Object other) {
    return identical(this, other) || other is FileItem
        && runtimeType == other.runtimeType
        && path == other.path;
  }

  @override
  int get hashCode {
    return path.hashCode;
  }
  
}
