
import 'package:flutter/material.dart';

import '../../listeners/scroll_bouncing_physics.dart';


Widget widgetLoginRestTabPassword(BuildContext context, TextEditingController emailController, {required Null Function() onSubmitted}) {
  return SingleChildScrollView(
    physics: const ScrollPhysicsBouncing(),
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Text(
              '비밀번호 찾기',
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
            '가입 시 등록했던 이메일 주소를 입력해 주세요.',
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
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: const Color(0xFFE7E7E7), width: 1.0,),
            ),
            child: TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) {
                onSubmitted();
              },
              decoration: InputDecoration(
                hintText: '이메일 주소를 입력하세요',
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
  );
}
