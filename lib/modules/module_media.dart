
import 'dart:io';

import 'package:artrooms/beans/bean_file.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:path/path.dart' as path;


class ModuleMedia {

  Future<List<FileItem>> loadFileImages() async {

    List<FileItem> imageFiles = [];

    List<AssetEntity> assetFiles = [];

    PermissionState result = await PhotoManager.requestPermissionExtend();

    if(result.isAuth) {

      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(type: RequestType.image);

      for(AssetPathEntity album in albums) {

        await album.assetCountAsync.then((assetCount) async {
          List<AssetEntity> images = await album.getAssetListPaged(page: 0, size: assetCount);
          assetFiles.addAll(images);

          for(AssetEntity asset in images) {
            File? file = await asset.originFile;
            if(file != null) {
              FileItem fileItem = FileItem(file: file, name: file.path, path: file.path);
              if(!imageFiles.contains(fileItem)) {
                imageFiles.add(fileItem);
              }
            }
          }

        });

      }

      assetFiles.sort((a, b) {
        return b.createDateTime.compareTo(a.createDateTime);
      });

    } else {
      PhotoManager.openSetting();
    }

    return imageFiles;
  }

  Future<List<FileItem>> loadFilesMedia() async {
    List<FileItem> psdFiles = [];

    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    List<Directory> directories = [];

    final Directory? dir = await getDownloadsDirectory();

    final Directory? dir1 = await getDownloadsDirectory();
    final Directory? dir2 = await getExternalStorageDirectory();
    final Directory dir3 = await getApplicationDocumentsDirectory();

    directories.add(dir1!.parent);
    // directories.add(dir1!);
    // directories.add(dir2!);
    // directories.add(dir3);

    for (var directory in directories) {
      if (await directory.exists()) {
        await for (var entity in directory.list(recursive: true, followLinks: false)) {
          if (entity is File && path.extension(entity.path).toLowerCase() == '.psd') {

            final dateFormat = DateFormat('yyyy.MM.dd', 'ko_KR');
            final dateString = '${dateFormat.format(await entity.lastModified())} 만료';

            final fileItem = FileItem(
              file: entity,
              name: path.basename(entity.path),
              path: entity.path,
              date: dateString,
            );

            psdFiles.add(fileItem);
          }
        }
      }
    }

    return psdFiles;
  }


}