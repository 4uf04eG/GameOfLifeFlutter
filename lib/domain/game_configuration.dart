abstract class GameConfiguration {
  const GameConfiguration({
    required this.tickTimeInMs,
    required this.gridSize,
    required this.tickStep,
  });

  final int tickTimeInMs;
  final int gridSize;
  final int tickStep;

  GameConfiguration copyWith({
    int? tickTimeInMs,
    int? gridSize,
    int? tickStep,
  });
}
