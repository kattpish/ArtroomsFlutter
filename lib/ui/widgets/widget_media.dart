
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../../beans/bean_file.dart';
import '../theme/theme_colors.dart';


void viewPhotoUrl(BuildContext context, String imageUrl) {
  viewPhoto(context, "", imageUrl);
}

void viewPhotoFile(BuildContext context, FileItem file) {
  viewPhoto(context, file.path, "");
}

void viewPhoto(BuildContext context, String imagePath, String imageUrl) {
  showDialog(
    context: context,
    builder: (BuildContext context) {

      ImageProvider imageProvider;
      if (imagePath.isNotEmpty) {
        imageProvider = AssetImage(imagePath);
      } else {
        imageProvider = NetworkImage(imageUrl);
      }

      return Scaffold(
        backgroundColor: Colors.black.withOpacity(0.40),
        body: Container(
          color: Colors.black.withOpacity(0.5),
          child: Stack(
            children: [
              PhotoView(
                imageProvider: imageProvider,
                backgroundDecoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                ),
                loadingBuilder: (context, event) => Center(
                  child: CircularProgressIndicator(
                    value: event == null ? 0 : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
                  ),
                ),
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/profile/placeholder.png',
                    fit: BoxFit.cover,
                  );
                },
              ),
              Positioned(
                top: 18,
                right: 18,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: colorMainGrey250,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        size: 22,
                        color: Colors.black,
                      ),
                      padding: const EdgeInsets.all(4),
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  )
              ),
              Positioned(
                bottom: 18,
                left: 29,
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: IconButton(
                      icon: const Icon(
                        Icons.file_download_outlined,
                        size: 32,
                        color: colorMainGrey300,
                      ),
                      padding: const EdgeInsets.all(4),
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  )
              ),
            ],
          ),
        ),
      );
    },
  );
}
