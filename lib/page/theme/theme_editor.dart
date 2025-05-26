import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:source_parser/page/reader/reader_content_view.dart';
import 'package:source_parser/provider/theme.dart';
import 'package:source_parser/schema/theme.dart' as schema;
import 'package:source_parser/util/splitter.dart';

class LoremIpsum {
  static const int startCode = 0x4E00; // 中文汉字的起始码位
  static const int endCode = 0x9FFF; // 中文汉字的结束码位

  static String content() {
    final random = Random();
    final count = random.nextInt(5) + 20;
    final buffer = StringBuffer();
    buffer.write(title());
    buffer.write('\n\n');
    for (var i = 0; i < count; i++) {
      buffer.write('　　');
      buffer.write(paragraph());
      if (i < count - 1) buffer.write('\n');
    }
    return buffer.toString();
  }

  static String paragraph() {
    final random = Random();
    final count = random.nextInt(9) + 1;
    final buffer = StringBuffer();
    for (var i = 0; i < count; i++) {
      buffer.write(sentence());
    }
    return buffer.toString();
  }

  static String sentence() {
    final random = Random();
    final count = random.nextInt(10) + 5;
    final buffer = StringBuffer();
    for (var i = 0; i < count; i++) {
      buffer.write(_randomCharacter());
      if (i != count - 1 && random.nextDouble() < 0.2) buffer.write('，');
    }
    buffer.write('。');
    return buffer.toString();
  }

  static String title() {
    final random = Random();
    final count = random.nextInt(10) + 5;
    final buffer = StringBuffer();
    for (var i = 0; i < count; i++) {
      buffer.write(_randomCharacter());
    }
    return buffer.toString();
  }

  static String _randomCharacter() {
    final random = Random();
    final charCode = startCode + random.nextInt(endCode - startCode);
    return String.fromCharCode(charCode);
  }
}

@RoutePage()
class ThemeEditorPage extends ConsumerStatefulWidget {
  const ThemeEditorPage({super.key});

  @override
  ConsumerState<ThemeEditorPage> createState() => _ThemeEditorPageState();
}

class _FieldDialog extends StatefulWidget {
  final String label;
  final String value;
  const _FieldDialog({required this.label, required this.value});

  @override
  State<_FieldDialog> createState() => _FieldDialogState();
}

class _FieldDialogState extends State<_FieldDialog> {
  late final TextEditingController controller;
  late final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    var decimal = widget.value.contains('.');
    var decoration = InputDecoration(
      border: OutlineInputBorder(),
      hintText: widget.label,
    );
    var textField = TextField(
      focusNode: focusNode,
      decoration: decoration,
      keyboardType: TextInputType.numberWithOptions(decimal: decimal),
      controller: controller,
      onSubmitted: handleSubmit,
    );
    var cancelButton = TextButton(onPressed: handleCancel, child: Text('取消'));
    var confirmButton = TextButton(
      onPressed: () => handleSubmit(controller.text),
      child: Text('确定'),
    );
    var actions = [cancelButton, confirmButton];
    return AlertDialog(
      actions: actions,
      content: textField,
      title: Text(widget.label),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void handleCancel() {
    Navigator.pop(context);
  }

  void handleSubmit(String value) {
    Navigator.pop(context, double.tryParse(value));
  }

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.value);
    focusNode = FocusNode()..requestFocus();
  }
}

class _ListTile extends StatelessWidget {
  final void Function()? onTap;
  final String title;
  const _ListTile({this.onTap, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(title),
      trailing: Icon(HugeIcons.strokeRoundedArrowRight01),
    );
  }
}

class _SheetLabel extends StatelessWidget {
  final String label;
  const _SheetLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Text(label, style: Theme.of(context).textTheme.labelMedium),
    );
  }
}

class _SheetTitle extends StatelessWidget {
  final String title;
  const _SheetTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(title, style: Theme.of(context).textTheme.titleLarge),
    );
  }
}

class _SliderTile extends StatefulWidget {
  final String label;
  final double value;
  final void Function(double)? onChanged;
  final double min;
  final double max;
  final int fractionDigits;
  const _SliderTile({
    required this.label,
    required this.value,
    this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
    this.fractionDigits = 2,
  });

  @override
  State<_SliderTile> createState() => _SliderTileState();
}

class _SliderTileState extends State<_SliderTile> {
  late double sliderValue;

  @override
  Widget build(BuildContext context) {
    var leading = Text(widget.label);
    var slider = Slider(
      value: sliderValue,
      onChanged: handleChanged,
      onChangeEnd: handleChangeEnd,
      max: widget.max,
      min: widget.min,
    );
    var text = sliderValue.toStringAsFixed(widget.fractionDigits);
    var trailing = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: showFieldDialog,
      child: Text(text),
    );
    var children = [
      SizedBox(width: 64, child: leading),
      Expanded(child: slider),
      SizedBox(width: 48, child: trailing)
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(children: children),
    );
  }

  void handleChanged(double value) {
    setState(() {
      sliderValue = value;
    });
  }

  void handleChangeEnd(double value) {
    widget.onChanged?.call(value);
  }

  @override
  void initState() {
    super.initState();
    sliderValue = widget.value.clamp(widget.min, widget.max);
  }

  Future<void> showFieldDialog() async {
    var text = sliderValue.toStringAsFixed(widget.fractionDigits);
    var fieldDialog = _FieldDialog(label: widget.label, value: text);
    var value = await showDialog(context: context, builder: (_) => fieldDialog);
    if (value == null) return;
    var clampedValue = value.clamp(widget.min, widget.max);
    setState(() {
      sliderValue = clampedValue;
    });
    widget.onChanged?.call(clampedValue);
  }
}

class _ThemeEditorPageState extends ConsumerState<ThemeEditorPage> {
  var text = '';
  var contentText = '';
  var theme = schema.Theme();
  var size = Size.zero;

  @override
  Widget build(BuildContext context) {
    var readerView = ReaderContentView(
      pageProgressText: '1/10 25.25%',
      customTheme: theme,
      headerText: '小说名称',
      content: contentText,
    );
    var children = [
      readerView,
      _buildOverlay(),
    ];
    return PopScope(child: Scaffold(body: Stack(children: children)));
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  Future<void> handleTap() async {
    await showModalBottomSheet(
      showDragHandle: true,
      context: context,
      builder: (_) => _buildSettingSheet(),
    );
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _assembleReaderTheme();
      text = LoremIpsum.content();
      _initContentText();
    });
  }

  void showChapterSheet() => showSheet(_buildChapterStyleSheet);
  void showContentPaddingSheet() => showSheet(_buildContentPaddingSheet);
  void showContentSheet() => showSheet(_buildContentStyleSheet);
  void showFooterPaddingSheet() => showSheet(_buildFooterPaddingSheet);
  void showFooterSheet() => showSheet(_buildFooterStyleSheet);
  void showHeaderPaddingSheet() => showSheet(_buildHeaderPaddingSheet);
  void showHeaderSheet() => showSheet(_buildHeaderStyleSheet);

  void showSheet(Widget Function() builder) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) => builder(),
    );
  }

  void updateChapterFontSize(double value) {
    setState(() {
      theme = theme.copyWith(chapterFontSize: value);
    });
    _initContentText();
  }

  void updateChapterFontWeight(double value) {
    setState(() {
      theme = theme.copyWith(chapterFontWeight: value.toInt() - 1);
    });
    _initContentText();
  }

  void updateChapterHeight(double value) {
    setState(() {
      theme = theme.copyWith(chapterHeight: value);
    });
    _initContentText();
  }

  void updateChapterLetterSpacing(double value) {
    setState(() {
      theme = theme.copyWith(chapterLetterSpacing: value);
    });
    _initContentText();
  }

  void updateChapterWordSpacing(double value) {
    setState(() {
      theme = theme.copyWith(chapterWordSpacing: value);
    });
    _initContentText();
  }

  void updateContentFontSize(double value) {
    setState(() {
      theme = theme.copyWith(contentFontSize: value);
    });
    _initContentText();
  }

  void updateContentFontWeight(double value) {
    setState(() {
      theme = theme.copyWith(contentFontWeight: value.toInt() - 1);
    });
    _initContentText();
  }

  void updateContentHeight(double value) {
    setState(() {
      theme = theme.copyWith(contentHeight: value);
    });
    _initContentText();
  }

  void updateContentLetterSpacing(double value) {
    setState(() {
      theme = theme.copyWith(contentLetterSpacing: value);
    });
    _initContentText();
  }

  void updateContentPaddingBottom(double value) {
    setState(() {
      theme = theme.copyWith(contentPaddingBottom: value);
    });
    _initContentText();
  }

  void updateContentPaddingLeft(double value) {
    setState(() {
      theme = theme.copyWith(contentPaddingLeft: value);
    });
    _initContentText();
  }

  void updateContentPaddingRight(double value) {
    setState(() {
      theme = theme.copyWith(contentPaddingRight: value);
    });
    _initContentText();
  }

  void updateContentPaddingTop(double value) {
    setState(() {
      theme = theme.copyWith(contentPaddingTop: value);
    });
    _initContentText();
  }

  void updateContentWordSpacing(double value) {
    setState(() {
      theme = theme.copyWith(contentWordSpacing: value);
    });
    _initContentText();
  }

  void updateFooterFontSize(double value) {
    setState(() {
      theme = theme.copyWith(footerFontSize: value);
    });
    _initContentText();
  }

  void updateFooterFontWeight(double value) {
    setState(() {
      theme = theme.copyWith(footerFontWeight: value.toInt() - 1);
    });
    _initContentText();
  }

  void updateFooterHeight(double value) {
    setState(() {
      theme = theme.copyWith(footerHeight: value);
    });
    _initContentText();
  }

  void updateFooterLetterSpacing(double value) {
    setState(() {
      theme = theme.copyWith(footerLetterSpacing: value);
    });
    _initContentText();
  }

  void updateFooterPaddingBottom(double value) {
    setState(() {
      theme = theme.copyWith(footerPaddingBottom: value);
    });
    _initContentText();
  }

  void updateFooterPaddingLeft(double value) {
    setState(() {
      theme = theme.copyWith(footerPaddingLeft: value);
    });
    _initContentText();
  }

  void updateFooterPaddingRight(double value) {
    setState(() {
      theme = theme.copyWith(footerPaddingRight: value);
    });
    _initContentText();
  }

  void updateFooterPaddingTop(double value) {
    setState(() {
      theme = theme.copyWith(footerPaddingTop: value);
    });
    _initContentText();
  }

  void updateFooterWordSpacing(double value) {
    setState(() {
      theme = theme.copyWith(footerWordSpacing: value);
    });
    _initContentText();
  }

  void updateHeaderFontSize(double value) {
    setState(() {
      theme = theme.copyWith(headerFontSize: value);
    });
    _initContentText();
  }

  void updateHeaderFontWeight(double value) {
    setState(() {
      theme = theme.copyWith(headerFontWeight: value.toInt() - 1);
    });
    _initContentText();
  }

  void updateHeaderHeight(double value) {
    setState(() {
      theme = theme.copyWith(headerHeight: value);
    });
    _initContentText();
  }

  void updateHeaderLetterSpacing(double value) {
    setState(() {
      theme = theme.copyWith(headerLetterSpacing: value);
    });
    _initContentText();
  }

  void updateHeaderPaddingBottom(double value) {
    setState(() {
      theme = theme.copyWith(headerPaddingBottom: value);
    });
    _initContentText();
  }

  void updateHeaderPaddingLeft(double value) {
    setState(() {
      theme = theme.copyWith(headerPaddingLeft: value);
    });
    _initContentText();
  }

  void updateHeaderPaddingRight(double value) {
    setState(() {
      theme = theme.copyWith(headerPaddingRight: value);
    });
    _initContentText();
  }

  void updateHeaderPaddingTop(double value) {
    setState(() {
      theme = theme.copyWith(headerPaddingTop: value);
    });
    _initContentText();
  }

  void updateHeaderWordSpacing(double value) {
    setState(() {
      theme = theme.copyWith(headerWordSpacing: value);
    });
    _initContentText();
  }

  void updateTheme() {
    var provider = themeNotifierProvider;
    var notifier = ref.read(provider.notifier);
    notifier.updateTheme(theme);
    Navigator.of(context).pop();
  }

  Future<void> _assembleReaderTheme() async {
    theme = await ref.read(themeNotifierProvider.future);
    setState(() {});
  }

  Widget _buildChapterStyleSheet() {
    var children = [
      _SheetTitle('标题样式'),
      _SliderTile(
        label: '字体大小',
        value: theme.chapterFontSize,
        max: 48.0,
        min: 12.0,
        onChanged: updateChapterFontSize,
      ),
      _SliderTile(
        label: '字重',
        value: theme.chapterFontWeight.toDouble(),
        max: 9.0,
        min: 1.0,
        fractionDigits: 0,
        onChanged: updateChapterFontWeight,
      ),
      _SliderTile(
        label: '行高',
        value: theme.chapterHeight,
        max: 4.0,
        min: 1.0,
        onChanged: updateChapterHeight,
      ),
      _SliderTile(
        label: '字间距',
        value: theme.chapterLetterSpacing,
        onChanged: updateChapterLetterSpacing,
      ),
      _SliderTile(
        label: '词间距',
        value: theme.chapterWordSpacing,
        onChanged: updateChapterWordSpacing,
      ),
    ];
    return ListView(children: children);
  }

  Widget _buildContentPaddingSheet() {
    var children = [
      _SheetTitle('正文边距'),
      _SliderTile(
        label: '上边距',
        value: theme.contentPaddingTop,
        max: 64.0,
        min: 0.0,
        onChanged: updateContentPaddingTop,
      ),
      _SliderTile(
        label: '下边距',
        value: theme.contentPaddingBottom,
        max: 64.0,
        min: 0.0,
        onChanged: updateContentPaddingBottom,
      ),
      _SliderTile(
        label: '左边距',
        value: theme.contentPaddingLeft,
        max: 64.0,
        min: 0.0,
        onChanged: updateContentPaddingLeft,
      ),
      _SliderTile(
        label: '右边距',
        value: theme.contentPaddingRight,
        max: 64.0,
        min: 0.0,
        onChanged: (value) => updateContentPaddingRight(value),
      ),
    ];
    return ListView(children: children);
  }

  Widget _buildContentStyleSheet() {
    var children = [
      _SheetTitle('正文样式'),
      _SliderTile(
        label: '字体大小',
        value: theme.contentFontSize,
        max: 48.0,
        min: 12.0,
        onChanged: updateContentFontSize,
      ),
      _SliderTile(
        label: '字重',
        value: theme.contentFontWeight.toDouble(),
        max: 9.0,
        min: 1.0,
        fractionDigits: 0,
        onChanged: updateContentFontWeight,
      ),
      _SliderTile(
        label: '行高',
        value: theme.contentHeight,
        max: 4.0,
        min: 1.0,
        onChanged: updateContentHeight,
      ),
      _SliderTile(
        label: '字间距',
        value: theme.contentLetterSpacing,
        onChanged: updateContentLetterSpacing,
      ),
      _SliderTile(
        label: '词间距',
        value: theme.contentWordSpacing,
        onChanged: updateContentWordSpacing,
      ),
    ];
    return ListView(children: children);
  }

  Widget _buildFooterPaddingSheet() {
    var children = [
      _SheetTitle('页脚边距'),
      _SliderTile(
        label: '上边距',
        value: theme.footerPaddingTop,
        max: 64.0,
        min: 0.0,
        onChanged: (value) => updateFooterPaddingTop(value),
      ),
      _SliderTile(
        label: '下边距',
        value: theme.footerPaddingBottom,
        max: 64.0,
        min: 0.0,
        onChanged: (value) => updateFooterPaddingBottom(value),
      ),
      _SliderTile(
        label: '左边距',
        value: theme.footerPaddingLeft,
        max: 64.0,
        min: 0.0,
        onChanged: (value) => updateFooterPaddingLeft(value),
      ),
      _SliderTile(
        label: '右边距',
        value: theme.footerPaddingRight,
        max: 64.0,
        min: 0.0,
        onChanged: (value) => updateFooterPaddingRight(value),
      ),
    ];
    return ListView(children: children);
  }

  Widget _buildFooterStyleSheet() {
    var children = [
      _SheetTitle('页脚样式'),
      _SliderTile(
        label: '字体大小',
        value: theme.footerFontSize,
        max: 24.0,
        min: 10.0,
        onChanged: updateFooterFontSize,
      ),
      _SliderTile(
        label: '字重',
        value: theme.footerFontWeight.toDouble(),
        max: 9.0,
        min: 1.0,
        fractionDigits: 0,
        onChanged: updateFooterFontWeight,
      ),
      _SliderTile(
        label: '行高',
        value: theme.footerHeight,
        max: 4.0,
        min: 1.0,
        onChanged: updateFooterHeight,
      ),
      _SliderTile(
        label: '字间距',
        value: theme.footerLetterSpacing,
        onChanged: updateFooterLetterSpacing,
      ),
      _SliderTile(
        label: '词间距',
        value: theme.footerWordSpacing,
        onChanged: updateFooterWordSpacing,
      ),
    ];
    return ListView(children: children);
  }

  Widget _buildHeaderPaddingSheet() {
    var children = [
      _SheetTitle('页头边距'),
      _SliderTile(
        label: '上边距',
        value: theme.headerPaddingTop,
        max: 64.0,
        min: 0.0,
        onChanged: updateHeaderPaddingTop,
      ),
      _SliderTile(
        label: '下边距',
        value: theme.headerPaddingBottom,
        max: 64.0,
        min: 0.0,
        onChanged: updateHeaderPaddingBottom,
      ),
      _SliderTile(
        label: '左边距',
        value: theme.headerPaddingLeft,
        max: 64.0,
        min: 0.0,
        onChanged: updateHeaderPaddingLeft,
      ),
      _SliderTile(
        label: '右边距',
        value: theme.headerPaddingRight,
        max: 64.0,
        min: 0.0,
        onChanged: updateHeaderPaddingRight,
      ),
    ];
    return ListView(children: children);
  }

  Widget _buildHeaderStyleSheet() {
    var children = [
      _SheetTitle('页头样式'),
      _SliderTile(
        label: '字体大小',
        value: theme.headerFontSize,
        max: 24.0,
        min: 10.0,
        onChanged: updateHeaderFontSize,
      ),
      _SliderTile(
        label: '字重',
        value: theme.headerFontWeight.toDouble(),
        max: 9.0,
        min: 1.0,
        fractionDigits: 0,
        onChanged: updateHeaderFontWeight,
      ),
      _SliderTile(
        label: '行高',
        value: theme.headerHeight,
        max: 4.0,
        min: 1.0,
        onChanged: updateHeaderHeight,
      ),
      _SliderTile(
        label: '字间距',
        value: theme.headerLetterSpacing,
        onChanged: updateHeaderLetterSpacing,
      ),
      _SliderTile(
        label: '词间距',
        value: theme.headerWordSpacing,
        onChanged: updateHeaderWordSpacing,
      ),
    ];
    return ListView(children: children);
  }

  Widget _buildOverlay() {
    var floatingActionButton = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          heroTag: 'update theme button',
          onPressed: updateTheme,
          shape: CircleBorder(),
          child: const Icon(HugeIcons.strokeRoundedTick02),
        ),
        SizedBox(height: 16),
        FloatingActionButton(
          onPressed: handleTap,
          child: const Icon(HugeIcons.strokeRoundedPaintBoard),
        ),
      ],
    );
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: floatingActionButton,
    );
  }

  Widget _buildSettingSheet() {
    var children = [
      _SheetLabel('样式'),
      _ListTile(onTap: showHeaderSheet, title: '页头样式'),
      _ListTile(onTap: showContentSheet, title: '正文样式'),
      _ListTile(onTap: showChapterSheet, title: '标题样式'),
      _ListTile(onTap: showFooterSheet, title: '页脚样式'),
      _SheetLabel('边距'),
      _ListTile(onTap: showHeaderPaddingSheet, title: '页头边距'),
      _ListTile(onTap: showContentPaddingSheet, title: '正文边距'),
      _ListTile(onTap: showFooterPaddingSheet, title: '页脚边距'),
    ];
    return ListView(children: children);
  }

  Future<void> _initContentText() async {
    var mediaQueryData = MediaQuery.of(context);
    var contentPaddingHorizontal =
        theme.contentPaddingLeft + theme.contentPaddingRight;
    var width = mediaQueryData.size.width - contentPaddingHorizontal;
    var contentPaddingVertical =
        theme.contentPaddingTop + theme.contentPaddingBottom;
    var height = mediaQueryData.size.height - contentPaddingVertical;
    var headerPaddingVertical =
        theme.headerPaddingTop + theme.headerPaddingBottom;
    height -=
        (headerPaddingVertical + theme.headerHeight * theme.headerFontSize);
    var footerPaddingVertical =
        theme.footerPaddingTop + theme.footerPaddingBottom;
    height -=
        (footerPaddingVertical + theme.footerHeight * theme.footerFontSize);
    setState(() {
      size = Size(width, height);
    });
    var pages = Splitter(size: size, theme: theme).split(text);
    setState(() {
      contentText = pages.first;
    });
  }
}
