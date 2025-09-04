import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RubiBankLogo extends StatelessWidget {
  final double size;
  final Color color;
  final double strokeWidth;

  const RubiBankLogo({
    super.key,
    this.size = 24.0,
    this.color = Colors.black,
    this.strokeWidth = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final hexColor = _colorToHex(color);

    return SvgPicture.string(
      '''
      <svg width="$size" height="$size" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" aria-label="RubiBank Logo">
        <path d="M6 4L12 2L18 4L21 9L12 22L3 9L6 4Z" stroke="$hexColor" stroke-width="$strokeWidth" stroke-linejoin="round"/>
        <path d="M3 9L12 12L21 9" stroke="$hexColor" stroke-width="$strokeWidth" stroke-linejoin="round"/>
        <path d="M12 22V12" stroke="$hexColor" stroke-width="$strokeWidth" stroke-linejoin="round"/>
        <path d="M6 4L12 12L18 4" stroke="$hexColor" stroke-width="$strokeWidth" stroke-linejoin="round"/>
      </svg>
      ''',
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }

  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';
  }
}