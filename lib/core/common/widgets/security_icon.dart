import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SecurityIcon extends StatelessWidget {
  const SecurityIcon({super.key, this.size = 128, this.color});

  final double size;
  final Color? color; // optional color to override SVG

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      _svgCode,
      width: size,
      height: size,
      color: color,
    );
  }
}

const String _svgCode = '''
<svg width="128" height="128" viewBox="0 0 24 24" fill="none" 
     xmlns="http://www.w3.org/2000/svg">
  <g stroke="currentColor" stroke-width="0.8" stroke-linecap="round" stroke-linejoin="round">
    <!-- Shield outline -->
    <path d="M12 2 L20 6 V12 C20 17 16 21 12 22 C8 21 4 17 4 12 V6 L12 2 Z"/>
    <!-- Minimal checkmark -->
    <path d="M9 12 L11 14 L15 10"/>
  </g>
</svg>
''';
