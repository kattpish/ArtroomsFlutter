
import 'dart:io';
import 'package:artrooms/utils/utils_notifications.dart';
import 'package:artrooms/utils/utils_permissions.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';


String getFileName(File file) {
  return path.basename(Uri.parse(file.path).path);
}

Future<void> downloadFile(BuildContext context, String url, String fileName, {showNotification=true}) async {

  print('File downloading: $url $fileName');

  final response = await http.get(Uri.parse(url));

  print('File downloaded: ${response.body}');

  final bytes = response.bodyBytes;

  await requestPermissions(context);

  var directory;
  if (Platform.isIOS) {
    directory = await getDownloadsDirectory();
  } else {
    directory = "/storage/emulated/0/Download/";
    bool dirDownloadExists = await Directory(directory).exists();
    if(dirDownloadExists){
      directory = Directory("/storage/emulated/0/Download/");
    }else{
      directory = Directory("/storage/emulated/0/Downloads/");
    }
  }

  final Directory dir = await getDownloadsDirectory() ?? directory;


  fileName = fileName.isEmpty ? path.basename(Uri.parse(url).path) : fileName;

  final String filePath = path.join(dir.path, "Artrooms-$fileName")
      .replaceAll("/Android/data/com.artrooms/files/downloads", "/Download")
  ;

  final File file = File(filePath);

  print('File saving: ${file.path}');

  await file.writeAsBytes(bytes);

  print('File saved: ${file.path}');

  if(showNotification) {
    showNotificationDownload(filePath, fileName);
  }

}
