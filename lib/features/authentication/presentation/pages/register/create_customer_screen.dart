import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rubi_bank_api_sdk/rubi_bank_api_sdk.dart';
import '../../../../../core/common/theme/app_theme.dart';
import '../../../../../core/common/widgets/elegant_rubi_loader.dart';
import '../../../../accounts/presentation/providers/accounts_provider.dart';
import '../../providers/customer_provider.dart';
import '../../providers/register_provider.dart';
import '../../../../../core/common/widgets/custom_button.dart';

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
  bool _hasError = false;
  String? _errorMessage;

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

        if (i == 0) {
          // Step 1: Create customer
          await ref
              .read(customerProvider.notifier)
              .createCustomer(customer: customer, password: password);

          final customerState = ref.read(customerProvider);

          if (customerState.hasError) {
            throw customerState.error!;
          }

          if (customerState.value == null) {
            throw Exception('Customer creation failed: No customer data returned');
          }

          final email = customerState.value!.email;

          await ref
              .read(customerProvider.notifier)
              .loginCustomer(email, password);
        } else if (i == 1) {
          // Step 2: Create savings account
          final createCustomerState = ref.read(customerProvider);

          if (createCustomerState.hasError) {
            throw createCustomerState.error!;
          }

          final createdCustomer = createCustomerState.value;

          if (createdCustomer != null && createdCustomer.identifier != null) {
            await _createSavingsAccount(createdCustomer.identifier!);
          }
        }

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

        await Future.delayed(const Duration(milliseconds: 1500));
        widget.onSuccess();
      }
    } catch (e) {
      if (mounted) {
        final errorMsg = _getErrorMessage(e);
        setState(() {
          _hasError = false;
          _errorMessage = errorMsg;
          _steps[_currentStepIndex] = _steps[_currentStepIndex].copyWith(
            status: StepStatus.error,
            errorMessage: errorMsg,
          );
        });
      }
      debugPrint('Error: $e');
    }
  }

  void _retryProcess() {
    if (mounted) {
      setState(() {
        _hasError = false;
        _errorMessage = null;
        _currentStepIndex = 0;
        _allDone = false;
        for (int i = 0; i < _steps.length; i++) {
          _steps[i] = _steps[i].copyWith(
            status: StepStatus.pending,
            errorMessage: null,
          );
        }
      });

      _startCreationProcess();
    }
  }

  String _getErrorMessage(dynamic error) {
    if (error is CustomerValidationException) {
      return error.message;
    } else if (error is CustomerAlreadyExistsException) {
      return 'An account with this email or phone already exists';
    } else if (error is CustomerApiException) {
      return error.message;
    } else if (error is Exception) {
      return error.toString().replaceFirst('Exception: ', '');
    } else {
      return 'An unexpected error occurred';
    }
  }

  Future<void> _createSavingsAccount(String customerIdentifier) async {
    try {
      final newAccount = Account(
            (a) => a
          ..displayName = "Primary Savings"
          ..accountDetails = AccountDetails(
                (ad) => ad
              ..type = AccountDetailsTypeEnum.ACCOUNT_TYPE_SAVINGS
              ..productCode = "SAVINGS_PREMIUM",
          ).toBuilder(),
      );

      await ref
          .read(accountsProvider.notifier)
          .createAccount(account: newAccount, customerId: customerIdentifier);

      final accountsState = ref.read(accountsProvider);

      if (accountsState.hasError) {
        throw accountsState.error!;
      }

      if (accountsState.hasValue && accountsState.value != null) {
        return;
      }
    } catch (e) {
      throw Exception('Account creation failed: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(gradient: AppTheme.appGradient(colorScheme)),
          child: Center(
            child: SafeArea(
              minimum: const EdgeInsets.all(32.0), // p-8
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400), // max-w-sm
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildElegantRubiLoader(),
                    const SizedBox(height: 32), // mt-8
                    Text(
                      _hasError
                          ? 'Setup Incomplete'
                          : 'Welcome, ${widget.userName.split(' ').first}!',
                      style: theme.textTheme.displayLarge?.copyWith(
                        fontSize: 30, // text-3xl
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface, // #FFFFFF
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16), // mb-4
                    SizedBox(
                      width: 400, // max-w-sm
                      child: Text(
                        _hasError
                            ? _errorMessage ?? 'An error occurred during setup. Please try again.'
                            : _allDone
                            ? "You're all set! Redirecting to your dashboard..."
                            : "We're just getting your account ready. This will only take a moment.",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontSize: 16,
                          color: theme.colorScheme.shadow, // text-muted
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                      ),
                    ),
                    const SizedBox(height: 48), // mb-12
                    if (!_hasError || _currentStepIndex > 0)
                      SizedBox(
                        width: 400, // max-w-sm
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _steps.asMap().entries.map((entry) {
                            return AnimatedOpacity(
                              opacity: entry.value.status == StepStatus.pending ? 0.5 : 1.0,
                              duration: const Duration(milliseconds: 500),
                              child: _buildStepItem(entry.value),
                            );
                          }).toList(),
                        ),
                      ),
                    if (_hasError)
                      Padding(
                        padding: const EdgeInsets.only(top: 24.0),
                        child: CustomButton.muted(
                          text: 'Try Again',
                          onPressed: _retryProcess,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildElegantRubiLoader() {
    if (_hasError) {
      return Icon(
        Icons.error_outline,
        size: 64,
        color: Theme.of(context).colorScheme.error, // #EF4444
      );
    }

    return ElegantRubiLoader();
  }

  Widget _buildStepItem(StepItem step) {
    final theme = Theme.of(context);
    final isCompleted = step.status == StepStatus.completed;
    final isInProgress = step.status == StepStatus.inProgress;
    final isError = step.status == StepStatus.error;

    Color textColor;
    if (isError) {
      textColor = theme.colorScheme.error; // #EF4444
    } else if (isCompleted) {
      textColor = theme.colorScheme.onSurface; // #FFFFFF
    } else if (isInProgress) {
      textColor = theme.colorScheme.primary; // #C5A365
    } else {
      textColor = theme.colorScheme.shadow.withOpacity(0.5); // #7A8C99/50
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // space-y-4
      child: Row(
        children: [
          _buildStatusIcon(step.status),
          const SizedBox(width: 16), // gap-4
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (step.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      step.errorMessage!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.error, // #EF4444
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIcon(StepStatus status) {
    final theme = Theme.of(context);
    final accentGold = theme.colorScheme.primary; // #C5A365

    switch (status) {
      case StepStatus.completed:
        return const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 20); // green-500
      case StepStatus.inProgress:
        return SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(accentGold),
          ),
        );
      case StepStatus.error:
        return Icon(
          Icons.error_outline,
          color: theme.colorScheme.error, // #EF4444
          size: 20,
        );
      case StepStatus.pending:
        return Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: theme.colorScheme.shadow.withOpacity(0.5), width: 2), // #7A8C99/50
          ),
        );
    }
  }
}

enum StepStatus { pending, inProgress, completed, error }

class StepItem {
  final String label;
  final StepStatus status;
  final String? errorMessage;

  StepItem(this.label, this.status, {this.errorMessage});

  StepItem copyWith({String? label, StepStatus? status, String? errorMessage}) {
    return StepItem(
      label ?? this.label,
      status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}