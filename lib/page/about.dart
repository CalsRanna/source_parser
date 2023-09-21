import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() {
    return _AboutPageState();
  }
}

class _AboutPageState extends State<AboutPage> {
  int count = 0;
  String name = '';
  String version = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final labelSmall = textTheme.labelSmall;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: navigateGithub,
          ),
        ],
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('asset/image/logo.jpg', height: 160, width: 160),
              Image.asset('asset/image/name.jpg', height: 80, width: 80),
              const Spacer(),
              Text(
                '凤箫声动，玉壶光转，一夜鱼龙舞。',
                style: labelSmall?.copyWith(
                  color: labelSmall.color?.withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                version,
                style: labelSmall?.copyWith(
                  color: labelSmall.color?.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getPackageInformation();
  }

  void getPackageInformation() async {
    final information = await PackageInfo.fromPlatform();
    setState(() {
      name = information.appName;
      version = '${information.version}+${information.buildNumber}';
    });
  }

  void navigateGithub() {
    final url = Uri.parse('https://github.com/CalsRanna/source_parser');
    launchUrl(url);
  }

  // void handleTap(BuildContext context) async {
  //   final message = Message.of(context);
  //   final ref = context.ref;
  //   final setting = await ref.read(settingEmitter);
  //   setState(() {
  //     count++;
  //   });
  //   if (count == 5 && !setting.debugMode) {
  //     setting.debugMode = !setting.debugMode;
  //     ref.emit(settingEmitter, setting.clone);
  //     message.show('开发者模式已打开');
  //   }
  // }
}
