import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CardRubiLogo extends StatelessWidget {
  const CardRubiLogo({super.key});

  @override
  Widget build(BuildContext context) {
    // SVG content for the RubiBank Logo
    const String svgString = '''
    <svg width="40" height="40" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg" aria-label="RubiBank Logo">
        <path d="M50 5 L90 35 L75 90 L25 90 L10 35 Z" fill="none" stroke="white" strokeWidth="4" opacity="0.3" />
        <path d="M50 5 L50 90" stroke="white" strokeWidth="3" opacity="0.2"/>
        <path d="M10 35 L75 90" stroke="white" strokeWidth="3" opacity="0.2"/>
        <path d="M90 35 L25 90" stroke="white" strokeWidth="3" opacity="0.2"/>
    </svg>
    ''';

    return SvgPicture.string(
      svgString,
      width: 40,
      height: 40,
      // You might need to specify a color filter if the SVG fills should respect the theme
      // colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
    );
  }
}