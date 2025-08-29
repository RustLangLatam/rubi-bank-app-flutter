import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/common/widgets/custom_back_button.dart';
import '../../../../../core/common/widgets/custom_button.dart';
import '../../../../../core/common/widgets/elegant_progress_indicator.dart';
import '../../providers/register_provider.dart';

class RegisterIdentityScreen extends ConsumerStatefulWidget {
  final VoidCallback onBack;

  const RegisterIdentityScreen({
    super.key,
    required this.onBack,
  });

  @override
  ConsumerState<RegisterIdentityScreen> createState() => _RegisterIdentityScreenState();
}

class _RegisterIdentityScreenState extends ConsumerState<RegisterIdentityScreen> {
  final _documentNumberController = TextEditingController();

  Country? _selectedCountry;
  String _documentType = '';
  String _documentNumber = '';
  String _documentNumberError = '';
  String _documentTypeError = '';
  String _countryError = '';

  final List<Map<String, String>> _documentTypes = [
    {'value': 'IdentityCard', 'label': 'ID Card'},
    {'value': 'Passport', 'label': 'Passport'},
    {'value': 'NationalIdentity', 'label': 'National ID'}
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
        // If not found, leave as null
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

  void _validateCountry() {
    if (_selectedCountry == null) {
      setState(() => _countryError = 'Nationality is required');
    } else {
      setState(() => _countryError = '');
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
        _countryError.isEmpty &&
        _documentNumber.isNotEmpty &&
        _documentType.isNotEmpty &&
        _selectedCountry != null;
  }

  void _handleNext() {
    // Validate all fields
    _validateDocumentType(_documentType);
    _validateCountry();
    _validateDocumentNumber(_documentNumber);

    if (_areAllFieldsValid()) {
      // Update the customer data in the provider
      final registerState = ref.read(registerProvider.notifier);

      registerState.updateIdentity(
        _selectedCountry!.countryCode,
        _documentType,
        _documentNumber,
      );

      // Navigate to next screen
      Navigator.pushNamed(context, '/register/address');
    }
    // else {
    //   // Show error message if any field is invalid
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('Please fill all required fields correctly'),
    //       backgroundColor: Colors.red,
    //     ),
    //   );
    // }
  }

  void _showCountryPicker() {
    showCountryPicker(
      context: context,
      showPhoneCode: false,
      onSelect: (Country country) {
        setState(() {
          _selectedCountry = country;
          _validateCountry();
        });
      },
      countryListTheme: CountryListThemeData(
        flagSize: 25,
        backgroundColor: Theme.of(context).colorScheme.primary,
        textStyle: Theme.of(context).textTheme.bodyLarge,
        borderRadius: BorderRadius.circular(10.5),
        inputDecoration: InputDecoration(
          labelText: 'Search',
          hintText: 'Start typing to search',
          prefixIcon: const Icon(Icons.search)
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

    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              CustomBackButtonWithSpacing(
                onPressed: widget.onBack,
                color: colorScheme.secondary,
                spacing: 16,
              ),

              // // Progress indicator
              ElegantProgressIndicator(
                currentStep: 2,
                totalSteps: 4,
              ),
              const SizedBox(height: 32),

              // Title
              Text(
                'Identity Verification',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 40),

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
                          padding: const EdgeInsets.all(13),
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(10.5),
                            border: Border.all(
                              color: _countryError.isNotEmpty
                                  ? Colors.red
                                  : colorScheme.onSurface.withOpacity(0.5),
                              width: 0.2,
                            ),
                          ),
                          child: Row(
                            children: [
                              if (_selectedCountry != null)
                                Text(
                                  _selectedCountry!.name,
                                  style: theme.textTheme.bodyLarge,
                                )
                              else
                                Text(
                                  'Select Nationality *',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: const Color(0xFF94A3B8),
                                  ),
                                ),
                              const Spacer(),
                              const Icon(
                                Icons.arrow_drop_down,
                                color: Color(0xFF94A3B8),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (_countryError.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            _countryError,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),

                      Focus(
                        skipTraversal: true,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(10.5),
                            border: Border.all(
                              color: _documentTypeError.isNotEmpty
                                  ? Colors.red
                                  : colorScheme.onSurface.withOpacity(0.5),
                              width: 0.2,
                            ),
                          ),
                          child: DropdownButtonFormField<String>(
                            value: _documentType.isNotEmpty ? _documentType : null,
                            items: _documentTypes.map((Map<String, String> doc) {
                              return DropdownMenuItem<String>(
                                value: doc['value'],
                                child: Text(
                                  doc['label']!,
                                  style: theme.textTheme.bodyLarge,
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _documentType = newValue ?? '';
                                _validateDocumentType(_documentType);
                              });
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                              hintText: 'Document Type *',
                              hintStyle: theme.textTheme.bodyMedium,
                              errorText: _documentTypeError.isNotEmpty ? _documentTypeError : null,
                            ),
                            style: theme.textTheme.bodyLarge,
                            dropdownColor: colorScheme.surface,
                            borderRadius: BorderRadius.circular(10.5),
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: colorScheme.onSurface,
                            ),
                            iconSize: 24,
                            isExpanded: true,
                            menuMaxHeight: 200,
                            elevation: 4,
                            selectedItemBuilder: (BuildContext context) {
                              return _documentTypes.map((Map<String, String> doc) {
                                return Text(
                                  doc['label']!,
                                  style: theme.textTheme.bodyLarge,
                                );
                              }).toList();
                            },
                          ),
                        ),
                      ),

                      if (_documentTypeError.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            _documentTypeError,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),

                      // Document Number
                      TextFormField(
                        onChanged: (value) {
                          setState(() {
                            _documentNumber = value;
                            _validateDocumentNumber(_documentNumber);
                          });
                        },
                        controller: _documentNumberController,
                        style: theme.textTheme.bodyLarge,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: colorScheme.surface,
                          hintText: 'Document Number *',
                          hintStyle: theme.textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF94A3B8),
                          ),
                          contentPadding: const EdgeInsets.all(16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.5),
                            borderSide: BorderSide(
                              color: _documentNumberError.isNotEmpty
                                  ? Colors.red
                                  : colorScheme.surface.withOpacity(0.8),
                              width: 1,
                            ),
                          ),
                          errorText: _documentNumberError.isNotEmpty ? _documentNumberError : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Next button
              const SizedBox(height: 32),
              CustomButton(
                text: "Next",
                onPressed: _handleNext,
                type: ButtonType.primary,
              ),
            ],
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
    return RegisterIdentityScreen(
        onBack: () => Navigator.pop(context),
    );
  }
}