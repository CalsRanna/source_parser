import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/page/reader/reader_content_view.dart';
import 'package:source_parser/page/reader_theme/reader_theme_editor_view_model.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/schema/theme.dart' as schema;
import 'package:source_parser/util/splitter.dart';
import 'package:source_parser/util/string_extension.dart';

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
class ReaderThemeEditorPage extends StatefulWidget {
  final schema.Theme theme;
  const ReaderThemeEditorPage({super.key, required this.theme});

  @override
  State<ReaderThemeEditorPage> createState() => _ReaderThemeEditorPageState();
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

class _ReaderThemeEditorPageState extends State<ReaderThemeEditorPage> {
  var text = '';
  var contentText = '';
  var size = Size.zero;

  final viewModel = GetIt.instance.get<ReaderThemeEditorViewModel>();

  @override
  Widget build(BuildContext context) {
    var readerView = Watch(
      (_) => ReaderContentView(
        pageProgressText: '1/10 25.25%',
        theme: viewModel.theme.value,
        headerText: '小说名称',
        contentText: contentText,
        isFirstPage: true,
      ),
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
    viewModel.initSignals(widget.theme);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
      builder: (context) => Watch((_) => builder()),
    );
  }

  void updateTheme() {
    viewModel.storeTheme();
    Navigator.of(context).pop();
  }

  Widget _buildChapterStyleSheet() {
    var children = [
      _SheetTitle('标题样式'),
      _SliderTile(
        label: '字体大小',
        value: viewModel.theme.value.chapterFontSize,
        max: 48.0,
        min: 12.0,
        onChanged: viewModel.updateChapterFontSize,
      ),
      _SliderTile(
        label: '字重',
        value: viewModel.theme.value.chapterFontWeight.toDouble(),
        max: 9.0,
        min: 1.0,
        fractionDigits: 0,
        onChanged: viewModel.updateChapterFontWeight,
      ),
      _SliderTile(
        label: '行高',
        value: viewModel.theme.value.chapterHeight,
        max: 4.0,
        min: 1.0,
        onChanged: viewModel.updateChapterHeight,
      ),
      _SliderTile(
        label: '字间距',
        value: viewModel.theme.value.chapterLetterSpacing,
        onChanged: viewModel.updateChapterLetterSpacing,
      ),
      _SliderTile(
        label: '词间距',
        value: viewModel.theme.value.chapterWordSpacing,
        onChanged: viewModel.updateChapterWordSpacing,
      ),
    ];
    return ListView(children: children);
  }

  Widget _buildContentPaddingSheet() {
    var children = [
      _SheetTitle('正文边距'),
      _SliderTile(
        label: '上边距',
        value: viewModel.theme.value.contentPaddingTop,
        max: 64.0,
        min: 0.0,
        onChanged: viewModel.updateContentPaddingTop,
      ),
      _SliderTile(
        label: '下边距',
        value: viewModel.theme.value.contentPaddingBottom,
        max: 64.0,
        min: 0.0,
        onChanged: viewModel.updateContentPaddingBottom,
      ),
      _SliderTile(
        label: '左边距',
        value: viewModel.theme.value.contentPaddingLeft,
        max: 64.0,
        min: 0.0,
        onChanged: viewModel.updateContentPaddingLeft,
      ),
      _SliderTile(
        label: '右边距',
        value: viewModel.theme.value.contentPaddingRight,
        max: 64.0,
        min: 0.0,
        onChanged: viewModel.updateContentPaddingRight,
      ),
    ];
    return ListView(children: children);
  }

  Widget _buildContentStyleSheet() {
    var children = [
      _SheetTitle('正文样式'),
      _SliderTile(
        label: '字体大小',
        value: viewModel.theme.value.contentFontSize,
        max: 48.0,
        min: 12.0,
        onChanged: viewModel.updateContentFontSize,
      ),
      _SliderTile(
        label: '字重',
        value: viewModel.theme.value.contentFontWeight.toDouble(),
        max: 9.0,
        min: 1.0,
        fractionDigits: 0,
        onChanged: viewModel.updateContentFontWeight,
      ),
      _SliderTile(
        label: '行高',
        value: viewModel.theme.value.contentHeight,
        max: 4.0,
        min: 1.0,
        onChanged: viewModel.updateContentHeight,
      ),
      _SliderTile(
        label: '字间距',
        value: viewModel.theme.value.contentLetterSpacing,
        onChanged: viewModel.updateContentLetterSpacing,
      ),
      _SliderTile(
        label: '词间距',
        value: viewModel.theme.value.contentWordSpacing,
        onChanged: viewModel.updateContentWordSpacing,
      ),
    ];
    return ListView(children: children);
  }

  Widget _buildFooterPaddingSheet() {
    var children = [
      _SheetTitle('页脚边距'),
      _SliderTile(
        label: '上边距',
        value: viewModel.theme.value.footerPaddingTop,
        max: 64.0,
        min: 0.0,
        onChanged: viewModel.updateFooterPaddingTop,
      ),
      _SliderTile(
        label: '下边距',
        value: viewModel.theme.value.footerPaddingBottom,
        max: 64.0,
        min: 0.0,
        onChanged: viewModel.updateFooterPaddingBottom,
      ),
      _SliderTile(
        label: '左边距',
        value: viewModel.theme.value.footerPaddingLeft,
        max: 64.0,
        min: 0.0,
        onChanged: viewModel.updateFooterPaddingLeft,
      ),
      _SliderTile(
        label: '右边距',
        value: viewModel.theme.value.footerPaddingRight,
        max: 64.0,
        min: 0.0,
        onChanged: viewModel.updateFooterPaddingRight,
      ),
    ];
    return ListView(children: children);
  }

  Widget _buildFooterStyleSheet() {
    var children = [
      _SheetTitle('页脚样式'),
      _SliderTile(
        label: '字体大小',
        value: viewModel.theme.value.footerFontSize,
        max: 24.0,
        min: 10.0,
        onChanged: viewModel.updateFooterFontSize,
      ),
      _SliderTile(
        label: '字重',
        value: viewModel.theme.value.footerFontWeight.toDouble(),
        max: 9.0,
        min: 1.0,
        fractionDigits: 0,
        onChanged: viewModel.updateFooterFontWeight,
      ),
      _SliderTile(
        label: '行高',
        value: viewModel.theme.value.footerHeight,
        max: 4.0,
        min: 1.0,
        onChanged: viewModel.updateFooterHeight,
      ),
      _SliderTile(
        label: '字间距',
        value: viewModel.theme.value.footerLetterSpacing,
        onChanged: viewModel.updateFooterLetterSpacing,
      ),
      _SliderTile(
        label: '词间距',
        value: viewModel.theme.value.footerWordSpacing,
        onChanged: viewModel.updateFooterWordSpacing,
      ),
    ];
    return ListView(children: children);
  }

  Widget _buildHeaderPaddingSheet() {
    var children = [
      _SheetTitle('页头边距'),
      _SliderTile(
        label: '上边距',
        value: viewModel.theme.value.headerPaddingTop,
        max: 64.0,
        min: 0.0,
        onChanged: viewModel.updateHeaderPaddingTop,
      ),
      _SliderTile(
        label: '下边距',
        value: viewModel.theme.value.headerPaddingBottom,
        max: 64.0,
        min: 0.0,
        onChanged: viewModel.updateHeaderPaddingBottom,
      ),
      _SliderTile(
        label: '左边距',
        value: viewModel.theme.value.headerPaddingLeft,
        max: 64.0,
        min: 0.0,
        onChanged: viewModel.updateHeaderPaddingLeft,
      ),
      _SliderTile(
        label: '右边距',
        value: viewModel.theme.value.headerPaddingRight,
        max: 64.0,
        min: 0.0,
        onChanged: viewModel.updateHeaderPaddingRight,
      ),
    ];
    return ListView(children: children);
  }

  Widget _buildHeaderStyleSheet() {
    var children = [
      _SheetTitle('页头样式'),
      _SliderTile(
        label: '字体大小',
        value: viewModel.theme.value.headerFontSize,
        max: 24.0,
        min: 10.0,
        onChanged: viewModel.updateHeaderFontSize,
      ),
      _SliderTile(
        label: '字重',
        value: viewModel.theme.value.headerFontWeight.toDouble(),
        max: 9.0,
        min: 1.0,
        fractionDigits: 0,
        onChanged: viewModel.updateHeaderFontWeight,
      ),
      _SliderTile(
        label: '行高',
        value: viewModel.theme.value.headerHeight,
        max: 4.0,
        min: 1.0,
        onChanged: viewModel.updateHeaderHeight,
      ),
      _SliderTile(
        label: '字间距',
        value: viewModel.theme.value.headerLetterSpacing,
        onChanged: viewModel.updateHeaderLetterSpacing,
      ),
      _SliderTile(
        label: '词间距',
        value: viewModel.theme.value.headerWordSpacing,
        onChanged: viewModel.updateHeaderWordSpacing,
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
      _SheetLabel('背景'),
      ListTile(
        onTap: () => ReaderThemeEditorColorPickerRoute().push(context),
        title: Text('颜色'),
        trailing: Container(
          decoration: BoxDecoration(
            color: viewModel.theme.value.backgroundColor.toColor(),
            shape: BoxShape.circle,
          ),
          height: 32,
          width: 32,
        ),
      ),
      ListTile(
        onTap: () => ReaderThemeEditorImageSelectorRoute().push(context),
        title: Text('图片'),
        trailing: ClipOval(
          child: Image.asset(
            'asset/image/kraft_paper.jpg',
            fit: BoxFit.cover,
            height: 32,
            width: 32,
          ),
        ),
      ),
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
    var contentPaddingHorizontal = viewModel.theme.value.contentPaddingLeft +
        viewModel.theme.value.contentPaddingRight;
    var width = mediaQueryData.size.width - contentPaddingHorizontal;
    var contentPaddingVertical = viewModel.theme.value.contentPaddingTop +
        viewModel.theme.value.contentPaddingBottom;
    var height = mediaQueryData.size.height - contentPaddingVertical;
    var headerPaddingVertical = viewModel.theme.value.headerPaddingTop +
        viewModel.theme.value.headerPaddingBottom;
    height -= (headerPaddingVertical +
        viewModel.theme.value.headerHeight *
            viewModel.theme.value.headerFontSize);
    var footerPaddingVertical = viewModel.theme.value.footerPaddingTop +
        viewModel.theme.value.footerPaddingBottom;
    height -= (footerPaddingVertical +
        viewModel.theme.value.footerHeight *
            viewModel.theme.value.footerFontSize);
    setState(() {
      size = Size(width, height);
    });
    var pages = Splitter(size: size, theme: viewModel.theme.value).split(text);
    setState(() {
      contentText = pages.first;
    });
  }
}
