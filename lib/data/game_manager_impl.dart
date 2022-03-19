import 'dart:async';

import 'package:game_of_life/data/game_configuration_impl.dart';
import 'package:game_of_life/data/game_state_impl.dart';
import 'package:game_of_life/domain/cell_state.dart';
import 'package:game_of_life/domain/game_configuration.dart';
import 'package:game_of_life/domain/game_manager.dart';

class GameManagerImpl implements GameManager<Field, CellState> {
  GameManagerImpl.initial() {
    _initGame();
  }

  @override
  late final Stream<GameStateImpl> state;

  late final StreamController<GameStateImpl> _controller;
  late GameStateImpl _lastState;

  late GameConfiguration _configuration;
  Timer? _timer;

  void _initGame() {
    _controller = StreamController<GameStateImpl>();
    state = _controller.stream.asBroadcastStream();

    _configuration = GameConfigurationImpl();
    _setState(GameStateImpl.fromSeed(_configuration.gridSize));
  }

  @override
  void pauseGame() {
    _timer?.cancel();
    _setState(_lastState.copyWith(isGameRunning: false));
  }

  @override
  void resumeGame() {
    _setState(_lastState.copyWith(isGameRunning: true));
    _setupTimer();
  }

  void _setState(GameStateImpl state) {
    _lastState = state;
    _controller.add(state);
  }

  void _setupTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(
      Duration(seconds: _configuration.tickTimeInSec),
      (_) => moveToNextState(),
    );
  }

  @override
  void moveToNextState() {
    final original = _lastState.copyWith();
    final gridSize = _configuration.gridSize;

    for (int row = 0; row < gridSize; row++) {
      for (int column = 0; column < gridSize; column++) {
        final neighboursCount = original.calculateNumberOfNeighbors(column, row);

        if (neighboursCount < 2) {
          print(neighboursCount);
          _lastState.data[row][column] = CellState.dead;
        } else if (neighboursCount <= 3 && _lastState.data[row][column] == CellState.alive) {
          // Let it live
        } else if (neighboursCount > 3) {
          _lastState.data[row][column] = CellState.dead;
        } else if (neighboursCount == 3) {
          _lastState.data[row][column] = CellState.alive;
        }
      }
    }

    _setState(_lastState);
  }

  @override
  void updateState(int x, int y, CellState value) {
    _setState(_lastState.copyWith(data: _lastState.data..[y][x] = value));
  }

  @override
  void updateConfiguration(GameConfiguration configuration) {
    _configuration = configuration;
    _setupTimer();
  }

  @override
  void resetGame() {
    updateConfiguration(GameConfigurationImpl());
    _setState(GameStateImpl.empty(_configuration.gridSize));
  }

  @override
  Future<void> dispose() async {
    await _controller.close();
  }
}
