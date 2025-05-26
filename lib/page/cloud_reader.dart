import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:webview_flutter/webview_flutter.dart';

@RoutePage()
class CloudReaderPage extends StatefulWidget {
  const CloudReaderPage({super.key});

  @override
  State<CloudReaderPage> createState() => _CloudReaderPageState();
}

class _CloudReaderPageState extends State<CloudReaderPage> {
  final controller = WebViewController();
  var error = '';
  var loading = true;
  final url = 'http://43.139.61.244:4396';

  @override
  Widget build(BuildContext context) {
    var lottie = Lottie.asset('asset/json/loading.json');
    var container = Container(
      alignment: Alignment.center,
      color: Theme.of(context).colorScheme.surface,
      child: lottie,
    );
    var children = [
      WebViewWidget(controller: controller),
      if (error.isNotEmpty) Center(child: Text(error)),
      if (loading) container,
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
      onHttpError: (error) => _updateError(error.toString()),
      onWebResourceError: (error) => _updateError(error.toString()),
    );
    controller.setNavigationDelegate(delegate);
    controller.loadRequest(Uri.parse(url));
    super.initState();
  }

  Future<void> _finishLoading() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      loading = false;
    });
  }

  void _updateError(String error) {
    setState(() {
      this.error = error;
    });
  }
}
