import 'package:flutter/material.dart';
import 'package:game_of_life/app/widgets/return_button.dart';
import 'package:game_of_life/app/widgets/control_strip.dart';
import 'package:game_of_life/app/widgets/game_field_painter.dart';
import 'package:game_of_life/data/index.dart';
import 'package:game_of_life/domain/index.dart';

class GameFieldPage extends StatefulWidget {
  const GameFieldPage({required this.stateProvider, Key? key}) : super(key: key);

  final StateProvider<dynamic> stateProvider;

  @override
  State<GameFieldPage> createState() => _GameFieldPageState();
}

class _GameFieldPageState extends State<GameFieldPage> {
  late final GameManager<CellField, CellState> manager;

  @override
  void initState() {
    initManager();
    super.initState();
  }

  @override
  void dispose() {
    manager.dispose();
    super.dispose();
  }

  void initManager() {
    final StateProvider<dynamic> provider = widget.stateProvider;

    if (provider is StateProvider<CellField>) {
      manager = GameManagerImpl(stateProvider: provider);
    } else {
      throw Exception('Unsupported game manager');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        toolbarHeight: 110,
        automaticallyImplyLeading: false,
        actions: [
          ReturnButton(),
        ],
      ),
      body: _GameField(manager: manager),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: StreamBuilder<GameState<dynamic>>(
        stream: manager.state,
        builder: (BuildContext context, AsyncSnapshot<GameState<dynamic>> snapshot) {
          return ControlStrip(
            isGameRunning: snapshot.data?.isGameRunning ?? false,
            onSpeedDown: manager.speedDown,
            onSpeedUp: manager.speedUp,
            onReset: manager.resetGame,
            onPause: manager.pauseGame,
            onResume: manager.resumeGame,
          );
        },
      ),
    );
  }
}

class _GameField extends StatelessWidget {
  const _GameField({
    required this.manager,
    Key? key,
  }) : super(key: key);

  final GameManager<CellField, CellState> manager;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GameState<CellField>>(
      stream: manager.state,
      builder: (BuildContext context, AsyncSnapshot<GameState<CellField>> snapshot) {
        final GameState<CellField>? state = snapshot.data;

        if (state == null) {
          return const SizedBox.shrink();
        }

        return CustomGameField(
          data: state,
          onCellChangeState: manager.setCellValue,
        );
      },
    );
  }
}
