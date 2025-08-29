import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:country_picker/country_picker.dart';
import 'package:rubi_bank_api_sdk/rubi_bank_api_sdk.dart';
import '../../../../../core/common/widgets/custom_back_button.dart';
import '../../../../../core/common/widgets/custom_button.dart';
import '../../../../../core/common/widgets/elegant_progress_indicator.dart';
import '../../providers/register_provider.dart';

class RegisterAddressScreen extends ConsumerStatefulWidget {
  final VoidCallback onBack;

  const RegisterAddressScreen({
    super.key,
    required this.onBack,
  });

  @override
  ConsumerState<RegisterAddressScreen> createState() => _RegisterAddressScreenState();
}

class _RegisterAddressScreenState extends ConsumerState<RegisterAddressScreen> {
  final _streetAddressController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _administrativeAreaController = TextEditingController();

  Country? _selectedCountry;
  String _streetAddressError = '';
  String _cityError = '';
  String _postalCodeError = '';
  String _countryError = '';

  @override
  void initState() {
    super.initState();
    // Prefill with existing customer data from provider
    final registerState = ref.read(registerProvider);

    final address = registerState.customer.residentialAddress;

    if (address.streetAddressLines.isNotEmpty) {
      _streetAddressController.text = address.streetAddressLines.first;
    }
    if (address.locality.isNotEmpty) {
      _cityController.text = address.locality;
    }
    if (address.postalCode.isNotEmpty) {
      _postalCodeController.text = address.postalCode;
    }
    if (address.administrativeArea.isNotEmpty) {
      _administrativeAreaController.text = address.administrativeArea;
    }
    if (address.countryCode.isNotEmpty) {
      try {
        _selectedCountry = Country.parse(address.countryCode);
      } catch (e) {
        // If not found, leave as null
      }
    }
  }

  @override
  void dispose() {
    _streetAddressController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    _administrativeAreaController.dispose();
    super.dispose();
  }

  void _validateStreetAddress(String value) {
    if (value.isEmpty) {
      setState(() => _streetAddressError = 'Street Address is required');
    } else {
      setState(() => _streetAddressError = '');
    }
  }

  void _validateCity(String value) {
    if (value.isEmpty) {
      setState(() => _cityError = 'City is required');
    } else {
      setState(() => _cityError = '');
    }
  }

  void _validatePostalCode(String value) {
    if (value.isEmpty) {
      setState(() => _postalCodeError = 'Postal Code is required');
    } else {
      setState(() => _postalCodeError = '');
    }
  }

  void _validateCountry() {
    if (_selectedCountry == null) {
      setState(() => _countryError = 'Country is required');
    } else {
      setState(() => _countryError = '');
    }
  }

  bool _areAllFieldsValid() {
    return _streetAddressError.isEmpty &&
        _cityError.isEmpty &&
        _postalCodeError.isEmpty &&
        _countryError.isEmpty &&
        _streetAddressController.text.isNotEmpty &&
        _cityController.text.isNotEmpty &&
        _postalCodeController.text.isNotEmpty &&
        _selectedCountry != null;
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
          prefixIcon: const Icon(Icons.search),
        ),
      ),
    );
  }

  void _handleNext() {
    // Validate all fields
    _validateStreetAddress(_streetAddressController.text);
    _validateCity(_cityController.text);
    _validatePostalCode(_postalCodeController.text);
    _validateCountry();

    if (_areAllFieldsValid()) {
      // Update the customer data in the provider
      final registerState = ref.read(registerProvider.notifier);

      final address = CustomerAddress(
            (b) => b
          ..streetAddressLines = ListBuilder([_streetAddressController.text])
          ..locality = _cityController.text
          ..administrativeArea = _administrativeAreaController.text
          ..postalCode = _postalCodeController.text
          ..countryCode = _selectedCountry!.countryCode,
      );

      registerState.updateAddress(address);

      // Navigate to next screen using named route
      Navigator.pushNamed(context, '/register/phone');
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

              // Progress indicator
              ElegantProgressIndicator(
                currentStep: 3,
                totalSteps: 4,
              ),
              const SizedBox(height: 32),

              // Title
              Text(
                'Residential Address',
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
                      // Street Address
                      TextFormField(
                        controller: _streetAddressController,
                        style: theme.textTheme.bodyLarge,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: colorScheme.surface,
                          hintText: 'Street Address *',
                          hintStyle: theme.textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF94A3B8),
                          ),
                          contentPadding: const EdgeInsets.all(16),
                          errorText: _streetAddressError.isNotEmpty ? _streetAddressError : null,
                        ),
                        onChanged: _validateStreetAddress,
                      ),
                      const SizedBox(height: 20),

                      // City
                      TextFormField(
                        controller: _cityController,
                        style: theme.textTheme.bodyLarge,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: colorScheme.surface,
                          hintText: 'City *',
                          hintStyle: theme.textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF94A3B8),
                          ),
                          contentPadding: const EdgeInsets.all(16),
                          errorText: _cityError.isNotEmpty ? _cityError : null,
                        ),
                        onChanged: _validateCity,
                      ),
                      const SizedBox(height: 20),

                      // Postal Code
                      TextFormField(
                        controller: _postalCodeController,
                        style: theme.textTheme.bodyLarge,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: colorScheme.surface,
                          hintText: 'Postal Code *',
                          hintStyle: theme.textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF94A3B8),
                          ),
                          contentPadding: const EdgeInsets.all(16),
                          errorText: _postalCodeError.isNotEmpty ? _postalCodeError : null,
                        ),
                        onChanged: _validatePostalCode,
                      ),
                      const SizedBox(height: 20),

                      // State/Province (Optional)
                      TextFormField(
                        controller: _administrativeAreaController,
                        style: theme.textTheme.bodyLarge,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: colorScheme.surface,
                          hintText: 'State/Province (Optional)',
                          hintStyle: theme.textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF94A3B8),
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Country selector
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
                                  : colorScheme.surface.withOpacity(0.8),
                              width: 1,
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
                                  'Country *',
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

class RegisterAddressScreenWrapper extends StatelessWidget {
  const RegisterAddressScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return RegisterAddressScreen(
        onBack: () => Navigator.pop(context),
    );
  }
}