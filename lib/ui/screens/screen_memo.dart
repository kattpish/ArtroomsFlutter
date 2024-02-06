
import 'package:flutter/material.dart';


class MyScreenMemo extends StatefulWidget {

  const MyScreenMemo({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyScreenMemoState();
  }

}

class _MyScreenMemoState extends State<MyScreenMemo> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: Colors.grey[400]),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('메모'),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey[200],
            height: 1.0,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: TextFormField(
          maxLines: null,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            hintText: '메모를 입력하세요',
              border: InputBorder.none
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(16.0),
        padding: EdgeInsets.all(4.0),
        decoration: BoxDecoration(color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: TextButton(
          onPressed: (){
          },
          child:Text('저장',style: TextStyle(color: Colors.white,
          fontSize: 20,)),

          ),
      ),
    );
  }

}
