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

  late AnimationController _glint3Controller;
  late Animation<double> _glint3Animation;

  late AnimationController _glint4Controller;
  late Animation<double> _glint4Animation;


  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOutSine,
      ),
    );

    _glint1Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();
    _glint1Animation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 0.9), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 0.9, end: 0.0), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 0.0), weight: 3), // Hold invisible
    ]).animate(_glint1Controller);

    _glint2Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(period: const Duration(milliseconds: 500));
    _glint2Animation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 0.7), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 0.7, end: 0.0), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 0.0), weight: 4), // Hold invisible
    ]).animate(_glint2Controller);

    _glint3Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(period: const Duration(milliseconds: 1200));
    _glint3Animation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 0.6), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 0.6, end: 0.0), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 0.0), weight: 5),
    ]).animate(_glint3Controller);

    _glint4Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat(period: const Duration(milliseconds: 2000));
    _glint4Animation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 0.5), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 0.5, end: 0.0), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 0.0), weight: 6),
    ]).animate(_glint4Controller);

  }

  @override
  void dispose() {
    _pulseController.dispose();
    _glint1Controller.dispose();
    _glint2Controller.dispose();
    _glint3Controller.dispose();
    _glint4Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 96, // Equivalent to w-24 (24 * 4)
        height: 96, // Equivalent to h-24 (24 * 4)
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _pulseAnimation,
            _glint1Animation,
            _glint2Animation,
            _glint3Animation,
            _glint4Animation,
          ]),
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Opacity(
                opacity: _pulseAnimation.value,
                child: CustomPaint(
                  painter: RubyPainter(
                    glint1Opacity: _glint1Animation.value,
                    glint2Opacity: _glint2Animation.value,
                    glint3Opacity: _glint3Animation.value,
                    glint4Opacity: _glint4Animation.value,
                  ),
                  size: const Size(100, 100),
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
  final double glint3Opacity;
  final double glint4Opacity;

  RubyPainter({
    required this.glint1Opacity,
    required this.glint2Opacity,
    required this.glint3Opacity,
    required this.glint4Opacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / 100;
    final double scaleY = size.height / 100;

    canvas.save();
    canvas.scale(scaleX, scaleY);

    // Apply drop shadow for the entire ruby
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
        ..color = Colors.red
        ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 10.0), // Equivalent to drop-shadow
    );

    // Ruby Core Glow
    final Paint rubyCorePaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment.center,
        radius: 0.5,
        colors: [
          Color(0xFFF44336), // F44336
          Color(0xFFB71C1C), // B71C1C
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(rubyPath, rubyCorePaint);

    // Darker facets
    final Paint darkFacet1Paint = Paint()..color = const Color(0x66880E4F); // 880E4F with opacity 0.4
    final Path darkFacet1 = Path()
      ..moveTo(5, 35)
      ..lineTo(22, 95)
      ..lineTo(50, 45)
      ..close();
    canvas.drawPath(darkFacet1, darkFacet1Paint);

    final Paint darkFacet2Paint = Paint()..color = const Color(0x66C62828); // C62828 with opacity 0.4
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
          Color(0x80EF9A9A), // EF9A9A with opacity 0.5
          Color(0x1AE57373), // E57373 with opacity 0.1
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    final Path facetShine1 = Path()
      ..moveTo(50, 2)
      ..lineTo(95, 35)
      ..lineTo(50, 45)
      ..close();
    canvas.drawPath(facetShine1, facetShinePaint1);

    final Paint facetShinePaint2 = Paint()..color = const Color(0x4DEF9A9A); // EF9A9A with opacity 0.3
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

    final Paint glint3Paint = Paint()..color = Colors.white.withOpacity(glint3Opacity);
    final Path glint3Path = Path()
      ..moveTo(28, 90)
      ..lineTo(32, 88)
      ..lineTo(30, 93)
      ..close();
    canvas.drawPath(glint3Path, glint3Paint);

    final Paint glint4Paint = Paint()..color = Colors.white.withOpacity(glint4Opacity);
    final Path glint4Path = Path()
      ..moveTo(72, 90)
      ..lineTo(68, 88)
      ..lineTo(70, 93)
      ..close();
    canvas.drawPath(glint4Path, glint4Paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant RubyPainter oldDelegate) {
    return oldDelegate.glint1Opacity != glint1Opacity ||
        oldDelegate.glint2Opacity != glint2Opacity ||
        oldDelegate.glint3Opacity != glint3Opacity ||
        oldDelegate.glint4Opacity != glint4Opacity;
  }
}