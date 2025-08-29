import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rubi_bank_api_sdk/rubi_bank_api_sdk.dart';

import '../../../../../core/common/widgets/elegant_rubi_loader.dart';
import '../../../../../data/providers/api_provider.dart';
import '../../providers/create_customer_provider.dart';
import '../../providers/register_provider.dart';

class CreateCustomerScreen extends ConsumerStatefulWidget {
  final VoidCallback onSuccess;
  final String userName;

  const CreateCustomerScreen({
    super.key,
    required this.onSuccess,
    required this.userName,
  });

  @override
  ConsumerState<CreateCustomerScreen> createState() =>
      _CreateCustomerScreenState();
}

class _CreateCustomerScreenState extends ConsumerState<CreateCustomerScreen> {
  final List<StepItem> _steps = [
    StepItem('Creating your secure profile...', StepStatus.pending),
    StepItem('Setting up your savings account...', StepStatus.pending),
    StepItem('Finalizing setup...', StepStatus.pending),
  ];

  int _currentStepIndex = 0;
  bool _allDone = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startCreationProcess();
    });
  }

  Future<void> _startCreationProcess() async {
    try {
      // 1. Get customer data from register provider
      final registerState = ref.read(registerProvider);
      final customer = registerState.customer;
      final password = registerState.password;

      // Process each step sequentially
      for (int i = 0; i < _steps.length; i++) {
        if (mounted) {
          setState(() {
            _currentStepIndex = i;
            _steps[i] = _steps[i].copyWith(status: StepStatus.inProgress);
          });
        }

        await Future.delayed(const Duration(seconds: 2));

        if (i == 0) {
          // Step 1: Create customer
          await ref
              .read(createCustomerProvider.notifier)
              .createCustomer(customer: customer, password: password);
        } else if (i == 1) {
          // Step 2: Create savings account
          final createCustomerState = ref.read(createCustomerProvider);
          final createdCustomer = createCustomerState.value;
          if (createdCustomer != null) {
            await _createSavingsAccount(createdCustomer.name!);
          }
        }
        // Step 3 is just a finalization step with no API call

        if (mounted) {
          setState(() {
            _steps[i] = _steps[i].copyWith(status: StepStatus.completed);
          });
        }
      }

      // All steps completed
      if (mounted) {
        setState(() {
          _allDone = true;
        });

        await Future.delayed(const Duration(seconds: 1));
        widget.onSuccess();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _steps[_currentStepIndex] = _steps[_currentStepIndex].copyWith(
            status: StepStatus.pending,
          );
        });
      }
      // Handle error (you might want to show an error message)
      print('Error: $e');
    }
  }

  Future<void> _createSavingsAccount(String customerId) async {
    try {
      final accountsApi = ref.read(accountsApiProvider);

      final newAccount = Account(
            (a) => a
          ..displayName = "Primary Savings"
          ..accountDetails = AccountDetails(
                (ad) => ad
              ..type = AccountDetailsTypeEnum.ACCOUNT_TYPE_SAVINGS
              ..productCode = "SAVINGS_PREMIUM",
          ).toBuilder(),
      );

      final response = await accountsApi.createAccount(
        customer: customerId,
        account: newAccount,
      );

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception('Failed to create savings account');
      }
    } catch (e) {
      throw Exception('Account creation failed: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Elegant Rubi Loader (you'll need to create this widget)
              _buildElegantRubiLoader(),
              const SizedBox(height: 32),

              // Welcome title
              Text(
                'Welcome, ${widget.userName.split(' ').first}!',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Description
              Text(
                _allDone
                    ? "You're all set! Redirecting to your dashboard..."
                    : "We're just getting your account ready. This will only take a moment.",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFFA9B4C4),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
              const SizedBox(height: 48),

              // Steps list
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _steps.map((step) => _buildStepItem(step)).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildElegantRubiLoader() {
    return ElegantRubiLoader();
  }

  Widget _buildStepItem(StepItem step) {
    final theme = Theme.of(context);
    final isCompleted = step.status == StepStatus.completed;
    final isInProgress = step.status == StepStatus.inProgress;

    Color textColor;
    if (isCompleted) {
      textColor = theme.colorScheme.onPrimary;
    } else if (isInProgress) {
      textColor = theme.colorScheme.secondary;
    } else {
      textColor = const Color(0xFFA9B4C4);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          _buildStatusIcon(step.status),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              step.label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIcon(StepStatus status) {
    switch (status) {
      case StepStatus.completed:
        return Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 20,
        );
      case StepStatus.inProgress:
        return SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.secondary,
            ),
          ),
        );
      case StepStatus.pending:
      default:
        return Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFFA9B4C4),
              width: 2,
            ),
          ),
        );
    }
  }
}

enum StepStatus { pending, inProgress, completed }

class StepItem {
  final String label;
  final StepStatus status;

  StepItem(this.label, this.status);

  StepItem copyWith({
    String? label,
    StepStatus? status,
  }) {
    return StepItem(
      label ?? this.label,
      status ?? this.status,
    );
  }
}