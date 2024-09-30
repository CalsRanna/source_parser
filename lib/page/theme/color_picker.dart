import 'package:flutter/material.dart';

class ColorPicker {
  static Future<Color?> pick(BuildContext context) async {
    final page = _ColorPicker();
    final route = MaterialPageRoute(builder: (_) => page);
    final color = await Navigator.of(context).push(route);
    return color;
  }
}

class _ColorPicker extends StatefulWidget {
  const _ColorPicker();

  @override
  State<_ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<_ColorPicker> {
  final hexController = TextEditingController();
  double hue = 180;
  final redController = TextEditingController();
  final greenController = TextEditingController();
  final blueController = TextEditingController();
  double saturation = 0.5;
  double value = 0.5;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final saturationValuePicker = _SaturationValuePicker(
      hue: hue,
      saturation: saturation,
      value: value,
      width: mediaQuery.size.width - 32,
      onChanged: handleSaturationValueChanged,
    );
    final hueSlider = _HueSlider(
      hue: hue,
      onChanged: handleHueChanged,
      width: mediaQuery.size.width - 32,
    );
    final column = Column(children: [saturationValuePicker, hueSlider]);
    final clipRRect = ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: column,
    );
    final hexColor = _HexColor(
      controller: hexController,
      hue: hue,
      onColorChanged: handleColorChanged,
      saturation: saturation,
      value: value,
    );
    final rgbColor = _RgbColor(
      blueController: blueController,
      greenController: greenController,
      hue: hue,
      onColorChanged: handleColorChanged,
      redController: redController,
      saturation: saturation,
      value: value,
    );
    final children = [
      const Spacer(),
      hexColor,
      const SizedBox(width: 16),
      rgbColor,
    ];
    final inputs = Row(children: children);
    final child = Column(
      children: [clipRRect, SizedBox(height: 16), inputs],
    );
    return Scaffold(
      appBar: AppBar(title: Text('Color Picker')),
      body: Padding(padding: EdgeInsets.all(16), child: child),
    );
  }

  @override
  void dispose() {
    hexController.dispose();
    redController.dispose();
    greenController.dispose();
    blueController.dispose();
    super.dispose();
  }

  void handleColorChanged(Color color) {
    final hsv = HSVColor.fromColor(color);
    setState(() {
      hue = hsv.hue;
      saturation = hsv.saturation;
      value = hsv.value;
    });
    _calculateColor();
  }

  void handleHueChanged(double hue) {
    setState(() {
      this.hue = hue;
    });
    _calculateColor();
  }

  void handleSaturationValueChanged(double saturation, double value) {
    setState(() {
      this.saturation = saturation;
      this.value = value;
    });
    _calculateColor();
  }

  @override
  void initState() {
    _calculateColor();
    super.initState();
  }

  void _calculateColor() {
    final hsv = HSVColor.fromAHSV(1, hue, saturation, value);
    final color = hsv.toColor();
    final hex = color.value.toRadixString(16);
    final text = '#${hex.substring(2).toUpperCase()}';
    hexController.text = text;
    redController.text = color.red.toString();
    greenController.text = color.green.toString();
    blueController.text = color.blue.toString();
  }
}

class _HexColor extends StatelessWidget {
  final TextEditingController controller;
  final double hue;
  final void Function(Color)? onColorChanged;
  final double saturation;
  final double value;

  const _HexColor({
    required this.controller,
    required this.hue,
    this.onColorChanged,
    required this.saturation,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final surfaceContainerHighest = colorScheme.surfaceContainerHighest;
    final boxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      color: surfaceContainerHighest,
    );
    final textField = TextField(
      controller: controller,
      textAlign: TextAlign.center,
      decoration: InputDecoration.collapsed(hintText: 'Hex'),
      onSubmitted: handleSubmitted,
    );
    final container = Container(
      alignment: Alignment.center,
      decoration: boxDecoration,
      height: 36,
      padding: EdgeInsets.symmetric(horizontal: 16),
      width: 120,
      child: textField,
    );
    final children = [container, const SizedBox(height: 8), Text('HEX')];
    return Column(children: children);
  }

  void handleSubmitted(String value) {
    final formatted = value.replaceAll('#', '').padLeft(6, '0');
    final colorValue = int.tryParse('FF$formatted', radix: 16) ?? 0;
    final color = Color(colorValue);
    final text = color.value.toRadixString(16).padLeft(8, '0');
    controller.text = '#${text.substring(2).toUpperCase()}';
    onColorChanged?.call(color);
  }
}

class _HueSlider extends StatelessWidget {
  final double hue;
  final double width;
  final ValueChanged<double> onChanged;

  const _HueSlider({
    required this.hue,
    required this.onChanged,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final boxShadow = BoxShadow(
      blurRadius: 8,
      color: Colors.black.withOpacity(0.4),
    );
    final boxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      boxShadow: [boxShadow],
      color: Colors.white,
    );
    final indicator = Container(
      width: 8,
      height: 32,
      decoration: boxDecoration,
    );
    final positioned = Positioned(
      left: (hue / 360) * width - 4,
      child: indicator,
    );
    final customPaint = CustomPaint(
      painter: _HueSliderPainter(),
      child: Stack(children: [positioned]),
    );
    final gestureDetector = GestureDetector(
      onPanUpdate: (details) => handlePanUpdate(context, details),
      onTapDown: (details) => handleTapDown(context, details),
      child: customPaint,
    );
    return SizedBox(height: 32, width: width, child: gestureDetector);
  }

  void handlePanUpdate(BuildContext context, DragUpdateDetails details) {
    final renderBox = context.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(details.globalPosition);
    final hue = (localPosition.dx / renderBox.size.width);
    onChanged(hue.clamp(0.0, 1.0) * 360);
  }

  void handleTapDown(BuildContext context, TapDownDetails details) {
    final renderBox = context.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(details.globalPosition);
    final hue = (localPosition.dx / renderBox.size.width);
    onChanged(hue.clamp(0.0, 1.0) * 360);
  }
}

class _HueSliderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final colors = List.generate(7, (index) {
      return HSVColor.fromAHSV(1, index * 60, 1, 1).toColor();
    }).toList();
    final gradient = LinearGradient(colors: colors);
    canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RgbColor extends StatelessWidget {
  final TextEditingController blueController;
  final TextEditingController greenController;
  final double hue;
  final void Function(Color)? onColorChanged;
  final TextEditingController redController;
  final double saturation;
  final double value;

  const _RgbColor({
    required this.blueController,
    required this.greenController,
    required this.hue,
    required this.onColorChanged,
    required this.redController,
    required this.saturation,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final surfaceContainerHighest = colorScheme.surfaceContainerHighest;
    final boxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      color: surfaceContainerHighest,
    );
    final hsv = HSVColor.fromAHSV(1, hue, saturation, value);
    final red = _buildTile(boxDecoration, hsv.toColor().red, 'R');
    final green = _buildTile(boxDecoration, hsv.toColor().green, 'G');
    final blue = _buildTile(boxDecoration, hsv.toColor().blue, 'B');
    final spacer = const SizedBox(width: 4);
    return Row(children: [red, spacer, green, spacer, blue]);
  }

  void handleSubmitted(String value, String label) {
    final controller = _getController(label);
    var number = int.tryParse(value) ?? 0;
    number = number.clamp(0, 255);
    controller?.text = number.toString();
    final red = int.tryParse(redController.text) ?? 0;
    final green = int.tryParse(greenController.text) ?? 0;
    final blue = int.tryParse(blueController.text) ?? 0;
    final color = Color.fromARGB(255, red, green, blue);
    onColorChanged?.call(color);
  }

  Column _buildTile(BoxDecoration decoration, int value, String label) {
    final controller = _getController(label);
    final text = TextField(
      controller: controller,
      textAlign: TextAlign.center,
      decoration: InputDecoration.collapsed(hintText: label),
      keyboardType: TextInputType.number,
      onSubmitted: (value) => handleSubmitted(value, label),
    );
    final container = Container(
      alignment: Alignment.center,
      decoration: decoration,
      height: 36,
      padding: EdgeInsets.symmetric(horizontal: 16),
      width: 64,
      child: text,
    );
    final children = [container, const SizedBox(height: 8), Text(label)];
    return Column(children: children);
  }

  TextEditingController? _getController(String label) {
    return switch (label) {
      'R' => redController,
      'G' => greenController,
      'B' => blueController,
      _ => null,
    };
  }
}

class _SaturationValuePainter extends CustomPainter {
  final double hue;

  const _SaturationValuePainter({required this.hue});

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final fullSaturationColor = HSVColor.fromAHSV(1, hue, 1, 1).toColor();
    final saturationGradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [Colors.white, fullSaturationColor],
    );
    final saturationShader = saturationGradient.createShader(rect);
    canvas.drawRect(rect, Paint()..shader = saturationShader);
    final valueGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.transparent, Colors.black],
    );
    final valueShader = valueGradient.createShader(rect);
    canvas.drawRect(rect, Paint()..shader = valueShader);
  }

  @override
  bool shouldRepaint(covariant _SaturationValuePainter oldDelegate) =>
      hue != oldDelegate.hue;
}

class _SaturationValuePicker extends StatelessWidget {
  final double hue;
  final double saturation;
  final double value;
  final double width;
  final Function(double, double) onChanged;

  const _SaturationValuePicker({
    required this.hue,
    required this.saturation,
    required this.value,
    required this.width,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final boxDecoration = BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: Colors.white, width: 2),
    );
    final indicator = Container(
      width: 16,
      height: 16,
      decoration: boxDecoration,
    );
    final positioned = Positioned(
      left: saturation * width - 8,
      top: (1 - value) * 200 - 8,
      child: indicator,
    );
    final customPaint = CustomPaint(
      painter: _SaturationValuePainter(hue: hue),
      child: Stack(children: [positioned]),
    );
    final gestureDetector = GestureDetector(
      onPanUpdate: (details) => handlePanUpdate(context, details),
      onTapDown: (details) => handleTapDown(context, details),
      child: customPaint,
    );
    return SizedBox(height: 200, width: width, child: gestureDetector);
  }

  void handlePanUpdate(BuildContext context, DragUpdateDetails details) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final localPosition = box.globalToLocal(details.globalPosition);
    final saturation = (localPosition.dx / box.size.width).clamp(0.0, 1.0);
    final value = 1 - (localPosition.dy / box.size.height).clamp(0.0, 1.0);
    onChanged(saturation, value);
  }

  void handleTapDown(BuildContext context, TapDownDetails details) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final localPosition = box.globalToLocal(details.globalPosition);
    final saturation = (localPosition.dx / box.size.width).clamp(0.0, 1.0);
    final value = 1 - (localPosition.dy / box.size.height).clamp(0.0, 1.0);
    onChanged(saturation, value);
  }
}
