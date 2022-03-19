import 'dart:math';

import 'package:flutter/material.dart';
import 'package:game_of_life/domain/index.dart';

typedef OnCellChangeState = void Function(int x, int y, CellState state);

class CustomGameField extends StatefulWidget {
  const CustomGameField({
    required this.data,
    required this.onCellChangeState,
    Key? key,
  }) : super(key: key);

  final CellField data;
  final OnCellChangeState onCellChangeState;

  @override
  State<CustomGameField> createState() => _CustomGameFieldState();
}

class _CustomGameFieldState extends State<CustomGameField> {
  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      maxScale: 10,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final Size size = constraints.biggest;

          return _GestureHandler(
            itemSize: min(size.width, size.height) / widget.data.length,
            data: widget.data,
            onCellChangeState: widget.onCellChangeState,
            child: CustomPaint(
              painter: _GameFieldPainter(widget.data, widget.onCellChangeState),

              size: constraints.biggest,
            ),
          );
        },
      ),
    );
  }
}

class _GestureHandler extends StatefulWidget {
  const _GestureHandler({
    required this.data,
    required this.onCellChangeState,
    required this.itemSize,
    required this.child,
    Key? key,
  }) : super(key: key);

  final CellField data;
  final OnCellChangeState onCellChangeState;
  final double itemSize;
  final Widget child;

  @override
  State<_GestureHandler> createState() => _GestureHandlerState();
}

class _GestureHandlerState extends State<_GestureHandler> {
  bool isTapPressed = false;

  int? lastX;
  int? lastY;

  void hitTest(Offset position) {
    final int x = position.dx ~/ widget.itemSize;
    final int y = position.dy ~/ widget.itemSize;

    if (x >= widget.data.length || y >= widget.data.length || x == lastX && y == lastY) return;

    lastX = x;
    lastY = y;
    final CellState item = widget.data[y][x];

    if (item == CellState.alive) {
      widget.onCellChangeState(x, y, CellState.dead);
    } else {
      widget.onCellChangeState(x, y, CellState.alive);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {

        isTapPressed = true;
        hitTest(details.localPosition);
      },
      onTapUp: (_) {
        isTapPressed = false;
      },
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        hitTest(details.localPosition);
      },
      onVerticalDragUpdate: (DragUpdateDetails details) {
        hitTest(details.localPosition);
      },
      child: widget.child,
    );
  }
}

class _GameFieldPainter extends CustomPainter {
  _GameFieldPainter(this.data, this.onCellChangeState);

  final CellField data;
  final OnCellChangeState onCellChangeState;

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final int count = data.length;
    final double itemSize = min(size.width, size.height) / count;

    for (int row = 0; row < count; row++) {
      for (int column = 0; column < count; column++) {
        final bool isAlive = data[row][column] == CellState.alive;
        canvas.drawRect(
          Rect.fromLTWH(
            column * itemSize,
            row * itemSize,
            itemSize,
            itemSize,
          ),
          Paint()..color = isAlive ? Colors.black : Colors.white,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_GameFieldPainter oldDelegate) => oldDelegate.data != data;
}
