import 'package:flutter/material.dart';
import '../../../../core/common/theme/app_theme.dart';
import '../../../../core/common/widgets/custom_button.dart';

class UnderDevelopmentScreen extends StatefulWidget {
  const UnderDevelopmentScreen({
    super.key
  });

  @override
  State<UnderDevelopmentScreen> createState() => _UnderDevelopmentScreenState();
}

class _UnderDevelopmentScreenState extends State<UnderDevelopmentScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _opacityAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
        body: Container(
          decoration: BoxDecoration(gradient: AppTheme.appGradient(colorScheme)),
          child:SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _opacityAnimation.value,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFFCD34D).withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.construction_outlined,
                        size: 60,
                        color: Color(0xFFFCD34D),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 48),

              Text(
                'COMING SOON',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2.0,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),
              Container(
                width: 60,
                height: 1,
                color: const Color(0xFFFCD34D).withOpacity(0.5),
              ),

              const SizedBox(height: 32),
              Text(
                "We are crafting an exceptional experience for this feature.\n\n"
                    "This section will be available in an upcoming update.",
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),

              const Expanded(child: SizedBox()),

              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: "GO BACK",
                  onPressed: () => Navigator.pop(context),
                  type: ButtonType.primary,
                ),
              ),
            ],
          ),
        ),
      ),
        ),
    );
  }
}