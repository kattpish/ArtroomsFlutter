import 'package:flutter/material.dart';

import '../../beans/bean_file.dart';
import '../theme/theme_colors.dart';
import '../widgets/widget_media.dart';


class MyScreenChatroomPhoto extends StatefulWidget {

  const MyScreenChatroomPhoto({super.key});

  @override
  State<MyScreenChatroomPhoto> createState() {
    return _MyScreenChatroomPhotoState();
  }

}

class _MyScreenChatroomPhotoState extends State<MyScreenChatroomPhoto> {

  int _selected = 0;
  bool _selectMode = false;
  bool _isButtonDisabled = true;

  List<FileItem> filesPhotos = [
    FileItem(name: '', path: 'assets/images/photos/photo_1.png'),
    FileItem(name: '', path: 'assets/images/photos/photo_2.png'),
    FileItem(name: '', path: 'assets/images/photos/photo_3.png'),
    FileItem(name: '', path: 'assets/images/photos/photo_4.png'),
  ];

  bool _isButtonFileDisabled = true;

  List<FileItem> files = [
    FileItem(name: 'artrooms_img_file_final_1', date: '2022.08.16 만료'),
    FileItem(name: 'artrooms_img_file_final_2', date: '2022.08.16 만료'),
    FileItem(name: 'artrooms_img_file_final_1', date: '2022.08.16 만료'),
    FileItem(name: 'artrooms_img_file_final_2', date: '2022.08.16 만료'),
    FileItem(name: 'artrooms_img_file_final_1', date: '2022.08.16 만료'),
    FileItem(name: 'artrooms_img_file_final_2', date: '2022.08.16 만료'),
    FileItem(name: 'artrooms_img_file_final_1', date: '2022.08.16 만료'),
    FileItem(name: 'artrooms_img_file_final_2', date: '2022.08.16 만료'),
    FileItem(name: 'artrooms_img_file_final_1', date: '2022.08.16 만료'),
    FileItem(name: 'artrooms_img_file_final_2', date: '2022.08.16 만료'),
    FileItem(name: 'artrooms_img_file_final_1', date: '2022.08.16 만료'),
    FileItem(name: 'artrooms_img_file_final_2', date: '2022.08.16 만료'),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Manager',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            !_selectMode ? '이미지' : "$_selected개 선택",
            style: const TextStyle(
                fontSize: 16,
                color: colorMainGrey900,
                fontWeight: FontWeight.w600
            ),
          ),
          centerTitle: _selectMode,
          leading: Row(
            children: [
              Visibility(
                visible: !_selectMode,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: colorMainGrey250),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Visibility(
                visible: _selectMode,
                child: Container(
                  height: double.infinity,
                  margin: const EdgeInsets.only(left: 8.0),
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        _deselectAllPhotos(true);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: const Text(
                            '취소',
                            style: TextStyle(
                                fontSize: 14,
                                color: colorMainGrey600,
                                fontWeight: FontWeight.w600
                            )
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Visibility(
              visible: _selectMode,
              child: Container(
                height: double.infinity,
                margin: const EdgeInsets.only(right: 8.0),
                child: Center(
                  child: InkWell(
                    onTap: () {
                      _deselectAllPhotos(false);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                          '선택 해제',
                          style: TextStyle(
                              fontSize: 14,
                              color: colorMainGrey600,
                              fontWeight: FontWeight.w600
                          )
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
          elevation: 0.5,
        ),
        backgroundColor: colorMainScreen,
        body: GridView.builder(
          padding: const EdgeInsets.only(bottom: 32),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
            childAspectRatio: 1,
          ),
          itemCount: filesPhotos.length,
          itemBuilder: (context, index) {
            var file = filesPhotos[index];
            return Container(
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  viewPhoto(context, file);
                },
                onLongPress: () {
                  setState(() {
                    file.isSelected = !file.isSelected;
                  });
                  _checkIfPhotoShouldBeEnabled();
                },
                child: Stack(
                  children: [
                    Image.asset(
                      file.path,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 3,
                      right: 4,
                      child: Visibility(
                        visible: _selectMode,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              file.isSelected = !file.isSelected;
                              _checkIfPhotoShouldBeEnabled();
                            });
                          },
                          child: Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              color: file.isSelected ? colorPrimaryBlue : colorMainGrey200.withAlpha(150),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: file.isSelected ? colorPrimaryBlue : const Color(0xFFE3E3E3),
                                width: 1,
                              ),
                            ),
                            child: file.isSelected
                                ? const Icon(Icons.check, size: 16, color: Colors.white)
                                : Container(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16, bottom: 42),
          padding: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(color: _isButtonDisabled ? colorPrimaryBlue400.withAlpha(100) : colorPrimaryBlue,
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextButton(
            onPressed: () {
              selectPhotos();
            },
            child:const Text(
                '저장',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                )
            ),
          ),
        ),
      ),
    );
  }


  void _checkIfPhotoShouldBeEnabled() {

    _selected = 0;
    for(FileItem fileItem in filesPhotos) {
      if(fileItem.isSelected) {
        setState(() {
          _selected++;
        });
      }
    }

    if (_selected > 0) {
      setState(() {
        _selectMode = true;
        _isButtonDisabled = false;
      });
    } else {
      setState(() {
        _isButtonDisabled = true;
      });
    }

  }

  void _deselectAllPhotos(isClose) {

    setState(() {
      _selected = 0;
    });

    for(FileItem fileItem in filesPhotos) {
      setState(() {
        fileItem.isSelected = false;
      });
    }

    if(isClose) {
      setState(() {
        _selectMode = false;
      });

      _checkIfPhotoShouldBeEnabled();
    }

  }

  void selectPhotos() {

    if(!_isButtonDisabled) {
      Navigator.pop(context);
    }

  }

}
