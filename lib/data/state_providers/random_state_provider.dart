import 'dart:math';

import 'package:game_of_life/domain/cell_state.dart';
import 'package:game_of_life/domain/state_provider.dart';

class RandomStateProvider implements StateProvider<CellField> {
  RandomStateProvider({required this.height, required this.width});

  final int height;
  final int width;

  @override
  final bool isLoaded = true;

  @override
  Future<void> load() async {}

  @override
  CellField provide() {
    final Random random = Random();

    return List<List<CellState>>.generate(
      height,
      (int index) => List<CellState>.generate(
        width,
        (int index) => random.nextBool() ? CellState.alive : CellState.dead,
      ),
    );
  }
}
