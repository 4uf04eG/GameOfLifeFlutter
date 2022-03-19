import 'dart:math';

import 'package:game_of_life/domain/index.dart';

class GameStateImpl implements GameState<CellField> {
  const GameStateImpl._(this.data, this.isGameRunning);

  factory GameStateImpl.empty(int gridSize, {bool isGameRunning = false}) {
    return GameStateImpl._(
      List.generate(gridSize, (int index) => List.generate(gridSize, (int index) => CellState.dead)),
      isGameRunning,
    );
  }

  factory GameStateImpl.randomize(int gridSize, {bool isGameRunning = false}) {
    final random = Random();

    return GameStateImpl._(
      List.generate(
        gridSize,
        (int index) => List.generate(
          gridSize,
          (int index) => random.nextBool() ? CellState.alive : CellState.dead,
        ),
      ),
      isGameRunning,
    );
  }

  @override
  final CellField data;

  @override
  final bool isGameRunning;

  @override
  int calculateNumberOfNeighbors(int x, int y) {
    int count = 0;

    final List<List<int>> steps = [
      [x - 1, y - 1],
      [x, y - 1],
      [x + 1, y - 1],
      [x + 1, y],
      [x + 1, y + 1],
      [x, y + 1],
      [x - 1, y + 1],
      [x - 1, y],
    ];

    for (final List<int> step in steps) {
      final int x = step[0];
      final int y = step[1];

      if (x < 0 || x >= data.length || y < 0 || y >= data.length) {
        continue;
      }

      count += data[y][x] == CellState.alive ? 1 : 0;
    }

    return count;
  }

  @override
  GameStateImpl copyWith({
    CellField? data,
    bool? isGameRunning,
  }) {
    return GameStateImpl._(
      data ?? this.data,
      isGameRunning ?? this.isGameRunning,
    );
  }
}
