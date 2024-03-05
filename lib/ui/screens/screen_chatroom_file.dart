
import 'package:artrooms/utils/utils_screen.dart';
import 'package:flutter/material.dart';

import '../../beans/bean_file.dart';
import '../theme/theme_colors.dart';


class MyScreenChatroomFile extends StatefulWidget {

  const MyScreenChatroomFile({super.key});

  @override
  State<MyScreenChatroomFile> createState() {
    return _MyScreenChatroomFileState();
  }

}

class _MyScreenChatroomFileState extends State<MyScreenChatroomFile> {

  bool _isButtonFileDisabled = true;

  int crossAxisCount = 2;
  double crossAxisSpacing = 8;
  double mainAxisSpacing = 8;
  double screenWidth = 0;

  List<FileItem> filesMedia = [
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    crossAxisCount = isTablet(context) ? 4 : 2;
    screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      title: 'File Manager',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            '파일',
            style: TextStyle(
                color: colorMainGrey900,
              fontSize: 19,
              fontFamily: 'SUIT',
              fontWeight: FontWeight.w700,
              height: 0,
              letterSpacing: -0.38,
            ),
          ),
          toolbarHeight: 60,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: colorMainGrey250),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          leadingWidth: 32,
          elevation: 0.5,
        ),
        backgroundColor: colorMainScreen,
        body: GridView.builder(
          padding: const EdgeInsets.only(left: 16, top: 12, right: 16, bottom: 32),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: crossAxisSpacing,
            mainAxisSpacing: mainAxisSpacing,
            childAspectRatio: (screenWidth / crossAxisCount - crossAxisSpacing) / 157,
          ),
          itemCount: filesMedia.length,
          itemBuilder: (context, index) {
            var file = filesMedia[index];
            return Card(
              elevation: 0,
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  setState(() {
                    file.isSelected = !file.isSelected;
                    _checkIfFileButtonShouldBeEnabled();
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: colorMainGrey200, width: 1.0,),
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 24),
                          Image.asset(
                            file.isSelected ? 'assets/images/icons/icon_file_selected.png' : 'assets/images/icons/icon_file.png',
                            width: 30,
                            height: 30,
                          ),
                          const SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                file.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: colorMainGrey700,
                                  fontFamily: 'SUIT',
                                  fontWeight: FontWeight.w400,
                                  height: 0.08,
                                  letterSpacing: -0.32,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                file.date,
                                style: const TextStyle(
                                  color: Color(0xFF8F8F8F),
                                  fontSize: 12,
                                  fontFamily: 'SUIT',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                  letterSpacing: -0.24,
                                ),
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Positioned(
                        top: 3,
                        right: 2,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: file.isSelected ? colorPrimaryBlue : Colors.transparent,
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
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16, bottom: 42),
          padding: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(color: _isButtonFileDisabled ? colorPrimaryBlue400.withAlpha(100) : colorPrimaryBlue,
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextButton(
            onPressed: () {
              selectFiles();
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

  void _checkIfFileButtonShouldBeEnabled() {

    int n = 0;
    for(FileItem fileItem in filesMedia) {
      if(fileItem.isSelected) {
        n++;
      }
    }

    if (n > 0) {
      setState(() => _isButtonFileDisabled = false);
    } else {
      setState(() => _isButtonFileDisabled = true);
    }

  }

  void selectFiles() {

    if(!_isButtonFileDisabled) {
      Navigator.pop(context);
    }

  }

}
