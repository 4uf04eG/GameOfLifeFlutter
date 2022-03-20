import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:game_of_life/domain/index.dart';

class RleStateProvider extends StateProvider<CellField> {
  RleStateProvider._(this._contentDelegate);

  factory RleStateProvider.fromFile(File file) {
    return RleStateProvider._(() => _readFromFil(file));
  }

  factory RleStateProvider.fromNetwork(String url) {
    return RleStateProvider._(() => _readFromNetwork(url));
  }

  final Future<String> Function() _contentDelegate;

  String? rawString;

  @override
  bool get isLoaded => rawString != null;

  @override
  Future<void> load() async {
    rawString = await _contentDelegate();
  }

  @override
  CellField provide() {
    if (!isLoaded) {
      throw StateNotLoadedException();
    }

    return _parseContent();
  }

  CellField _parseContent() {
    final List<String> strings = rawString!.split('\n');

    final StringBuffer cells = StringBuffer();
    CellField? field;

    for (final String string in strings) {
      final String trimmed = string.trim();
      if (trimmed.startsWith('#')) continue;
      if (trimmed.startsWith('x')) {
        final _Params params = _parseParams(string);
        field = _initializeArray(params);
        continue;
      }
      cells.write(trimmed);
    }

    field ??= _initializeArray(_Params.standard());

    return _parseCells(cells.toString(), field);
  }

  _Params _parseParams(String raw) {
    final List<String> params = raw.split(',');

    int x = 0;
    int y = 0;
    String rule = '';

    for (final String param in params) {
      final String trimmed = param.replaceAll(' ', '');
      final List<String> parts = trimmed.split('=');

      // TODO: Check regex
      if (parts[0] == 'x') {
        x = int.tryParse(parts[1]) ?? 0;
      } else if (parts[0] == 'y') {
        y = int.tryParse(parts[1]) ?? 0;
      } else if (parts[0] == 'rule') {
        rule = parts[1];
      }
    }

    return _Params(y, x, rule);
  }

  CellField _initializeArray(_Params params) {
    const int padding = 50;

    return List<List<CellState>>.generate(
      params.height + padding,
      (_) => List<CellState>.generate(params.width + padding, (_) => CellState.dead),
    );
  }

  CellField _parseCells(String raw, CellField field) {
    final Map<String, CellState> parseMap = <String, CellState>{
      'o': CellState.alive,
      'b': CellState.dead,
    };
    final StringBuffer repeatPrefix = StringBuffer();

    int charIndex = 0;

    int row = 0;
    int column = 0;

    while (charIndex < raw.length) {
      final String char = raw[charIndex];

      if (parseMap.containsKey(char)) {
        _repeat(repeatPrefix, () {
          field[row][column] = parseMap[char]!;
          column++;
        });
      } else if (char == '\$') {
        _repeat(repeatPrefix, () {
          column = 0;
          row++;
        });
      } else if (char == '!') {
        break;
      } else if (_isDigit(char, 0)) {
        repeatPrefix.write(char);
      } else {
        throw Exception('RLE file contains unknown symbol: "$char"');
      }

      charIndex++;
    }

    return field;
  }

  void _repeat(StringBuffer rawCount, VoidCallback action) {
    final int count = int.tryParse(rawCount.toString()) ?? 1;

    for (int repeat = 0; repeat < count; repeat++) {
      action();
    }

    rawCount.clear();
  }
}

class _Params {
  _Params(this.height, this.width, this.rule);

  _Params.standard() : height = 300, width = 300, rule = '';

  final int height;
  final int width;
  final String rule;
}

Future<String> _readFromFil(File file) async {
  return file.readAsString();
}

Future<String> _readFromNetwork(String url) async {
  final HttpClient client = HttpClient();
  final HttpClientRequest request = await client.getUrl(Uri.parse(url));
  final HttpClientResponse response = await request.close();
  return utf8.decoder.convert(await response.single);
}

bool _isDigit(String s, int idx) => (s.codeUnitAt(idx) ^ 0x30) <= 9;
