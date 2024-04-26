
import 'package:flutter/material.dart';

import '../../listeners/scroll_bouncing_physics.dart';


Widget widgetLoginRestTabId(BuildContext context, TextEditingController nameController, TextEditingController phoneController, FocusNode nameFocus, FocusNode phoneFocus, {required Null Function() onSubmitted}) {
  return ScrollConfiguration(
    behavior: scrollBehavior,
    child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
                '아이디 찾기',
                style: TextStyle(
                  color: Color(0xFF1F1F1F),
                  fontSize: 16,
                  fontFamily: 'SUIT',
                  fontWeight: FontWeight.w700,
                  height: 0,
                  letterSpacing: -0.32,
                )
            ),
            const SizedBox(height: 10),
            const Text(
              '가입 시 등록했던 이메일 주소를 입력해 주세요.\n비밀번호를 재설정할 수 있는 링크를 보내드립니다.',
              style: TextStyle(
                color: Color(0xFF1F1F1F),
                fontSize: 14,
                fontFamily: 'SUIT',
                fontWeight: FontWeight.w400,
                height: 0,
                letterSpacing: -0.28,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
                '이름',
                style: TextStyle(
                  color: Color(0xFF979797),
                  fontSize: 16,
                  fontFamily: 'SUIT',
                  fontWeight: FontWeight.w600,
                  height: 0,
                  letterSpacing: -0.32,
                )
            ),
            const SizedBox(height: 6),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: const Color(0xFFE7E7E7), width: 1.0,),
              ),
              child: TextField(
                controller: nameController,
                focusNode: nameFocus,
                autofocus: false,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                minLines: 1,
                maxLines: 1,
                onSubmitted: (_) {
                  FocusScope.of(context).requestFocus(phoneFocus);
                },
                decoration: InputDecoration(
                  hintText: '실명을 입력해주세요',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'SUIT',
                  fontWeight: FontWeight.w400,
                  height: 0,
                  letterSpacing: -0.32,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
                '핸드폰 번호',
                style: TextStyle(
                  color: Color(0xFF979797),
                  fontSize: 16,
                  fontFamily: 'SUIT',
                  fontWeight: FontWeight.w600,
                  height: 0,
                  letterSpacing: -0.32,
                )
            ),
            const SizedBox(height: 6),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: const Color(0xFFE7E7E7), width: 1.0,),
              ),
              child: TextField(
                controller: phoneController,
                focusNode: phoneFocus,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                minLines: 1,
                maxLines: 1,
                onSubmitted: (_) {
                  onSubmitted();
                },
                decoration: InputDecoration(
                  hintText: '휴대폰 번호를 입력해주세요',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'SUIT',
                  fontWeight: FontWeight.w400,
                  height: 0,
                  letterSpacing: -0.32,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
