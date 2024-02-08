import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'File Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyScreenChatroomFile(),
    );
  }
}

class MyScreenChatroomFile extends StatefulWidget {
  @override
  State<MyScreenChatroomFile> createState() => _MyScreenChatroomFileState();
}

class FileItem {
  String name;
  String date;
  bool isSelected;

  FileItem({required this.name, required this.date, this.isSelected = false});
}

class _MyScreenChatroomFileState extends State<MyScreenChatroomFile> {
  List<FileItem> files = [
    FileItem(name: 'artrooms_img_file_final_1', date: '2022.08.16 오후'),
    FileItem(name: 'artrooms_img_file_final_2', date: '2022.08.16 오후'), FileItem(name: 'artrooms_img_file_final_1', date: '2022.08.16 오후'),
    FileItem(name: 'artrooms_img_file_final_2', date: '2022.08.16 오후'), FileItem(name: 'artrooms_img_file_final_1', date: '2022.08.16 오후'),
    FileItem(name: 'artrooms_img_file_final_2', date: '2022.08.16 오후'), FileItem(name: 'artrooms_img_file_final_1', date: '2022.08.16 오후'),
    FileItem(name: 'artrooms_img_file_final_2', date: '2022.08.16 오후'), FileItem(name: 'artrooms_img_file_final_1', date: '2022.08.16 오후'),
    FileItem(name: 'artrooms_img_file_final_2', date: '2022.08.16 오후'), FileItem(name: 'artrooms_img_file_final_1', date: '2022.08.16 오후'),
    FileItem(name: 'artrooms_img_file_final_2', date: '2022.08.16 오후'),
    // ... add more file items
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('파일'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 3 / 2, // Adjust according to your aspect ratio
        ),
        itemCount: files.length,
        itemBuilder: (context, index) {
          var file = files[index];
          return Card(
            elevation: 2,
            child: InkWell(
              onTap: () {
                setState(() {
                  file.isSelected = !file.isSelected;
                });
              },
              child: Container(
                padding: EdgeInsets.all(8),
                child: Stack(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.insert_drive_file,
                          size: 48,
                          color: file.isSelected ? Colors.blue : Colors.grey,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  file.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  file.date,
                                  style: TextStyle(color: Colors.black38),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 8,
                      right: 6,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: file.isSelected ? Colors.blue : Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: file.isSelected ? Colors.blue : Colors.grey,
                            width: 2,
                          ),
                        ),
                        child: file.isSelected
                            ? Icon(Icons.check, size: 16, color: Colors.white)
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
    );
  }
}
