import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rubi_bank_app/features/accounts/presentation/widgets/balance_card.dart';
import 'package:rubi_bank_app/features/dashboard/presentation/widgets/action_buttons_group_widget.dart';
import 'package:rubi_bank_app/features/dashboard/presentation/widgets/promotional_carousel.dart';
import 'package:rubi_bank_app/features/dashboard/presentation/widgets/recent_activity_widget.dart';
import 'package:rubi_bank_api_sdk/rubi_bank_api_sdk.dart' as sdk;

import '../widgets/types.dart';

// Sample data (replace with your actual data)
final List<sdk.Transaction> recentActivity = [
  // Transaction(
  //   id: 1,
  //   title: 'Salary Deposit',
  //   date: DateTime.now().subtract(const Duration(days: 1)).toString(),
  //   amount: 2500.00,
  // ),
  // Transaction(
  //   id: 2,
  //   title: 'Grocery Store',
  //   date: DateTime.now().subtract(const Duration(days: 3)).toString(),
  //   amount: -85.50,
  // ),
  // Transaction(
  //   id: 3,
  //   title: 'Transfer from John',
  //   date: DateTime.now().subtract(const Duration(days: 5)).toString(),
  //   amount: 150.00,
  // ),
];

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
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: theme.colorScheme.primary,
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BalanceCardWidget(),
                    const SizedBox(height: 20),
                    const ActionButtonsGroupWidget(),
                    const SizedBox(height: 20),
                    PromotionalCarousel(promotions: promotions),
                    const SizedBox(height: 20),
                    // Recent Activity Section
                    Text(
                      'Recent Activity',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
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
        ),
      ),
    );
  }
}
