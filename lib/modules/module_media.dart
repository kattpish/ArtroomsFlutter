
import 'dart:io';

import 'package:artrooms/beans/bean_file.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:path/path.dart' as path;


class ModuleMedia {

  bool isLoadingImages = false;
  bool isLoadingMedia = false;
  List<FileItem> imageFiles = [];
  List<FileItem> mediaFiles = [];

  Future<void> init() async {

    if(!isLoadingImages) {
      isLoadingImages = true;

      loadFileImages().then((List<FileItem> listImages) {
        imageFiles.addAll(listImages);

        isLoadingImages = false;
      });

    }else {
      Iterator<FileItem> iterator = imageFiles.iterator;
      while (iterator.moveNext()) {
        FileItem currentFileItem = iterator.current;
        if (!await currentFileItem.file.exists()) {
          imageFiles.remove(currentFileItem);
          iterator = imageFiles.iterator;
        }
      }
    }

    if(false) {
      if (!isLoadingMedia) {
        isLoadingMedia = true;

        loadFilesMedia().then((List<FileItem> listMedia) {
          mediaFiles.addAll(listMedia);

          isLoadingMedia = false;
        });
      } else {
        Iterator<FileItem> iterator = mediaFiles.iterator;
        while (iterator.moveNext()) {
          FileItem currentFileItem = iterator.current;
          if (!await currentFileItem.file.exists()) {
            mediaFiles.remove(currentFileItem);
            iterator = mediaFiles.iterator;
          }
        }
      }
    }

  }

  Future<List<FileItem>> loadFileImages() async {

    if(imageFiles.isNotEmpty) return imageFiles;

    List<FileItem> imageFiles1 = await loadFileImages1();
    // List<FileItem> imageFiles2 = await loadFileImages2();

    imageFiles.addAll(imageFiles1);
    // imageFiles.addAll(imageFiles2);

    imageFiles.sort((a, b) {
      return b.date.compareTo(a.date);
    });

    return imageFiles;
  }

  Future<List<FileItem>> loadFileImages1() async {

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

  Future<List<FileItem>> loadFileImages2() async {

    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    List<Directory> directories = [];

    final Directory? dir = (await getDownloadsDirectory())?.parent.parent.parent.parent.parent;

    final Directory? dir1 = await getDownloadsDirectory();
    final Directory dir3 = await getApplicationDocumentsDirectory();

    directories.add(dir!);
    directories.add(dir1!);
    directories.add(dir3);

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
    directories.add(directory);

    var directoryRoot;
    if (Platform.isIOS) {
      directoryRoot = await getDownloadsDirectory();
    } else {
      directoryRoot = "/storage/emulated/0/";
      bool dirDownloadExists = await Directory(directoryRoot).exists();
      if(dirDownloadExists){
        directoryRoot = Directory("/storage/emulated/0/");
      }else{
        directoryRoot = Directory("/storage/emulated/0/");
      }
    }
    directories.add(directoryRoot);

    for (var directory in directories) {

      try {

        if (await directory.exists()) {

          await for (var entity in directory.list(recursive: true, followLinks: false)) {

            if (entity is File) {

              final String fileExtension = path.extension(entity.path).toLowerCase();
              final bool isImage = ['.jpg', '.jpeg', '.png', '.gif', '.bmp'].contains(fileExtension);

              if (isImage) {

                final dateFormat = DateFormat('yyyy.MM.dd', 'ko_KR');
                final dateString = '${dateFormat.format(await entity.lastModified())} 만료';

                final fileItem = FileItem(
                  file: entity,
                  name: path.basename(entity.path),
                  path: entity.path,
                  date: dateString,
                );

                if (!imageFiles.contains(fileItem)) {
                  imageFiles.add(fileItem);
                }
              }
            }
          }
        }

      }catch(error) {
        print(error);
      }
    }

    return imageFiles;
  }

  Future<List<FileItem>> loadFilesMedia() async {

    if(mediaFiles.isNotEmpty) return mediaFiles;

    List<FileItem> mediaFiles1 = await loadFilesMedia1();
    List<FileItem> mediaFiles2 = await loadFilesMedia2();

    mediaFiles.addAll(mediaFiles1);
    mediaFiles.addAll(mediaFiles2);

    mediaFiles.sort((a, b) {
      return b.date.compareTo(a.date);
    });

    return mediaFiles;
  }

  Future<List<FileItem>> loadFilesMedia1() async {

    List<AssetEntity> assetFiles = [];

    PermissionState result = await PhotoManager.requestPermissionExtend();

    if(result.isAuth) {

      List<AssetPathEntity> albums = [];

      List<AssetPathEntity> albums1 = await PhotoManager.getAssetPathList(type: RequestType.video);
      List<AssetPathEntity> albums2 = await PhotoManager.getAssetPathList(type: RequestType.audio);

      albums.addAll(albums1);
      albums.addAll(albums2);

      for(AssetPathEntity album in albums) {

        await album.assetCountAsync.then((assetCount) async {
          List<AssetEntity> images = await album.getAssetListPaged(page: 0, size: assetCount);
          assetFiles.addAll(images);

          for(AssetEntity asset in images) {
            File? file = await asset.originFile;
            if(file != null) {

              final String fileExtension = path.extension(asset.title ?? asset.id).toLowerCase();
              final bool isNotImage = !['.jpg', '.jpeg', '.png', '.gif', '.bmp'].contains(fileExtension);

              final dateFormat = DateFormat('yyyy.MM.dd', 'ko_KR');
              final dateString = '${dateFormat.format(asset.createDateTime)} 만료';

              if(isNotImage) {
                FileItem fileItem = FileItem(
                  file: file,
                  name: asset.title ?? asset.id,
                  path: file.path,
                  date: dateString,
                );

                if (!mediaFiles.contains(fileItem)) {
                  mediaFiles.add(fileItem);
                }
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

    return mediaFiles;
  }

  Future<List<FileItem>> loadFilesMedia2() async {

    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    List<Directory> directories = [];

    final Directory? dir = (await getDownloadsDirectory())?.parent;

    final Directory? dir1 = await getDownloadsDirectory();
    final Directory? dir2 = await getExternalStorageDirectory();
    final Directory dir3 = await getApplicationDocumentsDirectory();

    directories.add(dir!);
    directories.add(dir1!);
    directories.add(dir2!);
    directories.add(dir3);

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
    directories.add(directory);

    var directoryRoot;
    if (Platform.isIOS) {
      directoryRoot = await getDownloadsDirectory();
    } else {
      directoryRoot = "/storage/emulated/0/";
      bool dirDownloadExists = await Directory(directoryRoot).exists();
      if(dirDownloadExists){
        directoryRoot = Directory("/storage/emulated/0/");
      }else{
        directoryRoot = Directory("/storage/emulated/0/");
      }
    }
    directories.add(directoryRoot);

    for (var directory in directories) {

      try {

        print(directory.path);

        if (await directory.exists()) {
          await for (var entity in directory.list(recursive: true, followLinks: false)) {
            if (entity is File) {

              final String fileExtension = path.extension(entity.path).toLowerCase();
              final bool isNotImage = !['.jpg', '.jpeg', '.png', '.gif', '.bmp'].contains(fileExtension);

              if (isNotImage) {

                final dateFormat = DateFormat('yyyy.MM.dd', 'ko_KR');
                final dateString = '${dateFormat.format(await entity.lastModified())} 만료';

                final fileItem = FileItem(
                  file: entity,
                  name: path.basename(entity.path),
                  path: entity.path,
                  date: dateString,
                );

                if(!mediaFiles.contains(fileItem)) {
                  mediaFiles.add(fileItem);
                }

              }

            }
          }
        }

      }catch(error) {
        print(error);
      }
    }

    return mediaFiles;
  }

}