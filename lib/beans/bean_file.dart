
import 'dart:io';


class FileItem {

  File file;
  File? thumbFile;
  String name;
  String date;
  String path;
  String url;
  bool isSelected;
  int index;
  int timeSelected;

  FileItem({
    required this.file,
    this.thumbFile,
    this.name = "",
    this.date = "",
    this.path = "",
    this.url = "",
    this.isSelected = false,
    this.index = 0,
    this.timeSelected = 0,
  });

  File getPreviewFile() {
    return thumbFile ?? file;
  }

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
