import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:game_of_life/app/pages/game_field_page.dart';
import 'package:game_of_life/domain/state_provider.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({required this.stateProvider, Key? key}) : super(key: key);

  final StateProvider<dynamic> stateProvider;

  void goToGameField(BuildContext context) {
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<GameFieldPage>(
          builder: (BuildContext context) => GameFieldPage(
            stateProvider: stateProvider,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: stateProvider.load(),
        builder: (BuildContext context, AsyncSnapshot<Object?> snapshot) {
          if (snapshot.hasError) {
            return _Error(error: snapshot.error.toString());
          }
          if (snapshot.connectionState == ConnectionState.done) {
            goToGameField(context);
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class _Error extends StatelessWidget {
  const _Error({required this.error, Key? key}) : super(key: key);

  final String error;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(error),
      ],
    );
  }
}
