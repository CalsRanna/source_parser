import 'dart:isolate';

class IsolateResult {
  final Isolate isolate;
  final ReceivePort response;

  IsolateResult(this.isolate, this.response);
}
