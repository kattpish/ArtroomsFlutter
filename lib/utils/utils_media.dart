
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:artrooms/utils/utils_notifications.dart';
import 'package:artrooms/utils/utils_permissions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

final customCacheManager = CacheManager(
  Config(
    'customCacheKey',
    stalePeriod: const Duration(days: 15),
    maxNrOfCacheObjects: 100,
    repo: JsonCacheInfoRepository(databaseName: 'artrooms-cache.db'),
    fileService: HttpFileService(),
  ),
);

String getFileName(File file) {
  return path.basename(Uri.parse(file.path).path);
}

bool isFileImage(fileExtension) {
  return ['.jpg', '.jpeg', '.png', '.gif', '.bmp'].contains(fileExtension);
}

Future<void> downloadFile(BuildContext context, String url, String fileName,
    {showNotification = true}) async {
  if (kDebugMode) {
    print('File downloading: $url $fileName');
  }

  final response = await http.get(Uri.parse(url));

  if (kDebugMode) {
    print('File downloaded: ${response.body}');
  }

  final bytes = response.bodyBytes;

  await requestPermissions(context);

  var directory;
  if (Platform.isIOS) {
    directory = await getDownloadsDirectory();
  } else {
    directory = "/storage/emulated/0/Download/";
    bool dirDownloadExists = await Directory(directory).exists();
    if (dirDownloadExists) {
      directory = Directory("/storage/emulated/0/Download/");
    } else {
      directory = Directory("/storage/emulated/0/Downloads/");
    }
  }

  final Directory dir = await getDownloadsDirectory() ?? directory;

  fileName = fileName.isEmpty ? path.basename(Uri.parse(url).path) : fileName;

  final String filePath = path
      .join(dir.path, "Artrooms-$fileName")
      .replaceAll("/Android/data/com.artrooms/files/downloads", "/Download");

  final File file = File(filePath);

  if (kDebugMode) {
    print('File saving: ${file.path}');
  }

  await file.writeAsBytes(bytes);

  if (kDebugMode) {
    print('File saved: ${file.path}');
  }

  if (showNotification) {
    showNotificationDownload(filePath, fileName);
  }
}

Future<List<String>> getAllTunes() async {
  List<String> tuneName = [];
  try {
    final manifestJson = await rootBundle.loadString('AssetManifest.json');
    final Iterable<String> images = json
        .decode(manifestJson)
        .keys
        .where((String key) => key.startsWith('assets/sounds'));
    for (var element in images) {
      var elementFinal =
          element.replaceAll("assets/sounds/", "").replaceAll(".mp3", "");
      tuneName.add(elementFinal);
    }
    return tuneName;
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
    return tuneName;
  }
}
