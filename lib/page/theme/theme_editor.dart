import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:source_parser/model/reader_theme.dart';
import 'package:source_parser/page/reader/component/background.dart';
import 'package:source_parser/page/reader/component/view.dart';
import 'package:source_parser/provider/setting.dart';
import 'package:source_parser/util/splitter.dart';

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
  var theme = ReaderTheme();
  var size = Size.zero;

  bool _showOverlay = true;

  @override
  Widget build(BuildContext context) {
    var readerView = ReaderView(
      chapterText: '1/10',
      customTheme: theme,
      eInkMode: false,
      headerText: '小说名称或者章节名称',
      contentText: contentText,
      progressText: '25.5%',
    );
    var children = [
      ReaderBackground(),
      readerView,
      if (_showOverlay) _buildOverlay(),
    ];
    return Stack(children: children);
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
    setState(() {
      _showOverlay = false;
    });
    await showModalBottomSheet(
      showDragHandle: true,
      context: context,
      builder: (_) => _buildSettingSheet(),
    );
    setState(() {
      _showOverlay = true;
    });
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _assembleReaderTheme();
      text = _fakeChapter();
      _initContentText();
    });
  }

  void showChapterSheet() => showSheet(_buildChapterStyleSheet);

  void showContentSheet() => showSheet(_buildContentStyleSheet);

  void showFooterPaddingSheet() => showSheet(_buildFooterPaddingSheet);
  void showFooterSheet() => showSheet(_buildFooterStyleSheet);
  void showHeaderPaddingSheet() => showSheet(_buildHeaderPaddingSheet);
  void showHeaderSheet() => showSheet(_buildHeaderStyleSheet);
  void showPagePaddingSheet() => showSheet(_buildPagePaddingSheet);
  void showSheet(Widget Function() builder) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) => builder(),
    );
  }

  void updateChapterFontSize(double value) {
    var style = theme.chapterStyle.copyWith(fontSize: value);
    setState(() {
      theme = theme.copyWith(chapterStyle: style);
    });
    _initContentText();
  }

  void updateChapterFontWeight(double value) {
    var weight = FontWeight.values[(value.toInt() - 1)];
    var style = theme.chapterStyle.copyWith(fontWeight: weight);
    setState(() {
      theme = theme.copyWith(chapterStyle: style);
    });
    _initContentText();
  }

  void updateChapterHeight(double value) {
    var style = theme.chapterStyle.copyWith(height: value);
    setState(() {
      theme = theme.copyWith(chapterStyle: style);
    });
    _initContentText();
  }

  void updateChapterLetterSpacing(double value) {
    var style = theme.chapterStyle.copyWith(letterSpacing: value);
    setState(() {
      theme = theme.copyWith(chapterStyle: style);
    });
    _initContentText();
  }

  void updateChapterWordSpacing(double value) {
    var style = theme.chapterStyle.copyWith(wordSpacing: value);
    setState(() {
      theme = theme.copyWith(chapterStyle: style);
    });
    _initContentText();
  }

  void updateFooterFontSize(double value) {
    var style = theme.footerStyle.copyWith(fontSize: value);
    setState(() {
      theme = theme.copyWith(footerStyle: style);
    });
    _initContentText();
  }

  void updateFooterFontWeight(double value) {
    var weight = FontWeight.values[(value.toInt() - 1)];
    var style = theme.footerStyle.copyWith(fontWeight: weight);
    setState(() {
      theme = theme.copyWith(footerStyle: style);
    });
    _initContentText();
  }

  void updateFooterHeight(double value) {
    var style = theme.footerStyle.copyWith(height: value);
    setState(() {
      theme = theme.copyWith(footerStyle: style);
    });
    _initContentText();
  }

  void updateFooterLetterSpacing(double value) {
    var style = theme.footerStyle.copyWith(letterSpacing: value);
    setState(() {
      theme = theme.copyWith(footerStyle: style);
    });
    _initContentText();
  }

  void updateFooterPadding(EdgeInsets value) {
    setState(() {
      theme = theme.copyWith(footerPadding: value);
    });
    _initContentText();
  }

  void updateFooterPaddingBottom(double value) {
    var current = theme.footerPadding;
    updateFooterPadding(current.copyWith(bottom: value));
  }

  void updateFooterPaddingLeft(double value) {
    var current = theme.footerPadding;
    updateFooterPadding(current.copyWith(left: value));
  }

  void updateFooterPaddingRight(double value) {
    var current = theme.footerPadding;
    updateFooterPadding(current.copyWith(right: value));
  }

  void updateFooterPaddingTop(double value) {
    var current = theme.footerPadding;
    updateFooterPadding(current.copyWith(top: value));
  }

  void updateFooterWordSpacing(double value) {
    var style = theme.footerStyle.copyWith(wordSpacing: value);
    setState(() {
      theme = theme.copyWith(footerStyle: style);
    });
    _initContentText();
  }

  void updateHeaderFontSize(double value) {
    var style = theme.headerStyle.copyWith(fontSize: value);
    setState(() {
      theme = theme.copyWith(headerStyle: style);
    });
    _initContentText();
  }

  void updateHeaderFontWeight(double value) {
    var weight = FontWeight.values[(value.toInt() - 1)];
    var style = theme.headerStyle.copyWith(fontWeight: weight);
    setState(() {
      theme = theme.copyWith(headerStyle: style);
    });
    _initContentText();
  }

  void updateHeaderHeight(double value) {
    var style = theme.headerStyle.copyWith(height: value);
    setState(() {
      theme = theme.copyWith(headerStyle: style);
    });
    _initContentText();
  }

  void updateHeaderLetterSpacing(double value) {
    var style = theme.headerStyle.copyWith(letterSpacing: value);
    setState(() {
      theme = theme.copyWith(headerStyle: style);
    });
    _initContentText();
  }

  void updateHeaderPadding(EdgeInsets value) {
    setState(() {
      theme = theme.copyWith(headerPadding: value);
    });
    _initContentText();
  }

  void updateHeaderPaddingBottom(double value) {
    var current = theme.headerPadding;
    updateHeaderPadding(current.copyWith(bottom: value));
  }

  void updateHeaderPaddingLeft(double value) {
    var current = theme.headerPadding;
    updateHeaderPadding(current.copyWith(left: value));
  }

  void updateHeaderPaddingRight(double value) {
    var current = theme.headerPadding;
    updateHeaderPadding(current.copyWith(right: value));
  }

  void updateHeaderPaddingTop(double value) {
    var current = theme.headerPadding;
    updateHeaderPadding(current.copyWith(top: value));
  }

  void updateHeaderWordSpacing(double value) {
    var style = theme.headerStyle.copyWith(wordSpacing: value);
    setState(() {
      theme = theme.copyWith(headerStyle: style);
    });
    _initContentText();
  }

  void updatePageFontSize(double value) {
    var style = theme.pageStyle.copyWith(fontSize: value);
    setState(() {
      theme = theme.copyWith(pageStyle: style);
    });
    _initContentText();
  }

  void updatePageFontWeight(double value) {
    var weight = FontWeight.values[(value.toInt() - 1)];
    var style = theme.pageStyle.copyWith(fontWeight: weight);
    setState(() {
      theme = theme.copyWith(pageStyle: style);
    });
    _initContentText();
  }

  void updatePageHeight(double value) {
    var style = theme.pageStyle.copyWith(height: value);
    setState(() {
      theme = theme.copyWith(pageStyle: style);
    });
    _initContentText();
  }

  void updatePageLetterSpacing(double value) {
    var style = theme.pageStyle.copyWith(letterSpacing: value);
    setState(() {
      theme = theme.copyWith(pageStyle: style);
    });
    _initContentText();
  }

  void updatePagePadding(EdgeInsets value) {
    setState(() {
      theme = theme.copyWith(pagePadding: value);
    });
    _initContentText();
  }

  void updatePagePaddingBottom(double value) {
    var current = theme.pagePadding;
    updatePagePadding(current.copyWith(bottom: value));
  }

  void updatePagePaddingLeft(double value) {
    var current = theme.pagePadding;
    updatePagePadding(current.copyWith(left: value));
  }

  void updatePagePaddingRight(double value) {
    var current = theme.pagePadding;
    updatePagePadding(current.copyWith(right: value));
  }

  void updatePagePaddingTop(double value) {
    var current = theme.pagePadding;
    updatePagePadding(current.copyWith(top: value));
  }

  void updatePageWordSpacing(double value) {
    var style = theme.pageStyle.copyWith(wordSpacing: value);
    setState(() {
      theme = theme.copyWith(pageStyle: style);
    });
    _initContentText();
  }

  void updateTheme() {
    var provider = settingNotifierProvider;
    var notifier = ref.read(provider.notifier);
    // notifier.updateBackgroundColor(colorValue)
  }

  Future<void> _assembleReaderTheme() async {
    var container = ProviderScope.containerOf(context);
    final provider = settingNotifierProvider;
    var setting = await container.read(provider.future);
    Color backgroundColor = Color(setting.backgroundColor);
    Color fontColor = Colors.black.withOpacity(0.75);
    Color variantFontColor = Colors.black.withOpacity(0.5);
    if (setting.darkMode) {
      backgroundColor = Colors.black;
      fontColor = Colors.white.withOpacity(0.75);
      variantFontColor = Colors.white.withOpacity(0.5);
    }
    var assembledTheme = theme.copyWith(
      backgroundColor: backgroundColor,
      chapterStyle: theme.chapterStyle.copyWith(color: fontColor),
      footerStyle: theme.footerStyle.copyWith(color: variantFontColor),
      headerStyle: theme.headerStyle.copyWith(color: variantFontColor),
      pageStyle: theme.pageStyle.copyWith(color: fontColor),
    );
    setState(() {
      theme = assembledTheme;
    });
  }

  Widget _buildChapterStyleSheet() {
    var children = [
      _SheetTitle('标题样式'),
      _SliderTile(
        label: '字体大小',
        value: theme.chapterStyle.fontSize ?? 18.0,
        max: 48.0,
        min: 12.0,
        onChanged: updateChapterFontSize,
      ),
      _SliderTile(
        label: '字重',
        value: _getWeight(theme.chapterStyle.fontWeight ?? FontWeight.w500),
        max: 9.0,
        min: 1.0,
        fractionDigits: 0,
        onChanged: updateChapterFontWeight,
      ),
      _SliderTile(
        label: '行高',
        value: theme.chapterStyle.height ?? 1.0 + 0.618 * 2,
        max: 4.0,
        min: 1.0,
        onChanged: updateChapterHeight,
      ),
      _SliderTile(
        label: '字间距',
        value: theme.chapterStyle.letterSpacing ?? 0.618,
        onChanged: updateChapterLetterSpacing,
      ),
      _SliderTile(
        label: '词间距',
        value: theme.chapterStyle.wordSpacing ?? 0.618,
        onChanged: updateChapterWordSpacing,
      ),
    ];
    return ListView(children: children);
  }

  Widget _buildContentStyleSheet() {
    var children = [
      _SheetTitle('正文样式'),
      _SliderTile(
        label: '字体大小',
        value: theme.pageStyle.fontSize ?? 18.0,
        max: 32.0,
        min: 12.0,
        onChanged: updatePageFontSize,
      ),
      _SliderTile(
        label: '字重',
        value: _getWeight(theme.pageStyle.fontWeight ?? FontWeight.w400),
        max: 9.0,
        min: 1.0,
        fractionDigits: 0,
        onChanged: updatePageFontWeight,
      ),
      _SliderTile(
        label: '行高',
        value: theme.pageStyle.height ?? 1.0 + 0.618 * 2,
        max: 4.0,
        min: 1.0,
        onChanged: updatePageHeight,
      ),
      _SliderTile(
        label: '字间距',
        value: theme.pageStyle.letterSpacing ?? 0.618,
        onChanged: updatePageLetterSpacing,
      ),
      _SliderTile(
        label: '词间距',
        value: theme.pageStyle.wordSpacing ?? 0.618,
        onChanged: updatePageWordSpacing,
      ),
    ];
    return ListView(children: children);
  }

  Widget _buildFooterPaddingSheet() {
    var children = [
      _SheetTitle('页脚边距'),
      _SliderTile(
        label: '上边距',
        value: theme.footerPadding.top,
        max: 64.0,
        min: 0.0,
        onChanged: updateFooterPaddingTop,
      ),
      _SliderTile(
        label: '下边距',
        value: theme.footerPadding.bottom,
        max: 64.0,
        min: 0.0,
        onChanged: updateFooterPaddingBottom,
      ),
      _SliderTile(
        label: '左边距',
        value: theme.footerPadding.left,
        max: 64.0,
        min: 0.0,
        onChanged: updateFooterPaddingLeft,
      ),
      _SliderTile(
        label: '右边距',
        value: theme.footerPadding.right,
        max: 64.0,
        min: 0.0,
        onChanged: updateFooterPaddingRight,
      ),
    ];
    return ListView(children: children);
  }

  Widget _buildFooterStyleSheet() {
    var children = [
      _SheetTitle('页脚样式'),
      _SliderTile(
        label: '字体大小',
        value: theme.footerStyle.fontSize ?? 18.0,
        max: 32.0,
        min: 12.0,
        onChanged: updateFooterFontSize,
      ),
      _SliderTile(
        label: '字重',
        value: _getWeight(theme.footerStyle.fontWeight ?? FontWeight.w400),
        max: 9.0,
        min: 1.0,
        fractionDigits: 0,
        onChanged: updateFooterFontWeight,
      ),
      _SliderTile(
        label: '行高',
        value: theme.footerStyle.height ?? 1.0 + 0.618 * 2,
        max: 4.0,
        min: 1.0,
        onChanged: updateFooterHeight,
      ),
      _SliderTile(
        label: '字间距',
        value: theme.footerStyle.letterSpacing ?? 0.618,
        onChanged: updateFooterLetterSpacing,
      ),
      _SliderTile(
        label: '词间距',
        value: theme.footerStyle.wordSpacing ?? 0.618,
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
        value: theme.headerPadding.top,
        max: 64.0,
        min: 0.0,
        onChanged: updateHeaderPaddingTop,
      ),
      _SliderTile(
        label: '下边距',
        value: theme.headerPadding.bottom,
        max: 64.0,
        min: 0.0,
        onChanged: updateHeaderPaddingBottom,
      ),
      _SliderTile(
        label: '左边距',
        value: theme.headerPadding.left,
        max: 64.0,
        min: 0.0,
        onChanged: updateHeaderPaddingLeft,
      ),
      _SliderTile(
        label: '右边距',
        value: theme.headerPadding.right,
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
        value: theme.footerStyle.fontSize ?? 18.0,
        max: 32.0,
        min: 12.0,
        onChanged: updateHeaderFontSize,
      ),
      _SliderTile(
        label: '字重',
        value: _getWeight(theme.headerStyle.fontWeight ?? FontWeight.w400),
        max: 9.0,
        min: 1.0,
        fractionDigits: 0,
        onChanged: updateHeaderFontWeight,
      ),
      _SliderTile(
        label: '行高',
        value: theme.headerStyle.height ?? 1.0 + 0.618 * 2,
        max: 4.0,
        min: 1.0,
        onChanged: updateHeaderHeight,
      ),
      _SliderTile(
        label: '字间距',
        value: theme.headerStyle.letterSpacing ?? 0.618,
        onChanged: updateHeaderLetterSpacing,
      ),
      _SliderTile(
        label: '词间距',
        value: theme.headerStyle.wordSpacing ?? 0.618,
        onChanged: updateHeaderWordSpacing,
      ),
    ];
    return ListView(children: children);
  }

  Widget _buildOverlay() {
    var iconButton = IconButton(
      onPressed: updateTheme,
      icon: Icon(HugeIcons.strokeRoundedTick02),
    );
    var floatingActionButton = FloatingActionButton(
      onPressed: handleTap,
      child: const Icon(HugeIcons.strokeRoundedPaintBoard),
    );
    return Scaffold(
      appBar: AppBar(actions: [iconButton], title: Text('自定义主题')),
      backgroundColor: Colors.transparent,
      floatingActionButton: floatingActionButton,
    );
  }

  Widget _buildPagePaddingSheet() {
    var children = [
      _SheetTitle('正文边距'),
      _SliderTile(
        label: '上边距',
        value: theme.pagePadding.top,
        max: 64.0,
        min: 0.0,
        onChanged: updatePagePaddingTop,
      ),
      _SliderTile(
        label: '下边距',
        value: theme.pagePadding.bottom,
        max: 64.0,
        min: 0.0,
        onChanged: updatePagePaddingBottom,
      ),
      _SliderTile(
        label: '左边距',
        value: theme.pagePadding.left,
        max: 64.0,
        min: 0.0,
        onChanged: updatePagePaddingLeft,
      ),
      _SliderTile(
        label: '右边距',
        value: theme.pagePadding.right,
        max: 64.0,
        min: 0.0,
        onChanged: updatePagePaddingRight,
      ),
    ];
    return ListView(children: children);
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
      _ListTile(onTap: showPagePaddingSheet, title: '正文边距'),
      _ListTile(onTap: showFooterPaddingSheet, title: '页脚边距'),
    ];
    return ListView(children: children);
  }

  String _fakeChapter() {
    // 常用中文字符集
    const String commonChars =
        '的一是在不了有和人这中大为上个国我以要他时来用们生到作地于出就分对成会可主发年动同工也能下过子说产种'
        '面而方后多定行学法所民得经十三之进着等部度家电力里如水化高自二理起小物现实加量都两体制机当使点从业本'
        '去把性好应开它合还因由其些然前外天政四日那社义事平形相全表间样与关各重新线内数正心反你明看原又么利比'
        '或但质气第向道命此变条只没结解问意建月公无系军很情者最立代想已通并提直题党程展五果料象员革位入常文总'
        '次品式活设及管特件长求老头基资边流路级少图山统接知较将组见计别她手角期根论运农指几九区强放决西被干做'
        '必战先回则任取据处队南给色光门即保治北造百规热领七海口东导器压志世金增争济阶油思术极交受联什认六共权'
        '收证改清己美再采转更单风切打白教速花带安场身车例真务具万每目至达走积示议声报斗完类八离华名确才科张信'
        '马节话米整空元况今集温传土许步群广石记需段研界拉林律叫且究观越织装影算低持音众书布复容儿须际商非验连'
        '断深难近矿千周委素技备半办青省列习响约支般史感劳便团往酸历市克何除消构府称太准精值号率族维划选标写存'
        '候毛亲快效斯院查江型眼王按格养易置派层片始却专状育厂京识适属圆包火住调满县局照参红细引听该铁价严龙飞';

    final random = Random();
    final buffer = StringBuffer();
    buffer.write('第一章 ');
    int currentLineLength = 0;
    int totalChars = 3;
    var hasTitle = true;
    while (totalChars < 500) {
      // 随机决定是否换行 (大约每15-40个字符有20%的概率换行)
      if (currentLineLength > random.nextInt(25) + 15 &&
          random.nextDouble() < 0.2) {
        if (!hasTitle) buffer.write('。');
        hasTitle = false;
        buffer.write('\n');
        buffer.write('　　'); // 添加两个中文全角空格
        currentLineLength = 0;
        continue;
      }

      // 从常用字符集中随机选择一个字符
      final charIndex = random.nextInt(commonChars.length);
      buffer.write(commonChars[charIndex]);
      currentLineLength++;
      totalChars++;
    }

    return buffer.toString();
  }

  double _getWeight(FontWeight weight) {
    return (weight.index + 1).toDouble();
  }

  Future<void> _initContentText() async {
    var mediaQueryData = MediaQuery.of(context);
    var width = mediaQueryData.size.width - theme.pagePadding.horizontal;
    var height = mediaQueryData.size.height - theme.pagePadding.vertical;
    height -= (theme.headerPadding.vertical +
        theme.headerStyle.fontSize! * theme.headerStyle.height!);
    height -= (theme.footerPadding.vertical +
        theme.footerStyle.fontSize! * theme.footerStyle.height!);
    setState(() {
      size = Size(width, height);
    });
    var pages = Splitter(size: size, theme: theme).split(text);
    setState(() {
      contentText = pages.first;
    });
  }
}
