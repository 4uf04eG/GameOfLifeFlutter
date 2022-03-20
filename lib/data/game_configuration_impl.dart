import 'package:game_of_life/domain/game_configuration.dart';

class GameConfigurationImpl extends GameConfiguration {
  const GameConfigurationImpl({
    int tickTimeInMs = 100,
    int tickStep = 10,
    int fieldWidth = 200,
    int fieldHeight = 200,
  }) : super(
          tickTimeInMs: tickTimeInMs,
          tickStep: tickStep,
          fieldWidth: fieldWidth,
          fieldHeight: fieldHeight,
        );

  @override
  GameConfiguration copyWith({
    int? tickTimeInMs,
    int? tickStep,
    int? fieldWidth,
    int? fieldHeight,
  }) {
    return GameConfigurationImpl(
      tickTimeInMs: tickTimeInMs ?? this.tickTimeInMs,
      tickStep: tickStep ?? this.tickStep,
      fieldWidth: fieldWidth ?? this.fieldWidth,
      fieldHeight: fieldHeight ?? this.fieldHeight,
    );
  }
}
