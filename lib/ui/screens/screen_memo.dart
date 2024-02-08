
import 'package:artrooms/ui/theme/theme_colors.dart';
import 'package:flutter/material.dart';


class MyScreenMemo extends StatefulWidget {

  const MyScreenMemo({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyScreenMemoState();
  }

}

class _MyScreenMemoState extends State<MyScreenMemo> {

  bool _isButtonDisabled = true;
  final TextEditingController _memoController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
          icon: const Icon(Icons.arrow_back_ios, color: colorMainGrey250),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('메모',
            style: TextStyle(
            color: colorMainGrey900,
            fontWeight: FontWeight.w600
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
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: TextFormField(
          controller: _memoController,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(
              fontSize: 18
          ),
          decoration: const InputDecoration(
              hintText: '메모를 입력하세요',
              border: InputBorder.none
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16, bottom: 42),
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(color: _isButtonDisabled ? colorPrimaryPurple400.withAlpha(100) : colorPrimaryPurple,
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
                fontSize: 20,
              )
          ),
        ),
      ),
    );
  }

  void _checkIfButtonShouldBeEnabled() {
    if (_memoController.text.isNotEmpty) {
      setState(() => _isButtonDisabled = false);
    } else {
      setState(() => _isButtonDisabled = true);
    }
  }

  void save() {

    if(!_isButtonDisabled) {
      Navigator.pop(context);
    }

  }

}

