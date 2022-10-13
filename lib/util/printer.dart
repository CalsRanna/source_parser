import 'package:logger/logger.dart';

class DebugPrinter extends LogPrinter {
  @override
  List<String> log(LogEvent event) {
    var divider = List.generate(80, (index) => '-').join();
    return [divider, '[Parser.debug]', divider, event.message, divider];
  }
}
