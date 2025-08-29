import 'package:flutter/foundation.dart';
import 'package:rubi_bank_api_sdk/rubi_bank_api_sdk.dart';

class RegisterProvider with ChangeNotifier {
  Customer _customer = Customer(
    (b) => b
      ..givenName = ""
      ..familyName = ""
      ..nationality = "US"
      ..email = ""
      ..idn = Idn(
        (b) => b
          ..number = ""
          ..type = "IdentityCard",
      ).toBuilder()
      ..phoneNumber = Phone(
        (b) => b
          ..number = ""
          ..countryCode = 1,
      ).toBuilder()
      ..residentialAddress = CustomerAddress(
        (b) => b
          ..streetAddressLines = ListBuilder([""])
          ..locality = ""
          ..administrativeArea = ""
          ..postalCode = ""
          ..countryCode = "US",
      ).toBuilder()
      ..state = CustomerStateEnum.CUSTOMER_STATE_PENDING_VERIFICATION
      ..kycStatus = CustomerKycStatusEnum.KYC_STATUS_NONE,
  );

  String _password = "";

  Customer get customer => _customer;

  String get password => _password;

  void updatePersonalInfo(String givenName, String familyName, String email) {
   _customer = _customer.rebuild(
      (r) => r
        ..givenName = givenName
        ..familyName = familyName
        ..email = email,
    );

    notifyListeners();
  }

  void updateIdentity(String nationality, String docType, String docNumber) {
    _customer = _customer.rebuild(
      (r) => r
        ..nationality = nationality
        ..idn = Idn(
          (b) => b
            ..number = docNumber
            ..type = docType,
        ).toBuilder(),
    );
    notifyListeners();
  }

  void updateAddress(CustomerAddress address) {
    _customer = _customer.rebuild((r) => r..residentialAddress = address.toBuilder());
    notifyListeners();
  }

  void updatePhone(Phone phone) {
    _customer = _customer.rebuild((r) => r..phoneNumber = phone.toBuilder());
    notifyListeners();
  }

  void updatePassword(String password) {
    _password = password;
    notifyListeners();
  }

  void reset() {
    _customer = Customer(
      (b) => b
        ..givenName = ""
        ..familyName = ""
        ..nationality = "US"
        ..email = ""
        ..idn = Idn(
          (b) => b
            ..number = ""
            ..type = "IdentityCard",
        ).toBuilder()
        ..phoneNumber = Phone(
          (b) => b
            ..number = ""
            ..countryCode = 1,
        ).toBuilder()
        ..residentialAddress = CustomerAddress(
          (b) => b
            ..streetAddressLines = ListBuilder([""])
            ..locality = ""
            ..administrativeArea = ""
            ..postalCode = ""
            ..countryCode = "US",
        ).toBuilder()
        ..state = CustomerStateEnum.CUSTOMER_STATE_PENDING_VERIFICATION
        ..kycStatus = CustomerKycStatusEnum.KYC_STATUS_NONE,
    );
    _password = "";
    notifyListeners();
  }
}
