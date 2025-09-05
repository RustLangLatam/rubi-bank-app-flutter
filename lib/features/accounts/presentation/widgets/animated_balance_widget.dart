import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rubi_bank_app/core/utils/decimal_precision.dart';
import '../../../../core/common/theme/app_theme.dart';

class CashRegisterBalanceText extends StatefulWidget {
  final Decimal balance;
  final bool isVisible;
  final bool isLoading;
  final TextStyle style;
  final Duration digitAnimationDuration;
  final Duration delayBetweenDigits;

  const CashRegisterBalanceText({
    super.key,
    required this.balance,
    required this.isVisible,
    this.isLoading = false,
    this.style = const TextStyle(),
    this.digitAnimationDuration = const Duration(milliseconds: 200),
    this.delayBetweenDigits = const Duration(milliseconds: 100),
  });

  @override
  State<CashRegisterBalanceText> createState() => _CashRegisterBalanceTextState();
}

class _CashRegisterBalanceTextState extends State<CashRegisterBalanceText> {
  late String _currentText;
  late String _previousText;
  bool _isAnimating = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeText();
  }

  void _initializeText() {
    if (widget.balance.toString().isEmpty) {
      _error = 'Invalid balance';
      _currentText = '••••••••';
      _previousText = _currentText;
      return;
    }
    _currentText = widget.isVisible ? widget.balance.toCurrencyString() : _generateHiddenString(widget.balance.toCurrencyString());
    _previousText = _currentText;
  }

  @override
  void didUpdateWidget(CashRegisterBalanceText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading || widget.balance.toString().isEmpty) {
      setState(() {
        _error = widget.balance.toString().isEmpty ? 'Invalid balance' : null;
        _currentText = _generateHiddenString(oldWidget.balance.toCurrencyString());
        _previousText = _currentText;
        _isAnimating = false;
      });
      return;
    }
    final newText = widget.isVisible ? widget.balance.toCurrencyString() : _generateHiddenString(widget.balance.toCurrencyString());
    if (newText != _currentText && !_isAnimating) {
      setState(() {
        _previousText = _currentText;
        _currentText = newText;
        _isAnimating = true;
      });
      _startAnimation();
    }
  }

  String _generateHiddenString(String balance) {
    final digitCount = balance.replaceAll(RegExp(r'[^0-9]'), '').length;
    return '•' * digitCount;
  }

  void _startAnimation() {
    final maxLength = _currentText.length > _previousText.length ? _currentText.length : _previousText.length;
    final steps = _calculateSteps();
    final totalDuration = widget.digitAnimationDuration * steps + widget.delayBetweenDigits * (maxLength - 1);

    Future.delayed(totalDuration, () {
      if (mounted) {
        setState(() {
          _isAnimating = false;
        });
      }
    });
  }

  int _calculateSteps() {
    final currentDigits = _currentText.split('');
    final previousDigits = _previousText.padRight(_currentText.length, ' ').split('');
    int maxSteps = 0;

    for (int i = 0; i < currentDigits.length; i++) {
      if (currentDigits[i] != previousDigits[i]) {
        final steps = _getDigitSteps(currentDigits[i], previousDigits[i]);
        if (steps > maxSteps) maxSteps = steps;
      }
    }
    return maxSteps;
  }

  int _getDigitSteps(String current, String previous) {
    const wheel = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '•'];
    if (current == previous || previous == ' ') return 0;
    final currentIndex = wheel.indexOf(current);
    final previousIndex = wheel.indexOf(previous);
    if (currentIndex == -1 || previousIndex == -1) return 1;
    final forwardSteps = (currentIndex - previousIndex + wheel.length) % wheel.length;
    final backwardSteps = (previousIndex - currentIndex + wheel.length) % wheel.length;
    return forwardSteps <= backwardSteps ? forwardSteps : backwardSteps;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    if (_error != null) {
      return Text(
        _error!,
        style: widget.style.copyWith(color: theme.colorScheme.error),
      );
    }

    if (widget.isLoading || !_isAnimating) {
      return Text(
        _currentText,
        style: widget.style,
      );
    }

    return _CashRegisterAnimation(
      currentText: _currentText,
      previousText: _previousText,
      style: widget.style,
      digitDuration: widget.digitAnimationDuration,
      digitDelay: widget.delayBetweenDigits,
    );
  }
}

class _CashRegisterAnimation extends StatelessWidget {
  final String currentText;
  final String previousText;
  final TextStyle style;
  final Duration digitDuration;
  final Duration digitDelay;

  const _CashRegisterAnimation({
    required this.currentText,
    required this.previousText,
    required this.style,
    required this.digitDuration,
    required this.digitDelay,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      textDirection: TextDirection.ltr,
      children: _buildAnimatedDigits(),
    );
  }

  List<Widget> _buildAnimatedDigits() {
    final widgets = <Widget>[];
    final currentDigits = currentText.split('');
    final previousDigits = previousText.padRight(currentText.length, ' ').split('');

    for (int i = currentText.length - 1; i >= 0; i--) {
      final currentDigit = currentDigits[i];
      final previousDigit = previousDigits[i];
      final positionFromRight = currentText.length - 1 - i;

      if (currentDigit == previousDigit && currentDigit != ' ') {
        widgets.insert(0, _buildStaticDigit(currentDigit));
      } else {
        widgets.insert(0, _AnimatedCashRegisterDigit(
          currentDigit: currentDigit,
          previousDigit: previousDigit,
          style: style,
          duration: digitDuration,
          delay: digitDelay * positionFromRight,
        ));
      }
    }

    return widgets;
  }

  Widget _buildStaticDigit(String digit) {
    return Text(
      digit,
      style: style,
    );
  }
}

class _AnimatedCashRegisterDigit extends StatefulWidget {
  final String currentDigit;
  final String previousDigit;
  final TextStyle style;
  final Duration duration;
  final Duration delay;

  const _AnimatedCashRegisterDigit({
    required this.currentDigit,
    required this.previousDigit,
    required this.style,
    required this.duration,
    required this.delay,
  });

  @override
  State<_AnimatedCashRegisterDigit> createState() => _AnimatedCashRegisterDigitState();
}

class _AnimatedCashRegisterDigitState extends State<_AnimatedCashRegisterDigit> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late List<String> _wheelSequence;
  late double _digitHeight;

  @override
  void initState() {
    super.initState();
    _digitHeight = _getDigitHeight(widget.style);
    _wheelSequence = _buildWheelSequence(widget.currentDigit, widget.previousDigit);

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration * _wheelSequence.length,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  List<String> _buildWheelSequence(String current, String previous) {
    const wheel = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '•'];
    if (current == previous || previous == ' ') return [current];

    final currentIndex = wheel.indexOf(current);
    final previousIndex = wheel.indexOf(previous);
    if (currentIndex == -1 || previousIndex == -1) return [current];

    final forwardSteps = (currentIndex - previousIndex + wheel.length) % wheel.length;
    final backwardSteps = (previousIndex - currentIndex + wheel.length) % wheel.length;
    final isForward = forwardSteps <= backwardSteps;

    final sequence = <String>[];
    if (isForward) {
      for (int i = 0; i <= forwardSteps; i++) {
        sequence.add(wheel[(previousIndex + i) % wheel.length]);
      }
    } else {
      for (int i = 0; i <= backwardSteps; i++) {
        sequence.add(wheel[(previousIndex - i + wheel.length) % wheel.length]);
      }
    }
    return sequence;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _getDigitWidth(widget.currentDigit, widget.style),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final progress = _animation.value;
          final steps = _wheelSequence.length - 1;
          final stepProgress = (progress * steps).clamp(0.0, steps.toDouble());
          final currentStep = stepProgress.floor();
          final nextStep = (currentStep + 1).clamp(0, steps);
          final interpolation = stepProgress - currentStep;

          return Stack(
            alignment: Alignment.center,
            children: [
              // Current digit in sequence
              Transform.translate(
                offset: Offset(0, interpolation * _digitHeight),
                child: Opacity(
                  opacity: 1.0 - interpolation,
                  child: Text(
                    _wheelSequence[currentStep],
                    style: widget.style.copyWith(
                      color: widget.style.color?.withOpacity(1.0 - interpolation),
                    ),
                  ),
                ),
              ),
              // Next digit in sequence
              if (currentStep < steps)
                Transform.translate(
                  offset: Offset(0, (interpolation - 1) * _digitHeight),
                  child: Opacity(
                    opacity: interpolation,
                    child: Text(
                      _wheelSequence[nextStep],
                      style: widget.style,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  double _getDigitWidth(String digit, TextStyle style) {
    final textPainter = TextPainter(
      text: TextSpan(text: digit, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    return textPainter.width;
  }

  double _getDigitHeight(TextStyle style) {
    final textPainter = TextPainter(
      text: TextSpan(text: '0', style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    return textPainter.height;
  }
}