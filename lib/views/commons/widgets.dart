import 'package:flutter/material.dart';

class IconBtn extends StatelessWidget {
  final double size;
  final Icon icon;
  final VoidCallback onPressed;
  final Color color;
  const IconBtn({
    Key? key,
    required this.size,
    required this.icon,
    required this.onPressed,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.all(20),
      iconSize: size,
      icon: icon,
      onPressed: onPressed,
      color: color,
    );
  }
}
