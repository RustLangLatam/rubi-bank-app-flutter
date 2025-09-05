import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/common/theme/app_theme.dart';
import '../../../../../core/common/widgets/custom_back_button.dart';
import '../../../../../core/common/widgets/custom_button.dart';
import '../../../../../core/common/widgets/elegant_progress_indicator.dart';
import '../../providers/register_provider.dart';

class RegisterIdentityScreen extends ConsumerStatefulWidget {
  final VoidCallback onBack;

  const RegisterIdentityScreen({super.key, required this.onBack});

  @override
  ConsumerState<RegisterIdentityScreen> createState() =>
      _RegisterIdentityScreenState();
}

class _RegisterIdentityScreenState
    extends ConsumerState<RegisterIdentityScreen> {
  final _documentNumberController = TextEditingController();

  Country _selectedCountry = Country.parse('AE');
  String _documentType = '';
  String _documentNumber = '';
  String _documentNumberError = '';
  String _documentTypeError = '';

  final List<Map<String, String>> _documentTypes = [
    {'value': '', 'label': 'Document Type (ID, Passport)', 'disabled': 'true'},
    {'value': 'IdentityCard', 'label': 'ID Card'},
    {'value': 'Passport', 'label': 'Passport'},
    {'value': 'NationalIdentity', 'label': 'National ID'},
  ];

  @override
  void initState() {
    super.initState();
    final registerState = ref.read(registerProvider);

    if (registerState.customer.nationality.isNotEmpty) {
      try {
        final country = Country.parse(registerState.customer.nationality);
        _selectedCountry = country;
      } catch (e) {
        // If not found, leave as default
      }
    }

    if (registerState.customer.idn.number.isNotEmpty) {
      _documentNumberController.text = registerState.customer.idn.number;
      _documentNumber = registerState.customer.idn.number;
    }

    if (registerState.customer.idn.type.isNotEmpty) {
      _documentType = registerState.customer.idn.type;
    }
  }

  void _validateDocumentType(String? value) {
    if (value == null || value.isEmpty) {
      setState(() => _documentTypeError = 'Document Type is required');
    } else {
      setState(() => _documentTypeError = '');
    }
  }

  void _validateDocumentNumber(String value) {
    if (value.isEmpty) {
      setState(() => _documentNumberError = 'Document Number is required');
    } else {
      setState(() => _documentNumberError = '');
    }
  }

  bool _areAllFieldsValid() {
    return _documentNumberError.isEmpty &&
        _documentTypeError.isEmpty &&
        _documentNumber.isNotEmpty &&
        _documentType.isNotEmpty;
  }

  void _handleNext() {
    _validateDocumentType(_documentType);
    _validateDocumentNumber(_documentNumber);

    if (_areAllFieldsValid()) {
      final registerState = ref.read(registerProvider.notifier);
      registerState.updateIdentity(
        _selectedCountry.countryCode,
        _documentType,
        _documentNumber,
      );
      Navigator.pushNamed(context, '/register/address');
    }
  }

  void _showCountryPicker() {
    showCountryPicker(
      context: context,
      showPhoneCode: false,
      exclude: ['IR', 'SY'],
      onSelect: (Country country) {
        setState(() {
          _selectedCountry = country;
        });
      },
      countryListTheme: CountryListThemeData(
        flagSize: 25,
        backgroundColor: Theme.of(context).colorScheme.surface,
        textStyle: Theme.of(context).textTheme.bodyLarge,
        borderRadius: BorderRadius.circular(12),
        inputDecoration: InputDecoration(
          labelText: 'Search',
          hintText: 'Start typing to search',
          prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.shadow),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _documentNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.appGradient(colorScheme)),
        child: SafeArea(
          child: KeyboardVisibilityBuilder(
            builder: (context, isKeyboardVisible) {
              return Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back button
                    CustomBackButtonWithSpacing(
                      onPressed: widget.onBack,
                      color: colorScheme.onBackground,
                      spacing: 16,
                    ),

                    // Progress indicator
                    ElegantProgressIndicator(currentStep: 2, totalSteps: 4),
                    const SizedBox(height: 32),

                    // Title
                    Text(
                      'Identity Verification',
                      style: textTheme.displayLarge?.copyWith(
                        fontSize: 30, // text-3xl
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Form fields
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // Nationality selector
                            GestureDetector(
                              onTap: _showCountryPicker,
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: colorScheme.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: colorScheme.primary.withOpacity(0.125),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        _selectedCountry.name,
                                        style: textTheme.bodyLarge,
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_drop_down,
                                      color: colorScheme.shadow,
                                      size: 24,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Document Type dropdown
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: colorScheme.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _documentTypeError.isNotEmpty
                                      ? Colors.red
                                      : colorScheme.primary.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _documentType.isNotEmpty ? _documentType : null,
                                  items: _documentTypes.map((Map<String, String> doc) {
                                    return DropdownMenuItem<String>(
                                      value: doc['value'],
                                      enabled: doc['disabled'] != 'true',
                                      child: Text(
                                        doc['label']!,
                                        style: textTheme.bodyLarge?.copyWith(
                                          color: doc['disabled'] == 'true'
                                              ? colorScheme.shadow
                                              : colorScheme.onSurface,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    if (newValue != null && newValue.isNotEmpty) {
                                      setState(() {
                                        _documentType = newValue;
                                        _validateDocumentType(_documentType);
                                      });
                                    }
                                  },
                                  style: textTheme.bodyLarge,
                                  dropdownColor: colorScheme.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: colorScheme.shadow,
                                    size: 24,
                                  ),
                                  isExpanded: true,
                                  hint: Text(
                                    'Document Type (ID, Passport)',
                                    style: textTheme.titleMedium,
                                  ),
                                  elevation: 4,
                                ),
                              ),
                            ),
                            if (_documentTypeError.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  _documentTypeError,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 16),

                            // Document Number
                            TextFormField(
                              textInputAction: TextInputAction.done,
                              controller: _documentNumberController,
                              style: textTheme.bodyLarge,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: colorScheme.surface,
                                hintText: 'Document Number',
                                hintStyle: textTheme.titleMedium,
                                contentPadding: const EdgeInsets.all(16),
                                border: theme.inputDecorationTheme.border,
                                enabledBorder: theme.inputDecorationTheme.enabledBorder,
                                focusedBorder: theme.inputDecorationTheme.focusedBorder,
                                errorText: _documentNumberError.isNotEmpty
                                    ? _documentNumberError
                                    : null,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _documentNumber = value;
                                  _validateDocumentNumber(_documentNumber);
                                });
                              },
                              onFieldSubmitted: (_) {
                                if (_areAllFieldsValid()) {
                                  _handleNext();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Next button
                    if (!isKeyboardVisible) ...[
                      const SizedBox(height: 32),
                      CustomButton.primary(
                        text: "Next",
                        onPressed: _handleNext,
                      ),
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

class RegisterIdentityScreenWrapper extends StatelessWidget {
  const RegisterIdentityScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return RegisterIdentityScreen(onBack: () => Navigator.pop(context));
  }
}
