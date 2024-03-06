
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../../utils/utils_media.dart';
import '../theme/theme_colors.dart';


void viewPhoto(BuildContext context, State state, {String imagePath="", String imageUrl="", String fileName=""}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {

      bool isDownloading = false;

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
              Center(
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
                  ],
                ),
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
              Visibility(
                visible: imageUrl.isNotEmpty,
                child: Positioned(
                  bottom: 18,
                  left: 29,
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: isDownloading
                          ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Color(0xFF6A79FF),
                          strokeWidth: 3,
                        ),
                      )
                          : IconButton(
                        icon: const Icon(
                          Icons.file_download_outlined,
                          size: 32,
                          color: colorMainGrey300,
                        ),
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(),
                        onPressed: () async {

                          state.setState(() {
                            isDownloading = true;
                          });

                          await downloadFile(imageUrl, fileName);

                          state.setState(() {
                            isDownloading = false;
                          });

                        },
                      ),
                    )
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
