

class FileItem {

  String name;
  String date;
  String path;
  bool isSelected;

  FileItem({
    required this.name,
    this.date = "",
    this.path = "",
    this.isSelected = false
  });

}
