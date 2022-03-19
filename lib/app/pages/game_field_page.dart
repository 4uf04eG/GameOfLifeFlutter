import 'dart:async';

import 'package:flutter/material.dart';
import 'package:game_of_life/data/game_manager_impl.dart';
import 'package:game_of_life/data/game_state_impl.dart';

import '../../domain/index.dart';

class GameFieldPage extends StatelessWidget {
  const GameFieldPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(child: GameField()),
      ),
    );
  }
}

class GameField extends StatefulWidget {
  const GameField({Key? key}) : super(key: key);

  @override
  State<GameField> createState() => _GameFieldState();
}

class _GameFieldState extends State<GameField> {
  late final GameManager<Field, CellState> manager;

  bool isDragStarted = false;

  @override
  void initState() {
    manager = GameManagerImpl.initial();
    super.initState();
  }

  @override
  void dispose() {
    manager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GameState<Field>>(
      stream: manager.state,
      builder: (context, snapshot) {
        final data = snapshot.data;

        if (data == null) {
          return SizedBox.shrink();
        }

        return GridView.count(
          crossAxisCount: data.data.length,
          children: [
            for (int row = 0; row < data.data.length; row++)
              for (int column = 0; column < data.data[row].length; column++)
                data.data[row][column] == CellState.alive ? const AliveCell() : const DeadCell(),
            ElevatedButton(
              child: Text('change state'),
              onPressed: () {
                setState(() {
                  if (data.isGameRunning) {
                    manager.pauseGame();
                  } else {
                    manager.resumeGame();
                  }
                });
              },
            )
          ],
        );
      },
    );
  }
}


class AliveCell extends StatelessWidget {
  const AliveCell({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Colors.black,
      child: SizedBox.square(dimension: 6),
    );
  }
}

class DeadCell extends StatelessWidget {
  const DeadCell({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Colors.transparent,
      child: SizedBox.square(dimension: 6),
    );
  }
}
