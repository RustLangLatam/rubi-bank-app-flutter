import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rubi_bank_api_sdk/rubi_bank_api_sdk.dart';

import '../../../../data/providers/api_provider.dart';

part 'create_customer_provider.g.dart';

@riverpod
class CreateCustomer extends _$CreateCustomer {
  @override
  AsyncValue<Customer> build() {
    return const AsyncValue.loading();
  }

  Future<void> createCustomer({
    required Customer customer,
    required String password,
  }) async {
    state = const AsyncValue.loading();

    try {
      final customersApi = ref.read(customersApiProvider);

      _validateCustomerData(customer, password);

      final request = CreateCustomerRequestPayload(
            (b) => b
          ..customer = customer.toBuilder()
          ..password = password,
      );

      final response = await customersApi.createCustomer(
        createCustomerRequestPayload: request,
      );

      switch (response.statusCode) {
        case 201:
          if (response.data == null) {
            throw Exception('Customer created but no data returned');
          }
          state = AsyncValue.data(response.data!);
          break;
        case 400:
          throw Exception('Bad request: Invalid customer data');
        case 409:
          throw Exception('Customer already exists with this email or phone');
        case 500:
          throw Exception('Server error: Please try again later');
        default:
          throw Exception('Unexpected error: Status code ${response.statusCode}');
      }

    } on DioException catch (e) {
      final errorMessage = e.response?.data?['message'] ?? e.message ?? 'Unknown API error';
      final statusCode = e.response?.statusCode ?? 0;

      state = AsyncValue.error(
        Exception('API Error ($statusCode): $errorMessage'),
        StackTrace.current,
      );
    } catch (e) {
      state = AsyncValue.error(
        Exception(e.toString()),
        StackTrace.current,
      );
    }
  }

  void _validateCustomerData(Customer customer, String password) {
    if (customer.email.isEmpty || !customer.email.contains('@')) {
      throw Exception('Invalid email address');
    }

    if (customer.phoneNumber.number.isEmpty) {
      throw Exception('Phone number is required');
    }

    if (password.isEmpty || password.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }

    if (customer.givenName.isEmpty || customer.familyName.isEmpty) {
      throw Exception('First and last name are required');
    }
  }

  void reset() {
    state = const AsyncValue.loading();
  }
}