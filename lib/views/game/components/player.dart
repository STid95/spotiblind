import 'package:flutter/material.dart';

import '../../commons/widgets.dart';
import 'duration_infos.dart';

class Player extends StatelessWidget {
  const Player({
    Key? key,
    required this.isMaster,
    required this.currentPosition,
    this.duration,
    required this.onChangedSlider,
    required this.onPressedIcon,
    required this.isPlaying,
  }) : super(key: key);

  final bool isMaster;

  final Duration currentPosition;

  final Duration? duration;

  final void Function(double) onChangedSlider;

  final void Function() onPressedIcon;

  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Slider(
              value: currentPosition == const Duration() || duration == null
                  ? 0
                  : currentPosition.inSeconds.toDouble() /
                      duration!.inSeconds.toDouble(),
              onChanged: onChangedSlider),
          DurationInfos(currentPosition: currentPosition, duration: duration),
          const SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).colorScheme.primary,
                ],
              ),
              borderRadius: const BorderRadius.all(Radius.circular(100)),
            ),
            child: IconBtn(
                size: isMaster ? 50 : 150,
                color: Colors.white,
                icon: isMaster
                    ? Icon(isPlaying ? Icons.pause : Icons.play_arrow)
                    : const Icon(Icons.alarm),
                onPressed: onPressedIcon),
          ),
        ],
      ),
    );
  }
}
