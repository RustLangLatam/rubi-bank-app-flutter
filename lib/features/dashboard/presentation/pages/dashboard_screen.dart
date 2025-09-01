import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rubi_bank_app/features/accounts/presentation/widgets/balance_card.dart';
import 'package:rubi_bank_app/features/dashboard/presentation/widgets/action_buttons_group_widget.dart';
import 'package:rubi_bank_app/features/dashboard/presentation/widgets/promotional_carousel.dart';
import 'package:rubi_bank_app/features/dashboard/presentation/widgets/recent_activity_widget.dart';
import 'package:rubi_bank_api_sdk/rubi_bank_api_sdk.dart' as sdk;

import '../../../../core/common/widgets/elegant_rubi_loader.dart';
import '../../../accounts/presentation/providers/accounts_provider.dart';
import '../widgets/types.dart';

final List<Promotion> promotions = [
  Promotion(
    id: 1,
    icon: PromotionIcon.card,
    title: 'Premium Card',
    description: 'Get our exclusive premium credit card with amazing benefits',
    bgColor: '#1E40AF',
    textColor: '#FFFFFF',
  ),
  Promotion(
    id: 2,
    icon: PromotionIcon.loan,
    title: 'Low Interest Loan',
    description: 'Special loan offers with reduced interest rates',
    bgColor: '#059669',
    textColor: '#FFFFFF',
  ),
];

class DashboardScreen extends ConsumerStatefulWidget {
  final sdk.Customer customer;
  const DashboardScreen({super.key, required this.customer});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

enum TransitionType { fade, scale, slide, combined }

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  // Add this enum for different transition types

  final TransitionType _transitionType = TransitionType.combined;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _fetchAccounts());
  }

  Future<void> _fetchAccounts() async {
    try {
      await ref
          .read(accountsProvider.notifier)
          .fetchCustomerAccounts(widget.customer.identifier!);
    } catch (e) {
      debugPrint('Error fetching accounts: $e');
    }
  }

  Widget _buildTransition(Widget child, Animation<double> animation) {
    switch (_transitionType) {
      case TransitionType.fade:
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          child: child,
        );
      case TransitionType.scale:
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          child: child,
        );
      case TransitionType.slide:
        return SlideTransition(
          position:
              Tween<Offset>(
                begin: const Offset(0.0, 0.3),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut),
              ),
          child: child,
        );
      case TransitionType.combined:
        return SlideTransition(
          position:
              Tween<Offset>(
                begin: const Offset(0.0, 0.1),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut),
              ),
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
            child: child,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final accountsState = ref.watch(accountsProvider);

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: theme.colorScheme.primary,
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 800),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          transitionBuilder: _buildTransition,
          child: accountsState.when(
            loading: () => KeyedSubtree(
              key: const ValueKey('loading'),
              child: _buildLoadingScreen(theme),
            ),
            error: (error, stackTrace) => KeyedSubtree(
              key: const ValueKey('error'),
              child: _buildErrorScreen(error, theme),
            ),
            data: (accounts) => KeyedSubtree(
              key: const ValueKey('data'),
              child: _buildDashboardScreen(accounts, theme),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingScreen(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const ElegantRubiLoader(),
          const SizedBox(height: 24),
          AnimatedOpacity(
            opacity: 1.0,
            duration: const Duration(milliseconds: 1000),
            child: Text(
              'RUBIBANK',
              style: TextStyle(
                fontFamily: 'Lato',
                color: theme.colorScheme.secondary,
                fontSize: 36,
                fontWeight: FontWeight.bold,
                letterSpacing: 3.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorScreen(dynamic error, ThemeData theme) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error loading accounts',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onPrimary.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchAccounts,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.secondary,
                foregroundColor: theme.colorScheme.onSecondary,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardScreen(List<sdk.Account> accounts, ThemeData theme) {
    final primaryAccount = accounts.isNotEmpty ? accounts.first : null;
    final recentActivity = primaryAccount != null
        ? _getRecentTransactions(primaryAccount)
        : <sdk.Transaction>[];

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BalanceCard(),
                const SizedBox(height: 20),
                const ActionButtonsGroupWidget(),
                const SizedBox(height: 20),
                PromotionalCarousel(promotions: promotions),
                const SizedBox(height: 20),
                Text(
                  'Recent Activity',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: RecentActivityWidget(transactions: recentActivity),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<sdk.Transaction> _getRecentTransactions(sdk.Account account) {
    return [];
  }
}
