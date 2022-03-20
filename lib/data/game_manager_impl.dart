import 'dart:async';
import 'dart:math';

import 'package:game_of_life/data/index.dart';
import 'package:game_of_life/domain/index.dart';

class GameManagerImpl implements GameManager<CellField, CellState> {
  GameManagerImpl({
    required StateProvider<CellField> stateProvider,
  }) : _stateProvider = stateProvider {
    _initGame();
  }

  @override
  late final Stream<GameState<CellField>> state;

  final StateProvider<CellField> _stateProvider;
  late final StreamController<GameState<CellField>> _controller;
  late GameState<CellField> _lastState;

  late GameConfiguration _configuration;
  Timer? _timer;

  void _initGame() {
    _controller = StreamController<GameState<CellField>>();
    state = _controller.stream.asBroadcastStream();

    _configuration = const GameConfigurationImpl();
    _setState(GameStateImpl.fromProvider(_stateProvider));
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

  void _setState(GameState<CellField> state) {
    _lastState = state;
    _controller.add(state);
  }

  void _setupTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(
      Duration(milliseconds: _configuration.tickTimeInMs),
      (_) => _moveToNextState(),
    );
  }

  void _moveToNextState() {
    final GameState<CellField> original = _lastState.copyWith(data: <List<CellState>>[
      for (final List<CellState> row in _lastState.data) <CellState>[...row]
    ]);
    final int height = _lastState.height;
    final int width = _lastState.width;

    for (int row = 0; row < height; row++) {
      for (int column = 0; column < width; column++) {
        final int neighboursCount = original.calculateNumberOfNeighbors(column, row);

        if (neighboursCount < 2) {
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
  void setCellValue(int x, int y, CellState value) {
    _setState(_lastState.copyWith(data: _lastState.data..[y][x] = value));
  }

  @override
  void speedUp() {
    final int step = _configuration.tickStep;
    final int time = _configuration.tickTimeInMs;
    updateConfiguration(_configuration.copyWith(tickTimeInMs: max(time - step, 0)));
  }

  @override
  void speedDown() {
    final int step = _configuration.tickStep;
    final int time = _configuration.tickTimeInMs;
    updateConfiguration(_configuration.copyWith(tickTimeInMs: min(time + step, 1000)));
  }

  @override
  void updateConfiguration(GameConfiguration configuration) {
    _configuration = configuration;

    if (_lastState.isGameRunning) {
      _setupTimer();
    }
  }

  @override
  void resetGame() {
    _setState(GameStateImpl.fromProvider(_stateProvider));
    _timer?.cancel();
  }

  @override
  Future<void> dispose() async {
    _timer?.cancel();
    await _controller.close();
  }
}
