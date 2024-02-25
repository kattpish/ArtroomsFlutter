
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

class MyLoaderPage extends StatelessWidget {

  const MyLoaderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: const Color(0xFFFCDDA8).withOpacity(0.3),
      child: const Center(
        child: SizedBox(
          width: 40,
          height: 40,
          child: CircularProgressIndicator(
            color: Color(0xFF6A79FF),
            strokeWidth: 3,
          ),
        ),
      ),
    );
  }

}
