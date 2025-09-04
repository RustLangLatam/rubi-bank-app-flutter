import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rubi_bank_api_sdk/rubi_bank_api_sdk.dart';
import '../../../../../core/common/theme/app_theme.dart';
import '../../../../../core/common/widgets/custom_back_button.dart';
import '../../../../../core/common/widgets/custom_button.dart';
import '../../../../../core/common/widgets/elegant_progress_indicator.dart';
import '../../providers/register_provider.dart';

class RegisterAddressScreen extends ConsumerStatefulWidget {
  final VoidCallback onBack;

  const RegisterAddressScreen({super.key, required this.onBack});

  @override
  ConsumerState<RegisterAddressScreen> createState() =>
      _RegisterAddressScreenState();
}

class _RegisterAddressScreenState extends ConsumerState<RegisterAddressScreen> {
  final _streetAddressController = TextEditingController(text: "Casa");
  final _cityController = TextEditingController(text: "Dubai");
  final _postalCodeController = TextEditingController(text: "25314");
  final _administrativeAreaController = TextEditingController(text: "Dubai");

  Country _selectedCountry = Country.parse("AE");
  String _streetAddressError = '';
  String _cityError = '';
  String _postalCodeError = '';
  String _countryError = '';

  @override
  void initState() {
    super.initState();
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
        // If not found, leave as default
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
    if (_selectedCountry.countryCode.isEmpty) {
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
        _selectedCountry.countryCode.isNotEmpty;
  }

  void _showCountryPicker() {
    showCountryPicker(
      context: context,
      showPhoneCode: false,
      exclude: ['IR', 'SY'],
      onSelect: (Country country) {
        setState(() {
          _selectedCountry = country;
          _validateCountry();
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
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          prefixIcon: Icon(
            Icons.search,
            color: Theme.of(context).colorScheme.shadow,
          ),
          hintStyle: Theme.of(context).textTheme.titleMedium,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
          ),
        ),
      ),
    );
  }

  void _handleNext() {
    _validateStreetAddress(_streetAddressController.text);
    _validateCity(_cityController.text);
    _validatePostalCode(_postalCodeController.text);
    _validateCountry();

    if (_areAllFieldsValid()) {
      final registerState = ref.read(registerProvider.notifier);
      final address = CustomerAddress(
        (b) => b
          ..streetAddressLines = ListBuilder([_streetAddressController.text])
          ..locality = _cityController.text
          ..administrativeArea = _administrativeAreaController.text
          ..postalCode = _postalCodeController.text
          ..countryCode = _selectedCountry.countryCode,
      );
      registerState.updateAddress(address);
      Navigator.pushNamed(context, '/register/phone');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.appGradient),
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
                    ElegantProgressIndicator(currentStep: 3, totalSteps: 4),
                    const SizedBox(height: 32),

                    // Title
                    Text(
                      'Residential Address',
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
                            // Street Address
                            TextFormField(
                              controller: _streetAddressController,
                              textInputAction: TextInputAction.next,
                              style: textTheme.bodyLarge,
                              decoration: InputDecoration(
                                hintText: 'Street Address',
                                errorText: _streetAddressError.isNotEmpty
                                    ? _streetAddressError
                                    : null,
                              ),
                              onChanged: _validateStreetAddress,
                            ),
                            const SizedBox(height: 16),

                            // City
                            TextFormField(
                              controller: _cityController,
                              style: textTheme.bodyLarge,
                              textCapitalization: TextCapitalization.words,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(
                                  RegExp(r'[0-9]'),
                                ),
                                FilteringTextInputFormatter.deny(
                                  RegExp(
                                    r'[!@#\$%^&*()_+={}\[\]|;:"<>,.?/\\~`]',
                                  ),
                                ),
                              ],
                              decoration: InputDecoration(
                                hintText: 'City',
                                errorText: _cityError.isNotEmpty
                                    ? _cityError
                                    : null,
                              ),
                              onChanged: _validateCity,
                            ),
                            const SizedBox(height: 16),

                            // Postal Code
                            TextFormField(
                              controller: _postalCodeController,
                              style: textTheme.bodyLarge,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                hintText: 'Postal Code',
                                errorText: _postalCodeError.isNotEmpty
                                    ? _postalCodeError
                                    : null,
                              ),
                              onChanged: _validatePostalCode,
                            ),
                            const SizedBox(height: 16),

                            // State/Province (Optional)
                            TextFormField(
                              controller: _administrativeAreaController,
                              style: textTheme.bodyLarge,
                              textCapitalization: TextCapitalization.words,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(
                                  RegExp(r'[0-9]'),
                                ),
                                FilteringTextInputFormatter.deny(
                                  RegExp(
                                    r'[!@#\$%^&*()_+={}\[\]|;:"<>,.?/\\~`]',
                                  ),
                                ),
                              ],
                              decoration: InputDecoration(
                                hintText: 'State/Province (Optional)',
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Country selector
                            GestureDetector(
                              onTap: _showCountryPicker,
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: colorScheme.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: _countryError.isNotEmpty
                                        ? Colors.red
                                        : colorScheme.primary.withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        _selectedCountry.name.isNotEmpty
                                            ? _selectedCountry.name
                                            : 'Country',
                                        style: _selectedCountry.name.isNotEmpty
                                            ? textTheme.bodyLarge
                                            : textTheme.titleMedium,
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

class RegisterAddressScreenWrapper extends StatelessWidget {
  const RegisterAddressScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return RegisterAddressScreen(onBack: () => Navigator.pop(context));
  }
}
