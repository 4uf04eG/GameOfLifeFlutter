import 'package:game_of_life/domain/index.dart';

abstract class GameManager<S, V> {
  const GameManager();

  abstract final Stream<GameState<S>> state;

  void pauseGame();

  void resumeGame();

  void setCellValue(int x, int y, V value);

  void speedUp();

  void speedDown();

  void updateConfiguration(GameConfiguration configuration);

  void resetGame();

  void dispose();
}
