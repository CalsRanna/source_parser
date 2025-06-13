import 'package:shelf/shelf.dart';
import 'package:shelf_static/shelf_static.dart';
import 'package:source_parser/page/local_server_page/controller/controller.dart';

class LocalServerStaticController with LocalServerController {
  LocalServerStaticController._();

  static LocalServerStaticController? _instance;

  static LocalServerStaticController get instance =>
      _instance ??= LocalServerStaticController._();

  Future<Response> handle(Request request, String site) async {
    final staticHandler = createStaticHandler(
      site,
      defaultDocument: 'index.html',
      listDirectories: false,
      useHeaderBytesForContentType: true,
    );
    return staticHandler(request);
  }
}
