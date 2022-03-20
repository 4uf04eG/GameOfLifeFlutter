import 'package:game_of_life/data/index.dart';
import 'package:game_of_life/domain/index.dart';

class GameStateImpl implements GameState<CellField> {
  GameStateImpl._(this.data, this.isGameRunning);

  factory GameStateImpl.fromProvider(StateProvider<CellField> provider, {bool isGameRunning = false}) {
    return GameStateImpl._(provider.provide(), isGameRunning);
  }

  factory GameStateImpl.empty(int gridSize, {bool isGameRunning = false}) {
    return GameStateImpl._(
      EmptyStateProvider(height: gridSize, width: gridSize).provide(),
      isGameRunning,
    );
  }

  factory GameStateImpl.random(int gridSize, {bool isGameRunning = false}) {
    return GameStateImpl._(
      RandomStateProvider(height: gridSize, width: gridSize).provide(),
      isGameRunning,
    );
  }

  @override
  final CellField data;

  @override
  late final int height = data.length;

  @override
  late final int width = height > 0 ? data[0].length : 0;

  @override
  final bool isGameRunning;

  @override
  int calculateNumberOfNeighbors(int x, int y) {
    int count = 0;

    final List<List<int>> steps = <List<int>>[
      <int>[x - 1, y - 1],
      <int>[x, y - 1],
      <int>[x + 1, y - 1],
      <int>[x + 1, y],
      <int>[x + 1, y + 1],
      <int>[x, y + 1],
      <int>[x - 1, y + 1],
      <int>[x - 1, y],
    ];

    for (final List<int> step in steps) {
      final int x = step[0];
      final int y = step[1];

      if (x < 0 || x >= data[0].length || y < 0 || y >= data.length) {
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
