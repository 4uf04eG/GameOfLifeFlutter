import 'package:flutter/material.dart';

class ControlStrip extends StatelessWidget {
  const ControlStrip({
    required this.isGameRunning,
    required this.onResume,
    required this.onPause,
    required this.onReset,
    required this.onSpeedUp,
    required this.onSpeedDown,
    Key? key,
  }) : super(key: key);

  final bool isGameRunning;
  final VoidCallback onResume;
  final VoidCallback onPause;
  final VoidCallback onReset;
  final VoidCallback onSpeedUp;
  final VoidCallback onSpeedDown;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Colors.black45,
            blurRadius: 10,
            offset: Offset(-5, 5),
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: onSpeedDown,
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: onSpeedUp,
            ),
            const VerticalDivider(),
            IconButton(
              icon: const Icon(Icons.restart_alt),
              onPressed: onReset,
            ),
            if (isGameRunning)
              IconButton(
                icon: const Icon(Icons.pause),
                onPressed: onPause,
              )
            else
              IconButton(
                icon: const Icon(Icons.play_arrow),
                onPressed: onResume,
              ),
          ],
        ),
      ),
    );
  }
}