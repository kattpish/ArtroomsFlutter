
import 'package:artrooms/beans/bean_memo.dart';
import 'package:artrooms/modules/module_memo.dart';
import 'package:artrooms/ui/theme/theme_colors.dart';
import 'package:flutter/material.dart';

import '../../beans/bean_chat.dart';
import '../../main.dart';
import '../../utils/utils.dart';
import '../widgets/widget_ui_notify.dart';


class ScreenMemo extends StatefulWidget {

  final DataChat dataChat;
  final Memo memo;

  const ScreenMemo({super.key, required this.dataChat, required this.memo});

  @override
  State<StatefulWidget> createState() {
    return _ScreenMemoState();
  }

}

class _ScreenMemoState extends State<ScreenMemo> {

  bool _isButtonEnabled = true;
  final TextEditingController _memoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _memoController.text = widget.memo.memo;
    _isButtonEnabled = _memoController.text.isNotEmpty;
    _memoController.addListener(_doCheckEnableButton);
  }

  @override
  void dispose() {
    _memoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        closeKeyboard(context);
      },
      child: Scaffold(
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
          titleSpacing: 0,
          leadingWidth: 46,
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
        body: WidgetUiNotify(
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0, bottom: 20),
              child: TextFormField(
                controller: _memoController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
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
                _doSaveMemo();
              },
              child: const Text(
                '저장',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'SUIT',
                  fontWeight: FontWeight.w700,
                  height: 0,
                  letterSpacing: -0.32,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _doCheckEnableButton() {
    if (_memoController.text.isNotEmpty) {
      setState(() => _isButtonEnabled = true);
    } else {
      setState(() => _isButtonEnabled = false);
    }
  }

  void _doSaveMemo() async{
    if(_isButtonEnabled) {
      ModuleMemo memo = ModuleMemo();
       var result = await memo.updateProfileMemo(chattingMemoId: widget.memo.id, url: widget.memo.url, memo: _memoController.text);
      // dbStore.saveMemo(widget.dataChat, _memoController.text);
      Navigator.pop(context);
    }
  }

}
