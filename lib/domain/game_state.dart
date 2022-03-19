abstract class GameState<T> {
  abstract final T data;

  abstract final bool isGameRunning;

  int calculateNumberOfNeighbors(int x, int y);

  GameState<T> copyWith({
    T? data,
    bool? isGameRunning,
  });
}