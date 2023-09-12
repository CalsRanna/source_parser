import 'dart:async';
import 'dart:collection';

class Semaphore {
  final int _maxConcurrent;
  int _currentConcurrent = 0;
  final _queue = Queue<Completer>();

  Semaphore(this._maxConcurrent);

  Future<void> acquire() {
    final completer = Completer<void>();
    if (_currentConcurrent < _maxConcurrent) {
      _currentConcurrent++;
      completer.complete();
    } else {
      _queue.add(completer);
    }
    return completer.future;
  }

  void release() {
    _currentConcurrent--;
    if (_queue.isNotEmpty) {
      _currentConcurrent++;
      _queue.removeFirst().complete();
    }
  }
}
