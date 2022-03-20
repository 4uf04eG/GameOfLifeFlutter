import 'package:game_of_life/domain/index.dart';

class EmptyStateProvider implements StateProvider<CellField> {
  EmptyStateProvider({required this.height, required this.width});

  final int height;
  final int width;

  @override
  final bool isLoaded = true;

  @override
  Future<void> load() async {}

  @override
  CellField provide() {
    return List<List<CellState>>.generate(height, (int index) => List<CellState>.generate(width, (int index) => CellState.dead));
  }
}
