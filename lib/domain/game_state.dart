abstract class GameState<T> {
  const GameState();

  abstract final T data;

  abstract final int height;

  abstract final int width;

  abstract final bool isGameRunning;

  int calculateNumberOfNeighbors(int x, int y);

  GameState<T> copyWith({
    T? data,
    bool? isGameRunning,
  });
}