abstract class StateProvider<T> {
  bool get isLoaded;

  Future<void> load();

  T provide();
}

class StateNotLoadedException implements Exception {
  @override
  String toString() {
    return 'States should be loaded before providing';
  }
}
