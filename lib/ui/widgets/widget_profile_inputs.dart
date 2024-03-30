
import 'package:flutter/material.dart';


Widget widgetProfileInput1({
  required String label,
  required TextEditingController controller,
  bool readOnly = false,
  bool isPassword = false,
  required FocusNode focus,
  textInputAction = TextInputAction.next,
  required void Function(String) onSubmitted,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 20.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF8F8F8F),
            fontSize: 14,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
            height: 0,
            letterSpacing: -0.28,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 48,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: readOnly ? const Color(0xFFF5F5F5) : const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: const Color(0xFFE3E3E3), width: 1.0,),
          ),
          child: TextField(
            controller: controller,
            focusNode: focus,
            textInputAction: textInputAction,
            decoration: InputDecoration(
              border: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: readOnly ? const Color(0xFFF5F5F5) : const Color(0xFFFFFFFF),
            ),
            readOnly: readOnly,
            obscureText: isPassword,
            onSubmitted: onSubmitted,
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: Color(0xFF1F1F1F),
              fontSize: 16,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w400,
              height: 1.0,
              letterSpacing: -0.32,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget widgetProfileInput2({
  required String label,
  required VoidCallback onTap,
  required TextEditingController controller,
  bool readOnly = false,
  bool isObscure = false,
  textInputAction = TextInputAction.next,
  required void Function(String) onSubmitted,
  required FocusNode focus,
}) {
  return Container(
    padding: const EdgeInsets.only(bottom: 20.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF8F8F8F),
            fontSize: 14,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
            height: 0,
            letterSpacing: -0.28,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 48,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: readOnly ? const Color(0xFFE3E3E3) : const Color(0xFFE3E3E3),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: const Color(0xFFE3E3E3), width: 1.0,),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  focusNode: focus,
                  obscureText: isObscure,
                  textInputAction: textInputAction,
                  decoration: InputDecoration(
                    hintText: '',
                    filled: true,
                    fillColor: readOnly ? const Color(0xFFF5F5F5) : const Color(0xFFFFFFFF),
                    border: const UnderlineInputBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5.0),
                        bottomLeft: Radius.circular(5.0),
                      ),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  readOnly: readOnly,
                  onSubmitted: onSubmitted,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    color: Color(0xFF1F1F1F),
                    fontSize: 16,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                    height: 0.9,
                    letterSpacing: -0.32,
                  ),
                ),
              ),
              Visibility(
                visible: !readOnly,
                child: Container(
                  width: 78,
                  height: 48,
                  decoration: const BoxDecoration(
                    border: Border(
                      left: BorderSide(color: Color(0xFFE3E3E3), width: 1.0),
                    ),
                  ),
                  child: InkWell(
                    onTap: onTap,
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(5.0),
                          bottomRight: Radius.circular(5.0),
                        ),
                      ),
                      child: Text(
                        isObscure ? '변경' : '수정',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF8F8F8F),
                          fontSize: 14,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w700,
                          height: 0,
                          letterSpacing: -0.28,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
