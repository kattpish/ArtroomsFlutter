import 'package:artrooms/ui/theme/theme_colors.dart';
import 'package:flutter/material.dart';

class OnHoverButtonState extends StatefulWidget {
  final String title;
  const OnHoverButtonState({super.key, required this.title});

  @override
  State<OnHoverButtonState> createState() => _OnHoverButtonStateState();
}

class _OnHoverButtonStateState extends State<OnHoverButtonState> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => onEnter(true),
      onExit: (event) => onEnter(false),
      child: Container(
        height: 100,
        width: 150,
        color: isHovered ? colorMainGrey700 : colorMainGrey100,
        child: ListTile(
          title: Text(widget.title),
          trailing: const Icon(Icons.reply),
        ),
      ),
    );
  }

  onEnter(bool hover) {
    setState(() {
      isHovered = hover;
    });
  }
}
