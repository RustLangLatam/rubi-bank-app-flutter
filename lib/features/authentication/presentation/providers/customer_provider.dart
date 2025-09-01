import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rubi_bank_api_sdk/rubi_bank_api_sdk.dart' as sdk;

import '../../../../data/providers/api_provider.dart';

part 'customer_provider.g.dart';

@Riverpod(keepAlive: true)
class Customer extends _$Customer {
  @override
  AsyncValue<sdk.Customer> build() {
    return const AsyncValue.loading();
  }

  Future<void> createCustomer({
    required sdk.Customer customer,
    required String password,
  }) async {
    debugPrint(
      'Creating customer: ${customer.givenName} ${customer.familyName}',
    );

    state = const AsyncValue.loading();

    try {
      final customersApi = ref.read(customersApiProvider);

      _validateCustomerData(customer, password);

      final request = sdk.CreateCustomerRequestPayload(
        (b) => b
          ..customer = customer.toBuilder()
          ..password = password,
      );

      final response = await customersApi.createCustomer(
        createCustomerRequestPayload: request,
      );

      switch (response.statusCode) {
        case 200:
          debugPrint('Customer created successfully: ${response.data!.name}');
          if (response.data == null) {
            throw CustomerApiException(
              'Customer created successfully but no data returned in response',
              statusCode: 200,
            );
          }
          state = AsyncValue.data(response.data!);
          break;
        case 201:
          if (response.data == null) {
            state = AsyncValue.error(
              CustomerApiException('Customer created but no data returned', statusCode: 201),
              StackTrace.current,
            );
            return;
          }
          state = AsyncValue.data(response.data!);
          break;
        case 400:
          state = AsyncValue.error(
            CustomerApiException(
              'Bad request: Invalid customer data',
              statusCode: 400,
            ),
            StackTrace.current,
          );
          return;
        case 409:
          state = AsyncValue.error(
            CustomerAlreadyExistsException(),
            StackTrace.current,
          );
          return;
        case 500:
          state = AsyncValue.error(
            CustomerApiException(
              'Server error: Please try again later',
              statusCode: 500,
            ),
            StackTrace.current,
          );
          return;
        default:
          state = AsyncValue.error(
            CustomerApiException(
              'Unexpected error: Status code ${response.statusCode}',
              statusCode: response.statusCode,
            ),
            StackTrace.current,
          );
          return;
      }
    } on DioException catch (e) {
      debugPrint('DioException: ${e}');
      final errorMessage = e.response?.data?['message'] ?? e.message ?? 'Unknown API error';
      final statusCode = e.response?.statusCode ?? 0;

      String parsedMessage = _parseDioError(e, errorMessage.toString());

      state = AsyncValue.error(
        CustomerApiException(parsedMessage, statusCode: statusCode, errorData: e.response?.data),
        StackTrace.current,
      );
    } on CustomerException catch (e) {
      // Handle custom exceptions without rethrowing
      state = AsyncValue.error(e, StackTrace.current);
    } catch (e) {
      state = AsyncValue.error(
        CustomerException('Unexpected error: ${e.toString()}'),
        StackTrace.current,
      );
    }
  }

  Future<void> loginCustomer(String email, String password) async {
    debugPrint('Logging in customer: $email');

    state = const AsyncValue.loading();
    try {
      final customersApi = ref.read(customersApiProvider);
      final request = sdk.LoginCustomerRequest(
        (b) => b
          ..oneOf = sdk.OneOf1(
            value: sdk.EmailPasswordCreds(
              (b) => b
                ..email = email
                ..password = password,
            ),
          ),
      );

      final response = await customersApi.loginCustomer(
        loginCustomerRequest: request,
      );

      switch (response.statusCode) {
        case 200:
          final data = response.data!;

          if (data.customer == null) {
            state = AsyncValue.error(
              CustomerApiException(
                'Login successful but no customer data returned',
                statusCode: 200,
              ),
              StackTrace.current,
            );
            return;
          }

          if (data.tokens == null ||
              data.tokens!.accessToken == null ||
              data.tokens!.refreshToken == null) {
            state = AsyncValue.error(
              CustomerApiException(
                'Login successful but no tokens returned',
                statusCode: 200,
              ),
              StackTrace.current,
            );
            return;
          }

          state = AsyncValue.data(data.customer!);

          final tokens = data.tokens!;

          ref
              .read(rubiBankApiProvider)
              .setBearerAuth('Authorization', tokens.accessToken!.value!);
          ref
              .read(rubiBankApiProvider)
              .setBearerAuth('Refresh', tokens.refreshToken!.value!);

          await _saveTokens(tokens);
          break;

        case 400:
          state = AsyncValue.error(
            CustomerApiException(
              'Invalid email or password format',
              statusCode: 400,
            ),
            StackTrace.current,
          );
          break;

        case 401:
          state = AsyncValue.error(
            CustomerApiException('Invalid email or password', statusCode: 401),
            StackTrace.current,
          );
          break;

        case 403:
          state = AsyncValue.error(
            CustomerApiException(
              'Account disabled or access denied',
              statusCode: 403,
            ),
            StackTrace.current,
          );
          break;

        case 404:
          state = AsyncValue.error(
            CustomerApiException('Customer not found', statusCode: 404),
            StackTrace.current,
          );
          break;

        case 429:
          state = AsyncValue.error(
            CustomerApiException(
              'Too many login attempts. Please try again later',
              statusCode: 429,
            ),
            StackTrace.current,
          );
          break;

        case 500:
          state = AsyncValue.error(
            CustomerApiException(
              'Server error. Please try again later',
              statusCode: 500,
            ),
            StackTrace.current,
          );
          break;

        default:
          state = AsyncValue.error(
            CustomerApiException(
              'Unexpected error: Status code ${response.statusCode}',
              statusCode: response.statusCode,
            ),
            StackTrace.current,
          );
          break;
      }
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data?['message'] ?? e.message ?? 'Network error occurred';
      final statusCode = e.response?.statusCode ?? 0;

      String parsedMessage = _parseDioError(e, errorMessage.toString());

      state = AsyncValue.error(
        CustomerApiException(
          parsedMessage,
          statusCode: statusCode,
          errorData: e.response?.data,
        ),
        StackTrace.current,
      );
    } on CustomerException catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    } catch (e) {
      state = AsyncValue.error(
        CustomerException('Unexpected error during login: ${e.toString()}'),
        StackTrace.current,
      );
    }
  }

  Future<void> _saveTokens(sdk.AuthorizationTokens tokens) async {
    try {
      // final secureStorage = ref.read(secureStorageProvider);
      // await secureStorage.write('access_token', tokens.accessToken!.value!);
      // await secureStorage.write('refresh_token', tokens.refreshToken!.value!);
      // await secureStorage.write('access_token_expiry', tokens.accessToken!.expiresAt?.toIso8601String() ?? '');

      debugPrint('Tokens received and stored');
    } catch (e) {
      debugPrint('Error saving tokens: $e');
    }
  }

  Future<void> logoutCustomer() async {
    try {
      ref.read(rubiBankApiProvider).setBearerAuth('Authorization', '');
      ref.read(rubiBankApiProvider).setBearerAuth('Refresh', '');

      // final secureStorage = ref.read(secureStorageProvider);
      // await secureStorage.delete('access_token');
      // await secureStorage.delete('refresh_token');
      // await secureStorage.delete('access_token_expiry');

      state = const AsyncValue.loading();
    } catch (e) {
      debugPrint('Error during logout: $e');
      state = const AsyncValue.loading();
    }
  }

  bool isAuthenticated() {
    return state.hasValue && state.value != null;
  }

  String? getAccessToken() {
    return null;
  }

  Future<void> refreshToken() async {
    try {
      final refreshToken = '';
      if (refreshToken.isEmpty) {
        throw CustomerApiException('No refresh token available');
      }

      final customersApi = ref.read(customersApiProvider);
      final response = await customersApi.refreshTokenCustomer();

      if (response.statusCode == 200 && response.data != null) {
        final newAccessToken = response.data!.newAccessToken;
        if (newAccessToken != null) {
          ref
              .read(rubiBankApiProvider)
              .setBearerAuth('Authorization', newAccessToken.value!);
          // await ref.read(secureStorageProvider).write('access_token', newAccessToken.value!);
          // if (newAccessToken.expiresAt != null) {
          //   await ref.read(secureStorageProvider).write('access_token_expiry', newAccessToken.expiresAt!.toIso8601String());
          // }
        }
      } else {
        throw CustomerApiException('Failed to refresh token');
      }
    } catch (e) {
      await logoutCustomer();
      rethrow;
    }
  }

  void _validateCustomerData(sdk.Customer customer, String password) {
    if (customer.email.isEmpty || !customer.email.contains('@')) {
      throw CustomerValidationException('Invalid email address');
    }

    if (customer.phoneNumber.number.isEmpty) {
      throw CustomerValidationException('Phone number is required');
    }

    if (password.isEmpty || password.length < 6) {
      throw CustomerValidationException(
        'Password must be at least 6 characters',
      );
    }

    if (customer.givenName.isEmpty || customer.familyName.isEmpty) {
      throw CustomerValidationException('First and last name are required');
    }
  }

  String _parseDioError(DioException e, String defaultMessage) {
    try {
      if (e.response?.data is Map<String, dynamic>) {
        final data = e.response!.data as Map<String, dynamic>;

        if (data.containsKey('message')) {
          return data['message'].toString();
        }

        if (data.containsKey('error')) {
          return data['error'].toString();
        }

        if (data.containsKey('details') && data['details'] is String) {
          return data['details'].toString();
        }
      }
    } catch (_) {
      // If parsing fails, use default message
    }

    return defaultMessage;
  }

  void reset() {
    state = const AsyncValue.loading();
  }

  // Helper method to check for specific error types
  bool hasErrorType<T extends CustomerException>() {
    return state.hasError && state.error is T;
  }

  // Helper method to get specific error
  T? getError<T extends CustomerException>() {
    return state.hasError && state.error is T ? state.error as T : null;
  }
}

// Custom exceptions for better error handling
class CustomerException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic errorData;

  CustomerException(this.message, {this.statusCode, this.errorData});

  @override
  String toString() =>
      'CustomerException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

class CustomerValidationException extends CustomerException {
  CustomerValidationException(super.message);
}

class CustomerApiException extends CustomerException {
  CustomerApiException(super.message, {super.statusCode, super.errorData});
}

class CustomerAlreadyExistsException extends CustomerApiException {
  CustomerAlreadyExistsException()
    : super(
        'Customer already exists with this email or phone',
        statusCode: 409,
      );
}
