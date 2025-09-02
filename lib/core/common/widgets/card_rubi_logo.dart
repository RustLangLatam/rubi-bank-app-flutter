import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CardRubiLogo extends StatelessWidget {
  final double size;
  final Color? color;
  const CardRubiLogo({super.key, this.size = 40, this.color});

  @override
  Widget build(BuildContext context) {
    // SVG content for the RubiBank Logo with stronger lines
    const String svgString = '''
    <svg width="40" height="40" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg" aria-label="RubiBank Logo">
        <path d="M50 5 L90 35 L75 90 L25 90 L10 35 Z" 
              fill="none" stroke="white" stroke-width="1.5" opacity="0.6" />
        <path d="M50 5 L50 90" 
              stroke="white" stroke-width="1.0" opacity="0.3"/>
        <path d="M10 35 L75 90" 
              stroke="white" stroke-width="1.0" opacity="0.3"/>
        <path d="M90 35 L25 90" 
              stroke="white" stroke-width="1.0" opacity="0.3"/>
    </svg>
    ''';

    return SvgPicture.string(
      svgString,
      width: size,
      height: size,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
    );
  }
}
