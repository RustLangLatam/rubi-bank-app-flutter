import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RubiBankLogo extends StatelessWidget {
  const RubiBankLogo({super.key, this.size = 96});
  final double size;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      _svgCode,
      width: size,
      height: size,
      color: null,
    );
  }
}

const String _svgCode = '''
<svg width="96" height="96" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <linearGradient id="rubyRed" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#E53935"/>
      <stop offset="100%" stop-color="#B71C1C"/>
    </linearGradient>
    <radialGradient id="rubyGlow" cx="50%" cy="50%" r="50%" fx="50%" fy="50%">
      <stop offset="0%" stop-color="#F44336" stop-opacity="0.7"/>
      <stop offset="100%" stop-color="#B71C1C" stop-opacity="1"/>
    </radialGradient>
  </defs>
  <path d="M50 2 L95 35 L78 95 L22 95 L5 35 Z" fill="url(#rubyRed)" stroke="#880E4F" stroke-width="0.5"/>
  <path d="M50 2 L95 35 L78 95 L22 95 L5 35 Z" fill="url(#rubyGlow)"/>
  <path d="M50 2 L50 90" stroke="#C62828" stroke-width="0.7" opacity="0.5"/>
  <path d="M5 35 L78 95" stroke="#C62828" stroke-width="0.7" opacity="0.5"/>
  <path d="M95 35 L22 95" stroke="#C62828" stroke-width="0.7" opacity="0.5"/>
  <path d="M50 2 L95 35 L50 45 Z" fill="#E57373" opacity="0.2"/>
  <path d="M50 2 L5 35 L50 45 Z" fill="#EF9A9A" opacity="0.2"/>
  <path d="M5 35 L22 95 L50 45 Z" fill="#B71C1C" opacity="0.3"/>
  <path d="M95 35 L78 95 L50 45 Z" fill="#880E4F" opacity="0.3"/>
</svg>
''';