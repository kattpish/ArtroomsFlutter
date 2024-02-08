import 'package:flutter/material.dart';

import '../../beans/bean_file.dart';
import '../theme/theme_colors.dart';


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

  List<FileItem> files = [
    FileItem(name: '', path: 'assets/images/photos/photo_1.png'),
    FileItem(name: '', path: 'assets/images/photos/photo_2.png'),
    FileItem(name: '', path: 'assets/images/photos/photo_3.png'),
    FileItem(name: '', path: 'assets/images/photos/photo_4.png'),
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
                        _deselectAll(true);
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
                      _deselectAll(false);
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
          itemCount: files.length,
          itemBuilder: (context, index) {
            var file = files[index];
            return Container(
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  _viewPhoto(context, file);
                },
                onLongPress: () {
                  setState(() {
                    file.isSelected = !file.isSelected;
                  });
                  _checkIfButtonShouldBeEnabled();
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
                              _checkIfButtonShouldBeEnabled();
                            });
                          },
                          child: Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              color: file.isSelected ? colorPrimaryPurple : colorMainGrey200.withAlpha(150),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: file.isSelected ? colorPrimaryPurple : const Color(0xFFE3E3E3),
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
          decoration: BoxDecoration(color: _isButtonDisabled ? colorPrimaryPurple400.withAlpha(100) : colorPrimaryPurple,
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextButton(
            onPressed: () {
              select();
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

  void _viewPhoto(BuildContext context, FileItem file) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Scaffold(
            backgroundColor: Colors.black.withOpacity(0.30),
            body: Container(
              color: Colors.black.withOpacity(0.5),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                            color: colorMainGrey200,
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
                      ],
                    ),
                  ),
                  Expanded(
                    child: Image.asset(
                      file.path,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.none,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                    child: Row(
                      children: [
                        SizedBox(
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  void _checkIfButtonShouldBeEnabled() {

    _selected = 0;
    for(FileItem fileItem in files) {
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

  void _deselectAll(isClose) {

    setState(() {
      _selected = 0;
    });

    for(FileItem fileItem in files) {
      setState(() {
        fileItem.isSelected = false;
      });
    }

    if(isClose) {
      setState(() {
        _selectMode = false;
      });

      _checkIfButtonShouldBeEnabled();
    }

  }

  void select() {

    if(!_isButtonDisabled) {
      Navigator.pop(context);
    }

  }

}
