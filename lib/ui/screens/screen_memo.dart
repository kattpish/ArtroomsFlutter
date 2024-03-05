
import 'package:artrooms/ui/theme/theme_colors.dart';
import 'package:flutter/material.dart';

import '../../beans/bean_chat.dart';
import '../../main.dart';


class MyScreenMemo extends StatefulWidget {

  final MyChat myChat;

  const MyScreenMemo({super.key, required this.myChat});

  @override
  State<StatefulWidget> createState() {
    return _MyScreenMemoState();
  }

}

class _MyScreenMemoState extends State<MyScreenMemo> {

  bool _isButtonEnabled = true;
  final TextEditingController _memoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _memoController.text = myDataStore.getMemo(widget.myChat);
    _isButtonEnabled = _memoController.text.isNotEmpty;
    _memoController.addListener(_checkIfButtonShouldBeEnabled);
  }

  @override
  void dispose() {
    _memoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
              Icons.arrow_back_ios,
              color: colorMainGrey250
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        toolbarHeight: 60,
        leadingWidth: 32,
        title: const Text(
          '메모',
          style: TextStyle(
            color: colorMainGrey900,
            fontSize: 18,
            fontFamily: 'SUIT',
            fontWeight: FontWeight.w700,
            height: 0,
            letterSpacing: -0.36,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey[200],
            height: 1.0,
          ),
        ),
      ),
      backgroundColor: colorMainScreen,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0, bottom: 20),
          child: TextFormField(
            controller: _memoController,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            style: const TextStyle(
              color: colorMainGrey900,
              fontSize: 16,
              fontFamily: 'SUIT',
              fontWeight: FontWeight.w400,
              letterSpacing: -0.32,
            ),
            decoration: const InputDecoration(
              hintText: '메모를 입력하세요',
              border: InputBorder.none,
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 44,
          margin: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(color: _isButtonEnabled ? colorPrimaryBlue : colorPrimaryBlue400.withAlpha(100),
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextButton(
            onPressed: () {
              save();
            },
            child:const Text(
                '저장',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'SUIT',
                  fontWeight: FontWeight.w700,
                  height: 0,
                  letterSpacing: -0.32,
                )
            ),
          ),
        ),
      ),
    );
  }

  void _checkIfButtonShouldBeEnabled() {
    if (_memoController.text.isNotEmpty) {
      setState(() => _isButtonEnabled = true);
    } else {
      setState(() => _isButtonEnabled = false);
    }
  }

  void save() {

    if(_isButtonEnabled) {
      myDataStore.saveMemo(widget.myChat, _memoController.text);
      Navigator.pop(context);
    }

  }

}
