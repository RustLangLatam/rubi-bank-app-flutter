import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rubi_bank_api_sdk/rubi_bank_api_sdk.dart' as sdk;
import 'package:rubi_bank_app/core/utils/decimal_precision.dart';

import '../../../../core/common/theme/app_theme.dart';
import '../../../../core/common/widgets/custom_back_button.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/common/widgets/qr_code_icon.dart';
import '../../../../data/providers/api_provider.dart';

class SendMoneyScreen extends ConsumerStatefulWidget {
  final VoidCallback? onBack;
  final VoidCallback? onContinue;
  final Map<String, String>? prefilledData;
  final Decimal issuedBalance;

  const SendMoneyScreen({
    super.key,
    this.onBack,
    this.onContinue,
    this.prefilledData,
    required this.issuedBalance,
  });

  @override
  ConsumerState<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends ConsumerState<SendMoneyScreen> {
  TransferType _transferType = TransferType.rubi;
  String _amount = '0.00';
  String? _amountError; // Add error state

  Decimal _amountDecimal = Decimal.parse('0.00');

  // Add TextEditingController for amount
  late TextEditingController _amountController;

  String _rubiRecipient = '';
  String _beneficiaryName = '';
  String _iban = '';
  String _swiftBic = '';

  @override
  void initState() {
    super.initState();

    // Initialize the controller
    _amountController = TextEditingController(text: _amount);

    // Set prefilled data if available
    if (widget.prefilledData != null) {
      _amount = widget.prefilledData!['amount'] ?? '0.00';
      _rubiRecipient = widget.prefilledData!['recipient'] ?? '';
      _amountController.text = _amount; // Update controller text
    }
  }

  void _handleAmountChange(String value) {
    // Remove non-digit characters
    String digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.isEmpty) {
      setState(() {
        _amount = '0.00';
        _amountController.text = _amount;
        _amountError = null;
      });
      return;
    }

    // Remove leading zeros
    while (digitsOnly.length > 1 && digitsOnly.startsWith('0')) {
      digitsOnly = digitsOnly.substring(1);
    }

    // Convert to decimal format (divide by 100)
    final numericValue = Decimal.parse(digitsOnly) / Decimal.fromInt(100);

    // Validate if amount exceeds available balance
    if (numericValue > widget.issuedBalance.toRational()) {
      setState(() {
        _amount = numericValue.toDecimal().toStringAsFixed(2);
        _amountController.text = _amount;
        _amountError = 'Amount exceeds available balance';
      });
    } else {
      setState(() {
        _amount = numericValue.toDecimal().toStringAsFixed(2);
        _amountController.text = _amount;
        _amountError = null;
      });
    }
  }

  // Add this method to format the balance display
  String get _formattedBalance {
    return widget.issuedBalance.toFormattedString();
  }

  @override
  void dispose() {
    _amountController.dispose(); // Don't forget to dispose!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.appGradient(colorScheme)),
        child: SafeArea(
          child: KeyboardVisibilityBuilder(
            builder: (context, isKeyboardVisible) {
              return Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomBackButton(
                          onPressed:
                              widget.onBack ?? () => Navigator.pop(context),
                          color: colorScheme.onBackground,
                        ),
                        Text('Send Money', style: textTheme.displayMedium),
                        IconButton(
                          onPressed: () {},
                          icon: const QrCodeIcon(),
                          color: colorScheme.onBackground,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Transfer Type Toggle
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: TransferTypeToggle(
                        transferType: _transferType,
                        onTypeChanged: (type) {
                          setState(() {
                            _transferType = type;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Amount Input
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '\$',
                                style: GoogleFonts.inter(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.shadow,
                                ),
                              ),
                              const SizedBox(width: 12),
                              IntrinsicWidth(
                                child: TextField(
                                  controller: _amountController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  onChanged: _handleAmountChange,
                                  style: GoogleFonts.inter(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    color: _amountError != null
                                        ? colorScheme.error
                                        : colorScheme.onSurface,
                                  ),
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    focusedErrorBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                    isDense: true,
                                    hintText: '0.00',
                                    filled: true,
                                    fillColor: Colors.transparent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _amountError ??
                                'Available Balance: $_formattedBalance',
                            style: textTheme.titleMedium?.copyWith(
                              color: _amountError != null
                                  ? colorScheme.error
                                  : colorScheme.shadow,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Form based on transfer type
                    SizedBox(
                      child: _transferType == TransferType.rubi
                          ? RubiTransferForm(
                              recipient: _rubiRecipient,
                              onRecipientChanged: (value) {
                                setState(() {
                                  _rubiRecipient = value;
                                });
                              },
                            )
                          : ExternalTransferForm(
                              beneficiaryName: _beneficiaryName,
                              iban: _iban,
                              swiftBic: _swiftBic,
                              onBeneficiaryNameChanged: (value) {
                                setState(() {
                                  _beneficiaryName = value;
                                });
                              },
                              onIbanChanged: (value) {
                                setState(() {
                                  _iban = value;
                                });
                              },
                              onSwiftBicChanged: (value) {
                                setState(() {
                                  _swiftBic = value;
                                });
                              },
                            ),
                    ),
                    const SizedBox(height: 16),

                    // Note Input
                    SizedBox(
                      child: TextField(
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintText: 'Add a note (optional)',
                          hintStyle: textTheme.titleMedium,
                        ),
                      ),
                    ),

                    if (!isKeyboardVisible) ...[
                      // Continue Button
                      const SizedBox(height: 32),
                      CustomButton.primary(
                        text: 'Continue',
                        onPressed: _amountError == null
                            ? () {
                                final transaction = sdk.Transaction(
                                  (t) => t
                                    ..type = sdk
                                        .TransactionTypeEnum
                                        .TRANSACTION_TYPE_TRANSFER
                                    ..amount = sdk.Money(
                                      (m) => m
                                        ..value = _amountDecimal
                                            .toDecimalPrecision()
                                            .toBuilder()
                                        ..currencyCode = 'USD',
                                    ).toBuilder()
                                    ..oneOf = sdk.OneOf1(
                                      value: sdk.TransferDetails(
                                        (d) => d
                                          ..description = 'Transfer'
                                          ..destination = sdk.FinancialAddress(
                                            (f) => f.oneOf = sdk.OneOf1(
                                              value: sdk.RubiAccount(
                                                (r) => r
                                                  ..oneOf = sdk.OneOf1(
                                                    value: sdk.Phone(
                                                      (p) => p
                                                        ..number =
                                                            _rubiRecipient
                                                        ..countryCode = 57,
                                                    ),
                                                  ),
                                              ).toBuilder(),
                                            ),
                                          ).toBuilder()
                                          ..source_ = sdk.FinancialAddress(
                                            (f) => f.oneOf = sdk.OneOf1(
                                              value: sdk.RubiAccount(
                                                (r) => r
                                                  ..oneOf = sdk.OneOf1(
                                                    value: sdk.Phone(
                                                      (p) => p
                                                        ..number =
                                                            _rubiRecipient
                                                        ..countryCode = 57,
                                                    ),
                                                  ),
                                              ).toBuilder(),
                                            ),
                                          ).toBuilder(),
                                      ).toBuilder(),
                                    ),
                                );

                                try {
                                final transactionsApi = ref
                                    .read(transactionsApiProvider)
                                    .createTransaction(
                                      account: "123546546",
                                      transaction: transaction,
                                    );
                                } catch (e) {
                                  debugPrint(e.toString());
                                }


                                // Only allow continue if no error
                                // Navigate to transfer confirmation screen
                              }
                            : () {}, // Disable button if there's an error
                      ),
                      const SizedBox(height: 32),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

enum TransferType { rubi, external }

class TransferTypeToggle extends StatelessWidget {
  final TransferType transferType;
  final ValueChanged<TransferType> onTypeChanged;

  const TransferTypeToggle({
    super.key,
    required this.transferType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onTypeChanged(TransferType.rubi),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: transferType == TransferType.rubi
                      ? colorScheme.primary.withOpacity(0.2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  'RubiBank User',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: transferType == TransferType.rubi
                        ? colorScheme.primary
                        : colorScheme.shadow,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onTypeChanged(TransferType.external),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: transferType == TransferType.external
                      ? colorScheme.primary.withOpacity(0.2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  'External Bank',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: transferType == TransferType.external
                        ? colorScheme.primary
                        : colorScheme.shadow,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RubiTransferForm extends StatelessWidget {
  final String recipient;
  final ValueChanged<String> onRecipientChanged;

  const RubiTransferForm({
    super.key,
    required this.recipient,
    required this.onRecipientChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onRecipientChanged,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        hintText: '\$rubi alias or phone number',
      ),
    );
  }
}

class ExternalTransferForm extends StatelessWidget {
  final String beneficiaryName;
  final String iban;
  final String swiftBic;
  final ValueChanged<String> onBeneficiaryNameChanged;
  final ValueChanged<String> onIbanChanged;
  final ValueChanged<String> onSwiftBicChanged;

  const ExternalTransferForm({
    super.key,
    required this.beneficiaryName,
    required this.iban,
    required this.swiftBic,
    required this.onBeneficiaryNameChanged,
    required this.onIbanChanged,
    required this.onSwiftBicChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          // value: beneficiaryName,
          onChanged: onBeneficiaryNameChanged,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(hintText: 'Beneficiary Name'),
        ),
        const SizedBox(height: 16),
        TextField(
          // value: iban,
          onChanged: onIbanChanged,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(hintText: 'IBAN'),
        ),
        const SizedBox(height: 16),
        TextField(
          // value: swiftBic,
          onChanged: onSwiftBicChanged,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(hintText: 'SWIFT / BIC'),
        ),
      ],
    );
  }
}
