import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

@RoutePage()
class CloudReaderPage extends StatefulWidget {
  const CloudReaderPage({super.key});

  @override
  State<CloudReaderPage> createState() => _CloudReaderPageState();
}

class _CloudReaderPageState extends State<CloudReaderPage> {
  final controller = WebViewController();
  var loading = true;
  var progress = 0.0;
  final url = 'http://43.139.61.244:4396';

  @override
  Widget build(BuildContext context) {
    var indicator = CircularProgressIndicator(value: progress);
    var children = [
      WebViewWidget(controller: controller),
      if (loading) Center(child: indicator),
    ];
    return Scaffold(body: Stack(children: children));
  }

  @override
  void deactivate() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.deactivate();
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    var delegate = NavigationDelegate(
      onPageFinished: (_) => _finishLoading(),
      onProgress: _updateProgress,
    );
    controller.setNavigationDelegate(delegate);
    controller.loadRequest(Uri.parse(url));
    super.initState();
  }

  void _finishLoading() {
    setState(() {
      loading = false;
    });
  }

  void _updateProgress(int progress) {
    setState(() {
      this.progress = progress.toDouble();
    });
  }
}
