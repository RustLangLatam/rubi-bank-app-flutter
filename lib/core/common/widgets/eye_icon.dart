import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EyeIcon extends StatelessWidget {
  final double size;
  final Color? color;

  const EyeIcon({super.key, this.size = 24, this.color});

  @override
  Widget build(BuildContext context) {
    const String svgString = '''
    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth="1.5">
        <path strokeLinecap="round" strokeLinejoin="round" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
        <path strokeLinecap="round" strokeLinejoin="round" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
    </svg>
    ''';

    return SvgPicture.string(
      svgString,
      width: size,
      height: size,
      colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
    );
  }
}
