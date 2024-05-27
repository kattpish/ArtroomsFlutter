
import 'package:flutter/material.dart';


class WidgetLoader extends StatelessWidget {

  const WidgetLoader({super.key});

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

class WidgetLoaderPage extends StatelessWidget {

  const WidgetLoaderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: const Color(0xFF6A79FF).withOpacity(0.1),
      child: const Center(
        child: WidgetLoader(),
      ),
    );
  }

}
