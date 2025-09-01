import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rubi_bank_api_sdk/rubi_bank_api_sdk.dart';
import '../../../../../core/common/widgets/elegant_rubi_loader.dart';
import '../../../../accounts/presentation/providers/accounts_provider.dart';
import '../../providers/customer_provider.dart';
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
            // Handle the error from the provider
            throw customerState.error!;
          }

          // Verify that the customer was actually created
          if (customerState.value == null) {
            throw Exception(
              'Customer creation failed: No customer data returned',
            );
          }

          final email = customerState.value!.email;

          await ref
              .read(customerProvider.notifier)
              .loginCustomer(email, password);
        } else if (i == 1) {
          // Step 2: Create savings account
          final createCustomerState = ref.read(customerProvider);

          // Check if previous step had errors
          if (createCustomerState.hasError) {
            throw createCustomerState.error!;
          }

          final createdCustomer = createCustomerState.value;

          if (createdCustomer != null && createdCustomer.identifier != null) {
            await _createSavingsAccount(createdCustomer.identifier!);
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
        final errorMsg = _getErrorMessage(e);
        setState(() {
          _hasError = true;
          _errorMessage = errorMsg;
          // Mark the current step as error
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
        // Reset all steps to pending
        for (int i = 0; i < _steps.length; i++) {
          _steps[i] = _steps[i].copyWith(
            status: StepStatus.pending,
            errorMessage: null,
          );
        }
      });

      // Restart the process
      _startCreationProcess();
    }
  }

  // Helper method to get user-friendly error messages
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

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: theme.colorScheme.primary,
        body: Center(
          // Usar Center como widget principal
          child: SafeArea(
            minimum: const EdgeInsets.all(32.0), // Mínimo padding garantizado
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 400, // Ancho máximo para pantallas grandes
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Elegant Rubi Loader or error icon
                  _buildElegantRubiLoader(),
                  const SizedBox(height: 32),
                  // Welcome title or error title
                  Text(
                    _hasError
                        ? 'Setup Incomplete'
                        : 'Welcome, ${widget.userName.split(' ').first}!',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  // Description or error message
                  SizedBox(
                    width: 300,
                    child: Text(
                      _hasError
                          ? _errorMessage ??
                          'An error occurred during setup. Please try again.'
                          : _allDone
                          ? "You're all set! Redirecting to your dashboard..."
                          : "We're just getting your account ready. This will only take a moment.",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                    ),
                  ),
                  const SizedBox(height: 48),
                  // Steps list (only show if not in critical error state)
                  if (!_hasError || _currentStepIndex > 0)
                    SizedBox(
                      width: 300,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _steps
                            .map((step) => _buildStepItem(step))
                            .toList(),
                      ),
                    ),
                  // Retry button for errors
                  if (_hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: ElevatedButton(
                        onPressed: _retryProcess,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.secondary,
                          foregroundColor: theme.colorScheme.onSecondary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: const Text('Try Again'),
                      ),
                    ),
                ],
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
        color: Theme.of(context).colorScheme.error,
      );
    }

    return _allDone
        ? Icon(Icons.check_circle, size: 64, color: Colors.green)
        : const ElegantRubiLoader();
  }

  Widget _buildStepItem(StepItem step) {
    final theme = Theme.of(context);
    final isCompleted = step.status == StepStatus.completed;
    final isInProgress = step.status == StepStatus.inProgress;
    final isError = step.status == StepStatus.error;

    Color textColor;
    if (isError) {
      textColor = theme.colorScheme.error;
    } else if (isCompleted) {
      textColor = theme.textTheme.bodyMedium!.color!;
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
                        color: theme.colorScheme.error,
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
    final accentGold = theme.colorScheme.secondary;

    switch (status) {
      case StepStatus.completed:
        return Icon(Icons.check_circle, color: Colors.green, size: 20);
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
          color: theme.colorScheme.error,
          size: 20,
        );
      case StepStatus.pending:
        return Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFA9B4C4), width: 2),
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
