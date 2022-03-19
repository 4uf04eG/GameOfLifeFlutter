import 'package:game_of_life/domain/game_configuration.dart';

class GameConfigurationImpl extends GameConfiguration {
  const GameConfigurationImpl({
    int tickTimeInMs = 100,
    int gridSize = 200,
    int tickStep = 10,
  }) : super(
          tickTimeInMs: tickTimeInMs,
          gridSize: gridSize,
          tickStep: tickStep,
        );

  @override
  GameConfiguration copyWith({
    int? tickTimeInMs,
    int? gridSize,
    int? tickStep,
  }) {
    return GameConfigurationImpl(
      tickTimeInMs: tickTimeInMs ?? this.tickTimeInMs,
      gridSize: gridSize ?? this.gridSize,
      tickStep: tickStep ?? this.tickStep,
    );
  }
}
