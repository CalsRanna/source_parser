import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage()
class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() {
    return _AboutPageState();
  }
}

class _AboutPageState extends State<AboutPage> {
  String name = '';
  String version = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final labelSmall = textTheme.labelSmall;
    final action = IconButton(
      icon: const Icon(HugeIcons.strokeRoundedHelpCircle),
      onPressed: navigateGithub,
    );
    final style = labelSmall?.copyWith(
      color: labelSmall.color?.withOpacity(0.5),
    );
    final children = [
      // Image.asset('asset/image/logo.jpg', height: 160, width: 160),
      const Spacer(),
      Image.asset('asset/image/name.jpg', height: 80, width: 80),
      const Spacer(),
      Text('凤箫声动，玉壶光转，一夜鱼龙舞。', style: style),
      const SizedBox(height: 8, width: double.infinity),
      Text(version, style: style),
    ];
    final column = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
    return Scaffold(
      appBar: AppBar(actions: [action]),
      body: SafeArea(child: column),
    );
  }

  void getPackageInformation() async {
    final information = await PackageInfo.fromPlatform();
    setState(() {
      name = information.appName;
      version = '${information.version}+${information.buildNumber}';
    });
  }

  @override
  void initState() {
    super.initState();
    getPackageInformation();
  }

  void navigateGithub() {
    final url = Uri.parse('https://github.com/CalsRanna/source_parser');
    launchUrl(url);
  }
}
