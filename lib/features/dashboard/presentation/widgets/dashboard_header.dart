import 'package:flutter/material.dart';

class DashboardHeader extends StatefulWidget {
  final String userName;
  final String? avatarUrl;
  final VoidCallback? onLogout;
  final VoidCallback? onSettings;

  const DashboardHeader({
    super.key,
    required this.userName,
    this.avatarUrl,
    this.onLogout,
    this.onSettings,
  });

  @override
  State<DashboardHeader> createState() => _DashboardHeaderState();
}

class _DashboardHeaderState extends State<DashboardHeader> {
  final GlobalKey _menuKey = GlobalKey();
  bool _isMenuOpen = false;
  OverlayEntry? _overlayEntry;

  String _capitalizeEachWord(String text) {
    if (text.isEmpty) return text;
    return text
        .trim()
        .split(RegExp(r'\s+'))
        .map((word) {
      if (word.isEmpty) return word;
      if (word.contains("'") || word.contains("-")) {
        return word.split(RegExp(r"['-]")).map((part) {
          if (part.isEmpty) return part;
          return part[0].toUpperCase() + part.substring(1).toLowerCase();
        }).join(word.contains("'") ? "'" : "-");
      }
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    })
        .join(' ');
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });

    if (_isMenuOpen) {
      _showMenu();
    } else {
      _hideMenu();
    }
  }

  void _showMenu() {
    final RenderBox renderBox = _menuKey.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: offset.dy + renderBox.size.height + 8,
        right: MediaQuery.of(context).size.width - offset.dx - renderBox.size.width,
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 150,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _MenuItem(
                  icon: Icons.settings,
                  text: 'Settings',
                  onTap: () {
                    _hideMenu();
                    widget.onSettings?.call();
                  },
                ),
                _MenuItem(
                  icon: Icons.logout,
                  text: 'Log Out',
                  onTap: () {
                    _hideMenu();
                    widget.onLogout?.call();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;

    if (mounted) {
      setState(() => _isMenuOpen = false);
    }
  }

  @override
  void dispose() {
    _hideMenu();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    final capitalizedUserName = _capitalizeEachWord(widget.userName);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome Back,',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.shadow,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                capitalizedUserName,
                style: textTheme.displayMedium?.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          GestureDetector(
            key: _menuKey,
            onTap: _toggleMenu,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: colorScheme.primary,
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: widget.avatarUrl != null
                    ? Image.network(
                  widget.avatarUrl!,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: colorScheme.surface,
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return _buildDefaultAvatar(colorScheme);
                  },
                )
                    : _buildDefaultAvatar(colorScheme),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar(ColorScheme colorScheme) {
    return Container(
      color: colorScheme.surface,
      child: Icon(
        Icons.person,
        color: colorScheme.shadow,
        size: 24,
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: colorScheme.onSurface,
              ),
              const SizedBox(width: 12),
              Text(
                text,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}