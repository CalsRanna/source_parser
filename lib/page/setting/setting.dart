import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widget/bottom_bar.dart';

class Setting extends ConsumerWidget {
  const Setting({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(icon: const Icon(Icons.help_outline), onPressed: () {}),
        ],
        title: const Text('我的'),
      ),
      // backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Column(
                children: const [
                  _SettingTile(
                    icon: Icons.library_books_outlined,
                    route: '/book-source',
                    title: '书源管理',
                  ),
                  _SettingTile(
                    icon: Icons.find_replace_outlined,
                    route: '/setting/image-source',
                    title: '替换净化',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: const [
                  _SettingTile(
                    icon: Icons.color_lens_outlined,
                    route: '/setting/theme',
                    title: '颜色主题',
                  ),
                  _SettingTile(
                    icon: Icons.format_color_text_outlined,
                    route: '/setting/book-theme',
                    title: '阅读主题',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: const [
                  _SettingTile(
                    icon: Icons.share_outlined,
                    route: '/setting/share',
                    title: '分享',
                  ),
                  _SettingTile(
                    icon: Icons.comment_outlined,
                    route: '/setting/comment',
                    title: '好评支持',
                  ),
                  _SettingTile(
                    icon: Icons.error_outline,
                    route: '/setting/about',
                    title: '关于我们',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: const [
                  _SettingTile(
                    icon: Icons.developer_mode_outlined,
                    route: '/setting/developer',
                    title: '开发者选项',
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}

class _SettingTile extends StatelessWidget {
  const _SettingTile({
    Key? key,
    this.icon,
    this.route,
    required this.title,
  }) : super(key: key);

  final IconData? icon;
  final String? route;
  final String title;

  @override
  Widget build(BuildContext context) {
    var leading =
        icon != null ? Icon(icon, color: Theme.of(context).primaryColor) : null;

    return ListTile(
      leading: leading,
      title: Text(title),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Colors.grey.withOpacity(0.5),
        size: 16,
      ),
      onTap: () => handleTap(context),
    );
  }

  void handleTap(BuildContext context) {
    if (route != null) {
      context.push(route!);
    }
  }
}
