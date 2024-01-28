import 'package:flutter/widgets.dart';

class GradientTextMolecule extends StatelessWidget {
  const GradientTextMolecule(
    this.text, {
    required this.gradient,
    super.key,
    this.style,
  });

  final String text;
  final TextStyle? style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style),
    );
  }
}
