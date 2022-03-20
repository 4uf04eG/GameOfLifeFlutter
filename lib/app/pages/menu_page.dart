import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:game_of_life/app/pages/game_field_page.dart';
import 'package:game_of_life/app/pages/loading_page.dart';
import 'package:game_of_life/data/index.dart';
import 'package:numberpicker/numberpicker.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({Key? key}) : super(key: key);

  void navigateTo(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute<GameFieldPage>(builder: (BuildContext context) => page));
  }

  Future<File?> selectRleFile() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(allowedExtensions: <String>['rle']);

    if (result == null || result.count == 0) {
      return null;
    }

    final String? path = result.files.first.path;

    if (path == null) {
      return null;
    }

    return File(path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Wrap(
            spacing: 10,
            children: <Widget>[
              _MenuButton(
                title: 'EMPTY',
                onPressed: () async {
                  final Size? result = await showDialog<Size>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) => const _SizeSelectionDialog(),
                  );

                  if (result != null) {
                    navigateTo(
                      context,
                      GameFieldPage(
                        stateProvider: EmptyStateProvider(
                          height: result.height.toInt(),
                          width: result.width.toInt(),
                        ),
                      ),
                    );
                  }
                },
              ),
              _MenuButton(
                  title: 'RANDOM',
                  onPressed: () async {
                    final Size? result = await showDialog<Size>(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) => const _SizeSelectionDialog(),
                    );

                    if (result != null) {
                      navigateTo(
                        context,
                        GameFieldPage(
                          stateProvider: RandomStateProvider(
                            height: result.height.toInt(),
                            width: result.width.toInt(),
                          ),
                        ),
                      );
                    }
                  }),
              _MenuButton(
                  title: 'RLE',
                  onPressed: () async {
                    final File? file = await selectRleFile();

                    if (file == null) return;

                    navigateTo(context, LoadingPage(stateProvider: RleStateProvider.fromFile(file)));
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class _SizeSelectionDialog extends StatefulWidget {
  const _SizeSelectionDialog({Key? key}) : super(key: key);

  @override
  State<_SizeSelectionDialog> createState() => _SizeSelectionDialogState();
}

class _SizeSelectionDialogState extends State<_SizeSelectionDialog> {
  int height = 10;
  int width = 10;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => AlertDialog(
        content: Row(
          children: <Widget>[
            _NumberPicker(
              label: 'Height',
              height: constraints.maxHeight / 3,
              value: height,
              onChanged: (int val) => setState(
                () {
                  height = val;
                },
              ),
            ),
            Spacer(),
            _NumberPicker(
              label: 'Width',
              height: constraints.maxHeight / 3,
              value: width,
              onChanged: (int val) => setState(
                () {
                  width = val;
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('CANCEL'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          const SizedBox(width: 20),
          ElevatedButton(
            child: const Text('CREATE'),
            onPressed: () {
              Navigator.pop(context, Size(width * 1.0, height * 1.0));
            },
          ),
        ],
      ),
    );
  }
}

class _NumberPicker extends StatelessWidget {
  const _NumberPicker({
    required this.label,
    required this.height,
    required this.value,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  final String label;
  final double height;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(label),
        const SizedBox(height: 20),
        SizedBox(
          height: height,
          child: NumberPicker(
            minValue: 10,
            maxValue: 900,
            value: value,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({
    required this.title,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed, child: Text(title));
  }
}
