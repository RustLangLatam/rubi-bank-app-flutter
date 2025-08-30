import 'package:flutter/foundation.dart';
import 'package:rubi_bank_api_sdk/rubi_bank_api_sdk.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rubi_bank_api_sdk/rubi_bank_api_sdk.dart';

final registerProvider = StateNotifierProvider<RegisterNotifier, RegisterState>(
  (ref) {
    return RegisterNotifier();
  },
);

class RegisterState {
  final Customer customer;
  final String password;
  final bool isLoading;
  final String? error;

  RegisterState({
    required this.customer,
    required this.password,
    this.isLoading = false,
    this.error,
  });

  RegisterState copyWith({
    Customer? customer,
    String? password,
    bool? isLoading,
    String? error,
  }) {
    return RegisterState(
      customer: customer ?? this.customer,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class RegisterNotifier extends StateNotifier<RegisterState> {
  RegisterNotifier()
    : super(
        RegisterState(
          customer: Customer(
            (b) => b
              ..givenName = ""
              ..familyName = ""
              ..nationality = "AE"
              ..email = ""
              ..idn = Idn(
                (b) => b
                  ..number = ""
                  ..type = "IdentityCard",
              ).toBuilder()
              ..phoneNumber = Phone(
                (b) => b
                  ..number = ""
                  ..countryCode = 971,
              ).toBuilder()
              ..residentialAddress = CustomerAddress(
                (b) => b
                  ..streetAddressLines = ListBuilder([""])
                  ..locality = "Dubai"
                  ..administrativeArea = ""
                  ..postalCode = ""
                  ..countryCode = "AE",
              ).toBuilder()
              ..state = CustomerStateEnum.CUSTOMER_STATE_PENDING_VERIFICATION
              ..kycStatus = CustomerKycStatusEnum.KYC_STATUS_NONE,
          ),
          password: "",
        ),
      );

  void updatePersonalInfo(String givenName, String familyName, String email) {
    state = state.copyWith(
      customer: state.customer.rebuild(
        (r) => r
          ..givenName = givenName
          ..familyName = familyName
          ..email = email,
      ),
    );
  }

  void updateIdentity(String nationality, String docType, String docNumber) {
    state = state.copyWith(
      customer: state.customer.rebuild(
        (r) => r
          ..nationality = nationality
          ..idn = Idn(
            (b) => b
              ..number = docNumber
              ..type = docType,
          ).toBuilder(),
      ),
    );
  }

  void updateAddress(CustomerAddress address) {
    state = state.copyWith(
      customer: state.customer.rebuild(
        (r) => r..residentialAddress = address.toBuilder(),
      ),
    );
  }

  void updatePhone(Phone phone) {
    state = state.copyWith(
      customer: state.customer.rebuild(
        (r) => r..phoneNumber = phone.toBuilder(),
      ),
    );
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password);
  }

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  void setError(String? error) {
    state = state.copyWith(error: error);
  }

  void reset() {
    state = RegisterState(
      customer: Customer(
        (b) => b
          ..givenName = ""
          ..familyName = ""
          ..nationality = "AE"
          ..email = ""
          ..idn = Idn(
            (b) => b
              ..number = ""
              ..type = "IdentityCard",
          ).toBuilder()
          ..phoneNumber = Phone(
            (b) => b
              ..number = ""
              ..countryCode = 971,
          ).toBuilder()
          ..residentialAddress = CustomerAddress(
            (b) => b
              ..streetAddressLines = ListBuilder([""])
              ..locality = ""
              ..administrativeArea = ""
              ..postalCode = ""
              ..countryCode = "AE",
          ).toBuilder()
          ..state = CustomerStateEnum.CUSTOMER_STATE_PENDING_VERIFICATION
          ..kycStatus = CustomerKycStatusEnum.KYC_STATUS_NONE,
      ),
      password: "",
    );
  }
}
