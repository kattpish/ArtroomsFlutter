
import 'package:photo_manager/photo_manager.dart';


class ModuleMedia {

  Future<List<AssetEntity>> loadImages() async {

    List<AssetEntity> imageFiles = [];

    PermissionState result = await PhotoManager.requestPermissionExtend();

    if(result.isAuth) {

      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(type: RequestType.image);

      for(AssetPathEntity album in albums) {

        await album.assetCountAsync.then((assetCount) async {
          List<AssetEntity> images = await album.getAssetListPaged(page: 0, size: assetCount);
          imageFiles.addAll(images);
        });

      }

      imageFiles.sort((a, b) {
        return b.createDateTime.compareTo(a.createDateTime);
      });

    } else {
      PhotoManager.openSetting();
    }

    return imageFiles;
  }

  Future<List<AssetEntity>> loadPSDFiles() async {
    return [];
  }

}
