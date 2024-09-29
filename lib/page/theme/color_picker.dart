import 'package:flutter/material.dart';

class ColorPicker extends StatefulWidget {
  const ColorPicker({super.key});

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  double hue = 0;
  double saturation = 1;
  double value = 1;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Color Picker')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Column(
                children: [
                  SaturationValuePicker(
                    hue: hue,
                    saturation: saturation,
                    value: value,
                    width: mediaQuery.size.width - 32,
                    onChanged: (saturation, value) {
                      setState(() {
                        this.saturation = saturation;
                        this.value = value;
                      });
                    },
                  ),
                  HueSlider(
                    hue: hue,
                    onChanged: (newHue) {
                      setState(() => hue = newHue);
                    },
                    width: mediaQuery.size.width - 32,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                _HexColor(hue: hue, saturation: saturation, value: value),
                const SizedBox(width: 16),
                _RgbColor(hue: hue, saturation: saturation, value: value),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _RgbColor extends StatelessWidget {
  const _RgbColor({
    super.key,
    required this.hue,
    required this.saturation,
    required this.value,
  });

  final double hue;
  final double saturation;
  final double value;

  @override
  Widget build(BuildContext context) {
    final hsv = HSVColor.fromAHSV(1, hue, saturation, value);
    final red = hsv.toColor().red.toString();
    final green = hsv.toColor().green.toString();
    final blue = hsv.toColor().blue.toString();
    return Text('$red, $green, $blue');
  }
}

class _HexColor extends StatelessWidget {
  const _HexColor({
    super.key,
    required this.hue,
    required this.saturation,
    required this.value,
  });

  final double hue;
  final double saturation;
  final double value;

  @override
  Widget build(BuildContext context) {
    final hsv = HSVColor.fromAHSV(1, hue, saturation, value);
    final hex = hsv.toColor().value.toRadixString(16);
    return Text('#${hex.substring(2).toUpperCase()}');
  }
}

class HueSlider extends StatelessWidget {
  final double hue;
  final double width;
  final ValueChanged<double> onChanged;

  const HueSlider(
      {super.key,
      required this.hue,
      required this.onChanged,
      required this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      width: width,
      child: CustomPaint(
        painter: HueSliderPainter(),
        child: Stack(
          children: [
            Positioned(
              left: hue * width - 8,
              top: -2,
              child: Container(
                width: 8,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HueSliderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final gradient = LinearGradient(
      colors: [
        for (var h = 0; h <= 360; h += 60)
          HSVColor.fromAHSV(1, h.toDouble(), 1, 1).toColor(),
      ],
    );
    canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SaturationValuePicker extends StatelessWidget {
  final double hue;
  final double saturation;
  final double value;
  final double width;
  final Function(double, double) onChanged;

  const SaturationValuePicker({
    super.key,
    required this.hue,
    required this.saturation,
    required this.value,
    required this.width,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: width,
      child: GestureDetector(
        onPanUpdate: (details) {
          final RenderBox box = context.findRenderObject() as RenderBox;
          final localPosition = box.globalToLocal(details.globalPosition);
          final newSaturation =
              (localPosition.dx / box.size.width).clamp(0.0, 1.0);
          final newValue =
              1 - (localPosition.dy / box.size.height).clamp(0.0, 1.0);
          onChanged(newSaturation, newValue);
        },
        child: CustomPaint(
          painter: SaturationValuePainter(hue: hue),
          child: Stack(
            children: [
              Positioned(
                left: saturation * width - 8,
                top: (1 - value) * 200 - 8,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SaturationValuePainter extends CustomPainter {
  final double hue;

  SaturationValuePainter({required this.hue});

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;

    // Draw the fully saturated color for the current hue
    final fullSaturationColor = HSVColor.fromAHSV(1, hue, 1, 1).toColor();

    // Create a gradient from white to the fully saturated color
    final saturationGradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [Colors.white, fullSaturationColor],
    );

    // Draw the saturation gradient
    canvas.drawRect(
        rect, Paint()..shader = saturationGradient.createShader(rect));

    // Create a gradient from transparent to black
    final valueGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.transparent, Colors.black],
    );

    // Draw the value gradient on top of the saturation gradient
    canvas.drawRect(rect, Paint()..shader = valueGradient.createShader(rect));
  }

  @override
  bool shouldRepaint(covariant SaturationValuePainter oldDelegate) =>
      hue != oldDelegate.hue;
}
