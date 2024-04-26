import 'package:flutter/material.dart';

import '../../utils/utils.dart';

class ChatroomDatePin extends StatelessWidget {
  final int currentDate;
  const ChatroomDatePin({super.key, required this.currentDate});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 145,
      height: 31,
      margin: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 3),
      padding: const EdgeInsets.symmetric(
          horizontal: 12, vertical: 4),
      alignment: Alignment.center,
      decoration: ShapeDecoration(
        color: const Color(0xFFF9F9F9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment:
        MainAxisAlignment.start,
        crossAxisAlignment:
        CrossAxisAlignment.center,
        children: [
          Text(
            formatDateLastMessage(currentDate),
            style: const TextStyle(
              color: Color(0xFF7D7D7D),
              fontSize: 12,
              fontFamily: 'SUIT',
              fontWeight: FontWeight.w400,
              height: 0,
              letterSpacing: -0.24,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}