import 'dart:async';

/// ===============================================================
/// Debouncer
/// ---------------------------------------------------------------
/// Prevents a callback from being executed repeatedly while the
/// user is typing.
///
/// Example:
///
/// final debouncer = Debouncer();
///
/// debouncer.run(() {
///   search();
/// });
///
/// ===============================================================

class Debouncer {
  final Duration delay;

  Timer? _timer;

  Debouncer({
    this.delay = const Duration(milliseconds: 300),
  });

  /// Executes the callback after the delay.
  ///
  /// If another call happens before the delay finishes,
  /// the previous callback is cancelled.
  void run(VoidCallback action) {
    _timer?.cancel();

    _timer = Timer(delay, action);
  }

  /// Cancels any pending callback.
  void cancel() {
    _timer?.cancel();
  }

  /// Releases resources.
  void dispose() {
    _timer?.cancel();
  }
}

/// Simple typedef to avoid importing Flutter
typedef VoidCallback = void Function();