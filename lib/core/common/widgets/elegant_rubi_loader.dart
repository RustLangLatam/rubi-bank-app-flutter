import 'package:flutter/material.dart';

class ElegantRubiLoader extends StatefulWidget {
  const ElegantRubiLoader({super.key});

  @override
  State<ElegantRubiLoader> createState() => _ElegantRubiLoaderState();
}

class _ElegantRubiLoaderState extends State<ElegantRubiLoader> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  late AnimationController _glint1Controller;
  late Animation<double> _glint1Animation;

  late AnimationController _glint2Controller;
  late Animation<double> _glint2Animation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: const Cubic(0.4, 0.0, 0.6, 1.0), // Matches cubic-bezier(0.4, 0, 0.6, 1)
      ),
    );

    _glint1Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();
    _glint1Animation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 0.9), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 0.9, end: 0.0), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 0.0), weight: 3),
    ]).animate(_glint1Controller);

    _glint2Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();
    _glint2Animation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 0.7), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 0.7, end: 0.0), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 0.0), weight: 4),
    ]).animate(CurvedAnimation(
      parent: _glint2Controller,
      curve: const Interval(0.1667, 1.0), // Matches begin="0.5s" (0.5s / 3s = 0.1667)
    ));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _glint1Controller.dispose();
    _glint2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 96, // Matches w-24 (24 * 4)
        height: 96, // Matches h-24 (24 * 4)
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _pulseAnimation,
            _glint1Animation,
            _glint2Animation,
          ]),
          builder: (context, child) {
            // Map pulseAnimation (0.0 to 1.0) to scale (1.0 to 1.05) and opacity (0.9 to 1.0)
            final scale = 1.0 + (_pulseAnimation.value * 0.05); // 1.0 + (0.0 to 1.0) * 0.05 = 1.0 to 1.05
            final opacity = 0.9 + (_pulseAnimation.value * 0.1); // 0.9 + (0.0 to 1.0) * 0.1 = 0.9 to 1.0

            return Transform.scale(
              scale: scale,
              child: Opacity(
                opacity: opacity,
                child: CustomPaint(
                  painter: RubyPainter(
                    glint1Opacity: _glint1Animation.value,
                    glint2Opacity: _glint2Animation.value,
                  ),
                  size: const Size(96, 96),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class RubyPainter extends CustomPainter {
  final double glint1Opacity;
  final double glint2Opacity;

  RubyPainter({
    required this.glint1Opacity,
    required this.glint2Opacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / 100;
    final double scaleY = size.height / 100;

    canvas.save();
    canvas.scale(scaleX, scaleY);

    // Apply drop shadow
    final Path rubyPath = Path()
      ..moveTo(50, 2)
      ..lineTo(95, 35)
      ..lineTo(78, 95)
      ..lineTo(22, 95)
      ..lineTo(5, 35)
      ..close();

    canvas.drawPath(
      rubyPath,
      Paint()
        ..color = const Color(0xFFC5A365).withOpacity(0.6) // Matches drop-shadow rgba(197, 163, 101, 0.6)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15.0), // Matches drop-shadow 15px
    );

    // Ruby Core Glow
    final Paint rubyCorePaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment.center,
        radius: 0.5,
        colors: [
          Color(0xFFD8B77C), // primary-hover
          Color(0xFFA47D42), // darker shade of primary
        ],
      ).createShader(Rect.fromLTWH(0, 0, 100, 100));

    canvas.drawPath(rubyPath, rubyCorePaint);

    // Darker facets
    final Paint darkFacet1Paint = Paint()..color = const Color(0xFF060B14).withOpacity(0.4); // background
    final Path darkFacet1 = Path()
      ..moveTo(5, 35)
      ..lineTo(22, 95)
      ..lineTo(50, 45)
      ..close();
    canvas.drawPath(darkFacet1, darkFacet1Paint);

    final Paint darkFacet2Paint = Paint()..color = const Color(0xFF0D1626).withOpacity(0.4); // surface-dark
    final Path darkFacet2 = Path()
      ..moveTo(95, 35)
      ..lineTo(78, 95)
      ..lineTo(50, 45)
      ..close();
    canvas.drawPath(darkFacet2, darkFacet2Paint);

    // Lighter facets (facetShine)
    final Paint facetShinePaint1 = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFEAEBF0), // on-background, opacity 0.5 handled in shader
          Color(0xFFC5A365), // primary, opacity 0.2 handled in shader
        ],
        stops: [0.0, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, 100, 100));
    final Path facetShine1 = Path()
      ..moveTo(50, 2)
      ..lineTo(95, 35)
      ..lineTo(50, 45)
      ..close();
    canvas.drawPath(facetShine1, facetShinePaint1);

    final Paint facetShinePaint2 = Paint()..color = const Color(0xFFEAEBF0).withOpacity(0.3); // on-background
    final Path facetShine2 = Path()
      ..moveTo(50, 2)
      ..lineTo(5, 35)
      ..lineTo(50, 45)
      ..close();
    canvas.drawPath(facetShine2, facetShinePaint2);

    // Glint 1 (Triangle)
    final Paint glint1Paint = Paint()..color = Colors.white.withOpacity(glint1Opacity);
    final Path glint1Path = Path()
      ..moveTo(50, 10)
      ..lineTo(55, 35)
      ..lineTo(45, 35)
      ..close();
    canvas.drawPath(glint1Path, glint1Paint);

    // Glint 2 (Polygon)
    final Paint glint2Paint = Paint()..color = Colors.white.withOpacity(glint2Opacity);
    final Path glint2Path = Path()
      ..moveTo(25, 40)
      ..lineTo(30, 38)
      ..lineTo(28, 45)
      ..close();
    canvas.drawPath(glint2Path, glint2Paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant RubyPainter oldDelegate) {
    return oldDelegate.glint1Opacity != glint1Opacity ||
        oldDelegate.glint2Opacity != glint2Opacity;
  }
}