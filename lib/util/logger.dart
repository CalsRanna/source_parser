import 'package:logger/logger.dart';

final logger = Logger(printer: PlainPrinter());

class PlainPrinter extends LogPrinter {
  String getTrace(LogEvent event) {
    final stackTrace = event.stackTrace ?? StackTrace.current;
    final traces = stackTrace.toString().split('\n');
    final exactTrace = traces.where((trace) {
      return !trace.contains('Printer') && !trace.contains('Logger');
    }).first;
    final match = RegExp(r'\(([^)]+)\)').firstMatch(exactTrace);
    if (match == null) return 'Unknown';
    return match[0]!.replaceAll('(package:go_out/', '').replaceAll(')', '');
  }

  @override
  List<String> log(LogEvent event) {
    final level = event.level.name.toUpperCase();
    final trace = getTrace(event);
    final time = event.time.toString().substring(0, 19);
    return ['[$level][$trace][$time] ${event.message}'];
  }
}
