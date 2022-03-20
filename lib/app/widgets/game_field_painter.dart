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

  final GameState<CellField> data;
  final OnCellChangeState onCellChangeState;

  @override
  State<CustomGameField> createState() => _CustomGameFieldState();
}

class _CustomGameFieldState extends State<CustomGameField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: InteractiveViewer(
        maxScale: 40,
        minScale: 0.1,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final Size size = constraints.biggest;
            final double itemSize = max(size.width, size.height) / min(widget.data.width, widget.data.height);

            return _GestureHandler(
              itemSize: itemSize,
              state: widget.data,
              onCellChangeState: widget.onCellChangeState,
              child: ColoredBox(
                color: Colors.grey,
                child: CustomPaint(
                  painter: _GameFieldPainter(widget.data, itemSize),
                  size: constraints.biggest,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _GestureHandler extends StatefulWidget {
  const _GestureHandler({
    required this.state,
    required this.onCellChangeState,
    required this.itemSize,
    required this.child,
    Key? key,
  }) : super(key: key);

  final GameState<CellField> state;
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

    if ((x < 0 || x >= widget.state.width) ||
        (y < 0 || y >= widget.state.height) ||
        (x == lastX && y == lastY)) return;

    lastX = x;
    lastY = y;
    final CellState item = widget.state.data[y][x];

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
  _GameFieldPainter(this.state, this.itemSize);

  final GameState<CellField> state;
  final double itemSize;

  @override
  void paint(Canvas canvas, Size size) {
    if (state.data.isEmpty) return;

    final CellField data = state.data;
    final int height = state.height;
    final int width = state.width;

    for (int row = 0; row < height; row++) {
      for (int column = 0; column < width; column++) {
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
  bool shouldRepaint(_GameFieldPainter oldDelegate) => oldDelegate.state != state;
}
