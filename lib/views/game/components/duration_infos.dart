import 'package:flutter/material.dart';

class DurationInfos extends StatelessWidget {
  const DurationInfos({
    Key? key,
    required this.currentPosition,
    required this.duration,
  }) : super(key: key);

  final Duration currentPosition;
  final Duration? duration;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Text(
          "0:${currentPosition != const Duration() ? currentPosition.inSeconds.toString() : 0}/0:${duration != null ? duration!.inSeconds.toString() : 0}"),
    );
  }
}
