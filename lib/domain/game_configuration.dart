abstract class GameConfiguration {
  const GameConfiguration({
    required this.tickTimeInMs,
    required this.tickStep,
    required this.fieldWidth,
    required this.fieldHeight,
  });

  final int tickTimeInMs;
  final int tickStep;

  final int fieldWidth;
  final int fieldHeight;

  GameConfiguration copyWith({
    int? tickTimeInMs,
    int? tickStep,
    int? fieldWidth,
    int? fieldHeight,
  });
}
