import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rubi_bank_api_sdk/rubi_bank_api_sdk.dart' as sdk;

import '../../../../data/providers/api_provider.dart';

part 'accounts_provider.g.dart';

@Riverpod(keepAlive: true)
class Accounts extends _$Accounts {
  @override
  AsyncValue<List<sdk.Account>> build() {
    return const AsyncValue.loading();
  }

  Future<void> createAccount({
    required sdk.Account account,
    required String customerId,
  }) async {
    debugPrint('Creating account for customer: $customerId');
    debugPrint('Account type: ${account.accountDetails?.type}');
    debugPrint('Account display name: ${account.displayName}');

    state = const AsyncValue.loading();

    try {
      final accountsApi = ref.read(accountsApiProvider);

      final request = sdk.CreateAccountRequestPayload(
        (a) => a
          ..account = account.toBuilder()
          ..parentIdentifier = customerId,
      );

      final response = await accountsApi.createAccount(
        createAccountRequestPayload: request,
      );

      switch (response.statusCode) {
        case 200:
          final currentAccounts = state.valueOrNull ?? [];
          state = AsyncValue.data([...currentAccounts, response.data!]);
          break;
        case 201:
          if (response.data == null) {
            state = AsyncValue.error(
              AccountApiException('Account created but no data returned', statusCode: response.statusCode),
              StackTrace.current,
            );
            return;
          }

          // Add the new account to the current list
          final currentAccounts = state.valueOrNull ?? [];
          state = AsyncValue.data([...currentAccounts, response.data!]);
          break;
        case 400:
          state = AsyncValue.error(
            AccountApiException('Bad request: Invalid account data', statusCode: 400),
            StackTrace.current,
          );
          return;
        case 404:
          state = AsyncValue.error(
            AccountApiException('Customer not found', statusCode: 404),
            StackTrace.current,
          );
          return;
        case 409:
          state = AsyncValue.error(
            AccountAlreadyExistsException(),
            StackTrace.current,
          );
          return;
        case 500:
          state = AsyncValue.error(
            AccountApiException('Server error: Please try again later', statusCode: 500),
            StackTrace.current,
          );
          return;
        default:
          state = AsyncValue.error(
            AccountApiException('Unexpected error: Status code ${response.statusCode}', statusCode: response.statusCode),
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
        AccountApiException(parsedMessage, statusCode: statusCode, errorData: e.response?.data),
        StackTrace.current,
      );
    } on AccountException catch (e) {
      // Handle custom exceptions without rethrowing
      state = AsyncValue.error(e, StackTrace.current);
    } catch (e) {
      state = AsyncValue.error(
        AccountException('Unexpected error: ${e.toString()}'),
        StackTrace.current,
      );
    }
  }

  Future<void> fetchCustomerAccounts(String customerId) async {
    debugPrint('Fetching accounts for customer: $customerId');

    state = const AsyncValue.loading();

    try {
      final accountsApi = ref.read(accountsApiProvider);

      final response = await accountsApi.listAccounts(
        filterPeriodCustomerIdentifier: customerId
      );

      if (response.statusCode == 200 && response.data != null) {
        state = AsyncValue.data(response.data!.accounts?.toList() ?? []);
      } else {
        state = AsyncValue.error(
          AccountApiException('Failed to fetch accounts: Status code ${response.statusCode}', statusCode: response.statusCode),
          StackTrace.current,
        );
      }

    } on DioException catch (e) {
      debugPrint('DioException: ${e}');
      final errorMessage = e.response?.data?['message'] ?? e.message ?? 'Unknown API error';
      final statusCode = e.response?.statusCode ?? 0;

      String parsedMessage = _parseDioError(e, errorMessage.toString());

      state = AsyncValue.error(
        AccountApiException(parsedMessage, statusCode: statusCode, errorData: e.response?.data),
        StackTrace.current,
      );
    } catch (e) {
      state = AsyncValue.error(
        AccountException('Unexpected error: ${e.toString()}'),
        StackTrace.current,
      );
    }
  }

  Future<void> updateAccount({
    required String accountId,
    required sdk.Account account,
  }) async {
    debugPrint('Updating account: $accountId');

    try {
      final accountsApi = ref.read(accountsApiProvider);

      final response = await accountsApi.updateAccount(
        account: accountId,
        account2: account,
      );

      if (response.statusCode == 200 && response.data != null) {
        // Update the account in the list
        final currentAccounts = state.valueOrNull ?? [];
        final updatedAccounts = currentAccounts.map((a) =>
        a.name == accountId ? response.data! : a
        ).toList();

        state = AsyncValue.data(updatedAccounts);
      } else {
        throw AccountApiException('Failed to update account: Status code ${response.statusCode}', statusCode: response.statusCode);
      }

    } on DioException catch (e) {
      debugPrint('DioException: ${e}');
      final errorMessage = e.response?.data?['message'] ?? e.message ?? 'Unknown API error';
      final statusCode = e.response?.statusCode ?? 0;

      String parsedMessage = _parseDioError(e, errorMessage.toString());

      throw AccountApiException(parsedMessage, statusCode: statusCode, errorData: e.response?.data);
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
  bool hasErrorType<T extends AccountException>() {
    return state.hasError && state.error is T;
  }

  // Helper method to get specific error
  T? getError<T extends AccountException>() {
    return state.hasError && state.error is T ? state.error as T : null;
  }

  // // Helper method to get account by ID
  // sdk.Account? getAccountById(String accountId) {
  //   return state.valueOrNull?.firstWhere(
  //         (account) => account.id == accountId,
  //     orElse: () => null,
  //   );
  // }

  // Helper method to get accounts by type
  List<sdk.Account> getAccountsByType(sdk.AccountDetailsTypeEnum type) {
    return state.valueOrNull?.where(
          (account) => account.accountDetails?.type == type,
    ).toList() ?? [];
  }

  // // Helper method to get primary account (e.g., first savings account)
  // sdk.Account? getPrimaryAccount() {
  //   return state.valueOrNull?.firstWhere(
  //         (account) => account.accountDetails?.type == sdk.AccountDetailsTypeEnum.ACCOUNT_TYPE_SAVINGS,
  //     orElse: () => state.valueOrNull?.isNotEmpty == true ? state.valueOrNull!.first : null,
  //   );
  // }
}

// Custom exceptions for better error handling
class AccountException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic errorData;

  AccountException(this.message, {this.statusCode, this.errorData});

  @override
  String toString() => 'AccountException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

class AccountValidationException extends AccountException {
  AccountValidationException(super.message);
}

class AccountApiException extends AccountException {
  AccountApiException(super.message, {super.statusCode, super.errorData});
}

class AccountAlreadyExistsException extends AccountApiException {
  AccountAlreadyExistsException() : super('Account already exists for this customer', statusCode: 409);
}