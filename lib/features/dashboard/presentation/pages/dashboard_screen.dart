import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rubi_bank_app/features/accounts/presentation/widgets/balance_card.dart';
import 'package:rubi_bank_app/features/authentication/presentation/providers/customer_provider.dart';
import 'package:rubi_bank_app/features/dashboard/presentation/widgets/recent_activity_widget.dart';
import 'package:rubi_bank_api_sdk/rubi_bank_api_sdk.dart' as sdk;

import '../../../../core/common/theme/app_theme.dart';
import '../../../../core/common/widgets/confirmation_modal.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/common/widgets/elegant_rubi_loader.dart';
import '../../../../core/transitions/custom_page_route.dart';
import '../../../accounts/presentation/providers/accounts_provider.dart';
import '../../../transactions/presentation/pages/send_money_screen.dart';
import '../../../transactions/presentation/providers/transactions_provider.dart';
import '../widgets/action_buttons_group_widget.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/view_all_button.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  final sdk.Customer customer;
  const DashboardScreen({super.key, required this.customer});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  bool _transactionsLoaded = false;

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

  Future<void> _fetchTransactions(sdk.Account account) async {
    if (_transactionsLoaded) return;

    final accountsIdentifier = account.name!.split("/").last;

    try {
      await ref
          .read(transactionsProvider.notifier)
          .fetchAccountTransactions(
            accountsIdentifier,
            customerId: widget.customer.identifier!,
          );
      setState(() {
        _transactionsLoaded = true;
      });
      ref
          .read(transactionsProvider.notifier)
          .startPollingTransactions(accountsIdentifier);
    } catch (e) {
      debugPrint('Error fetching transactions: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _handleLogout() {
    _showLogoutConfirmation(context);
  }

  void _showLogoutConfirmation(BuildContext context) {
    ConfirmationModal.show(
      context: context,
      onConfirm: () {
        ref.read(transactionsProvider.notifier).stopPolling();
        Navigator.pushReplacementNamed(context, '/welcome-back');
      },
      title: 'Confirm Logout',
      message: 'Are you sure you want to logout?',
      confirmText: 'Logout',
      cancelText: 'Cancel',
      iconType: IconType.logout,
      confirmButtonVariant: ConfirmButtonVariant.primary,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final accountsState = ref.watch(accountsProvider);
    final transactionsState = ref.watch(transactionsProvider);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.appGradient(colorScheme)),
        child: SafeArea(
          child: accountsState.when(
            loading: () => _buildLoadingScreen(theme),
            error: (error, stackTrace) => _buildErrorScreen(error, theme),
            data: (accounts) =>
                _buildDashboardScreen(accounts, transactionsState, theme),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingScreen(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const ElegantRubiLoader(),
          const SizedBox(height: 24),
          Text(
            'Loading...',
            style: GoogleFonts.playfairDisplay(
              color: theme.colorScheme.primary, // #C5A365
              fontSize: 36,
              fontWeight: FontWeight.bold,
              letterSpacing: 3.0, // Matches tracking-widest
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
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.shadow,
              ),
            ),
            const SizedBox(height: 16),
            CustomButton.muted(text: 'Retry', onPressed: _fetchAccounts),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardScreen(
    List<sdk.Account> accounts,
    AsyncValue<List<sdk.Transaction>> transactionsState,
    ThemeData theme,
  ) {
    final primaryAccount = accounts.isNotEmpty ? accounts.first : null;

    if (primaryAccount != null && !_transactionsLoaded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fetchTransactions(primaryAccount);
      });
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: 24.0),
      children: [
        DashboardHeader(
          userName: widget.customer.displayName ?? widget.customer.givenName,
          onLogout: _handleLogout,
          onSettings: () {
            // Handle settings logic
            print('Settings clicked');
          },
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (primaryAccount != null) BalanceCard(account: primaryAccount),
              const SizedBox(height: 24),
              ActionButtonsGroup(onSend: () {
                Navigator.push(
                  context,
                    CustomPageRoute.cupertinoModal(SendMoneyScreen()),
                );
              }),
              const SizedBox(height: 24),

              // Recent Activity section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Activity',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                  ViewAllButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/transactions');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              transactionsState.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(strokeWidth: 1.5),
                  // height: 200,
                ),
                error: (error, stackTrace) => Container(
                  height: 200,
                  alignment: Alignment.center,
                  child: Text(
                    'Error loading transactions',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.shadow,
                    ),
                  ),
                ),
                data: (transactions) {
                  final recentTransactions = transactions.take(3).toList();
                  return RecentActivityEnhanced(
                      transactions: recentTransactions,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
