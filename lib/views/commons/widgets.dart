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

class SettingSwitch extends StatelessWidget {
  final String label;
  final bool value;
  final void Function(bool) onChanged;
  const SettingSwitch({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Text(
            label,
            textAlign: TextAlign.end,
            maxLines: 2,
            overflow: TextOverflow.fade,
          ),
        ),
        Switch(value: value, onChanged: onChanged)
      ],
    );
  }
}
