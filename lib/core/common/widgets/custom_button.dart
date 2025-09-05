import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

enum ButtonType { primary, secondary, muted }
enum TextTransform { none, uppercase }

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonType type;
  final bool isFullWidth;
  final double verticalPadding;
  final Color? customColor;
  final Color? customTextColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool isLoading;
  final Widget? trailingIcon;
  final TextTransform textTransform;
  final double? letterSpacing;
  final MainAxisAlignment mainAxisAlignment;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.isFullWidth = true,
    this.verticalPadding = 14,
    this.customColor,
    this.customTextColor,
    this.fontSize,
    this.fontWeight,
    this.isLoading = false,
    this.trailingIcon,
    this.textTransform = TextTransform.none,
    this.letterSpacing,
    this.mainAxisAlignment = MainAxisAlignment.center,
  });

  factory CustomButton.primary({
    Key? key,
    required String text,
    required VoidCallback onPressed,
    bool isLoading = false,
    Icon? trailingIcon,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.center
  }) {
    return CustomButton(
      key: key,
      text: text,
      onPressed: onPressed,
      type: ButtonType.primary,
      isFullWidth: true,
      verticalPadding: 16,
      fontSize: 16,
      fontWeight: FontWeight.bold,
      isLoading: isLoading,
      trailingIcon: trailingIcon,
      mainAxisAlignment:  mainAxisAlignment,
    );
  }

  factory CustomButton.muted({
    Key? key,
    required String text,
    required VoidCallback onPressed,
    bool isLoading = false,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.center,
    textTransform = TextTransform.none,
    fontWeight = FontWeight.w600,
  }) {
    return CustomButton(
      key: key,
      text: text,
      onPressed: onPressed,
      type: ButtonType.muted,
      isFullWidth: true,
      verticalPadding: 12,
      fontSize: 14,
      fontWeight: fontWeight,
      textTransform: textTransform,
      letterSpacing: 1.0,
      isLoading: isLoading,
      mainAxisAlignment: mainAxisAlignment,
    );
  }

  factory CustomButton.secondary({
    Key? key,
    required String text,
    required VoidCallback onPressed,
    bool isLoading = false,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.center
  }) {
    return CustomButton(
      key: key,
      text: text,
      onPressed: onPressed,
      type: ButtonType.secondary,
      isFullWidth: true,
      verticalPadding: 14,
      fontSize: 16,
      fontWeight: FontWeight.bold,
      isLoading: isLoading,
      mainAxisAlignment: mainAxisAlignment,
    );
  }

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _scaleController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _scaleController.reverse();
  }

  void _onTapCancel() {
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final Color backgroundColor = widget.customColor ??
        (widget.type == ButtonType.primary
            ? colorScheme.primary
            : Colors.transparent);

    final Color foregroundColor = widget.customTextColor ??
        (widget.type == ButtonType.primary
            ? colorScheme.onPrimary
            : widget.type == ButtonType.secondary
            ? colorScheme.secondary
            : colorScheme.shadow);

    final Widget buttonContent = widget.isLoading
        ? SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
        strokeWidth: 2,
      ),
    )
        : Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: widget.mainAxisAlignment!,
      children: [
        Text(
          widget.textTransform == TextTransform.uppercase
              ? widget.text.toUpperCase()
              : widget.text,
          style: GoogleFonts.inter(
            color: foregroundColor,
            fontSize: widget.fontSize ?? 16,
            fontWeight: widget.fontWeight ?? FontWeight.bold,
            letterSpacing: widget.letterSpacing,
          ),
        ),
        if (widget.trailingIcon != null) widget.trailingIcon!,
      ],
    );

    final ButtonStyle buttonStyle = TextButton.styleFrom(
      backgroundColor: widget.type == ButtonType.primary ? backgroundColor : Colors.transparent,
      foregroundColor: foregroundColor,
      padding: EdgeInsets.symmetric(
        vertical: widget.verticalPadding,
        horizontal: 24,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: widget.type == ButtonType.secondary
            ? BorderSide(
          color: widget.customColor ?? colorScheme.secondary,
          width: 1.5,
        )
            : BorderSide.none,
      ),
      overlayColor: colorScheme.shadow.withOpacity(0.25),
      splashFactory: NoSplash.splashFactory,
    );

    final Widget button = TextButton(
      style: buttonStyle,
      onPressed: widget.isLoading ? null : widget.onPressed,
      child: buttonContent,
    );

    final Widget decoratedButton = widget.type == ButtonType.primary
        ? Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            colorScheme.primary,
            colorScheme.secondary,
          ],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: button,
    )
        : button;

    return MouseRegion(
      cursor: widget.isLoading ? SystemMouseCursors.wait : SystemMouseCursors.click,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: GestureDetector(
                onTapDown: widget.isLoading ? null : _onTapDown,
                onTapUp: widget.isLoading ? null : _onTapUp,
                onTapCancel: widget.isLoading ? null : _onTapCancel,
                onTap: widget.isLoading ? null : widget.onPressed,
                child: widget.isFullWidth
                    ? SizedBox(
                  width: double.infinity,
                  child: decoratedButton,
                )
                    : decoratedButton,
              ),
            );
          },
        ),
      ),
    );
  }
}