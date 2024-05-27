
import 'package:flutter/material.dart';

import '../theme/theme_colors.dart';


void widgetProfileLogoutDialog(BuildContext context, {required Null Function() onLogout}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: colorMainGrey200,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(4),
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '로그아웃',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              const Text(
                '정말로 로그아웃 하시겠어요?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onLogout();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: colorPrimaryBlue,
                  backgroundColor: colorPrimaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  '로그아웃',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
