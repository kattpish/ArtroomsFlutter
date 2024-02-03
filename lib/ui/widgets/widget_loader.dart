
import 'package:flutter/material.dart';


class MyLoader extends StatelessWidget {

  const MyLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 40,
        height: 40,
        child: CircularProgressIndicator(
          color: Color(0xFF6A79FF),
          strokeWidth: 3,
        ),
      ),
    );
  }

}
