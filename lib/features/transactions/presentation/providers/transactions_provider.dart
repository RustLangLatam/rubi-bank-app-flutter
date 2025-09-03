import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rubi_bank_api_sdk/rubi_bank_api_sdk.dart' as sdk;

import '../../../../data/providers/api_provider.dart';

part 'transactions_provider.g.dart';

@Riverpod(keepAlive: true)
class Transactions extends _$Transactions {
  Timer? _pollingTimer;
  String? _currentAccountId;

  @override
  AsyncValue<List<sdk.Transaction>> build() {
    ref.onDispose(() {
      _pollingTimer?.cancel();
      _pollingTimer = null;
    });

    return const AsyncValue.loading();
  }

  Future<void> createTransaction({
    required sdk.Transaction transaction,
    required String accountId,
  }) async {
    debugPrint('Creating transaction for account: $accountId');
    debugPrint('Transaction type: ${transaction.type}');
    debugPrint('Transaction amount: ${transaction.amount}');

    state = const AsyncValue.loading();

    try {
      final transactionsApi = ref.read(transactionsApiProvider);

      final response = await transactionsApi.createTransaction(
        account: accountId,
        transaction: transaction,
      );

      switch (response.statusCode) {
        case 200:
          break;
        case 201:
          break;
        case 400:
          state = AsyncValue.error(
            TransactionApiException(
              'Bad request: Invalid transaction data',
              statusCode: 400,
            ),
            StackTrace.current,
          );
          return;
        case 404:
          state = AsyncValue.error(
            TransactionApiException('Account not found', statusCode: 404),
            StackTrace.current,
          );
          return;
        case 409:
          state = AsyncValue.error(
            TransactionAlreadyExistsException(),
            StackTrace.current,
          );
          return;
        case 500:
          state = AsyncValue.error(
            TransactionApiException(
              'Server error: Please try again later',
              statusCode: 500,
            ),
            StackTrace.current,
          );
          return;
        default:
          state = AsyncValue.error(
            TransactionApiException(
              'Unexpected error: Status code ${response.statusCode}',
              statusCode: response.statusCode,
            ),
            StackTrace.current,
          );
          return;
      }
    } on DioException catch (e) {
      debugPrint('DioException: ${e}');
      final errorMessage =
          e.response?.data?['message'] ?? e.message ?? 'Unknown API error';
      final statusCode = e.response?.statusCode ?? 0;

      String parsedMessage = _parseDioError(e, errorMessage.toString());

      state = AsyncValue.error(
        TransactionApiException(
          parsedMessage,
          statusCode: statusCode,
          errorData: e.response?.data,
        ),
        StackTrace.current,
      );
    } on TransactionException catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    } catch (e) {
      state = AsyncValue.error(
        TransactionException('Unexpected error: ${e.toString()}'),
        StackTrace.current,
      );
    }
  }

  Future<void> fetchAccountTransactions(String parentIdentifier) async {
    debugPrint('Fetching transactions for account: $parentIdentifier');

    _currentAccountId = parentIdentifier;

    state = const AsyncValue.loading();

    try {
      final transactionsApi = ref.read(transactionsApiProvider);

      final response = await transactionsApi.listTransactions(
        parentIdentifier: _currentAccountId,
          pageParamsPeriodOrder: 'ORDER_ASC',
      );

      if (response.statusCode == 200 && response.data?.transactions != null) {
        state = AsyncValue.data(response.data!.transactions?.toList() ?? []);
      } else {
        state = AsyncValue.error(
          TransactionApiException(
            'Failed to fetch transactions: Status code ${response.statusCode}',
            statusCode: response.statusCode,
          ),
          StackTrace.current,
        );
      }
    } on DioException catch (e) {
      debugPrint('DioException: ${e}');
      final errorMessage =
          e.response?.data?['message'] ?? e.message ?? 'Unknown API error';
      final statusCode = e.response?.statusCode ?? 0;

      String parsedMessage = _parseDioError(e, errorMessage.toString());

      state = AsyncValue.error(
        TransactionApiException(
          parsedMessage,
          statusCode: statusCode,
          errorData: e.response?.data,
        ),
        StackTrace.current,
      );
    } catch (e) {
      state = AsyncValue.error(
        TransactionException('Unexpected error: ${e.toString()}'),
        StackTrace.current,
      );
    }
  }

  void startPollingTransactions(String accountsIdentifier) {
    _currentAccountId ?? accountsIdentifier;
    _stopPolling(); // Stop any existing timer

    // Fetch immediately
    _fetchTransactionsInBackground();

    // Set up timer to poll every 3 seconds
    _pollingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _fetchTransactionsInBackground();
    });
  }

  void stopPolling() {
    _stopPolling();
    _currentAccountId = null;
  }

  void reset() {
    state = const AsyncValue.loading();
  }

  bool hasErrorType<T extends TransactionException>() {
    return state.hasError && state.error is T;
  }

  T? getError<T extends TransactionException>() {
    return state.hasError && state.error is T ? state.error as T : null;
  }

  List<sdk.Transaction> getTransactionsByType(sdk.TransactionTypeEnum type) {
    return state.valueOrNull
            ?.where((transaction) => transaction.type == type)
            .toList() ??
        [];
  }

  void _stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  Future<void> _fetchTransactionsInBackground() async {
    if (_currentAccountId == null) return;

    // debugPrint('Fetching transactions for account: $_currentAccountId');

    try {
      final transactionsApi = ref.read(transactionsApiProvider);

      final response = await transactionsApi.listTransactions(
        parentIdentifier: _currentAccountId,
        pageParamsPeriodOrder: 'ORDER_DESC',
      );

      if (response.statusCode == 200 && response.data?.transactions != null) {
        final newTransactions = response.data!.transactions?.toList() ?? [];

        // Update state only if we have new data
        if (!_areTransactionsEqual(state.valueOrNull, newTransactions)) {
          state = AsyncValue.data(newTransactions);
        }
      }
    } on DioException catch (e) {
      debugPrint('Background polling error: ${e.message}');
      // Don't update state on background errors to avoid UI disruption
    } catch (e) {
      debugPrint('Unexpected background error: $e');
    }
  }

  bool _areTransactionsEqual(
    List<sdk.Transaction>? current,
    List<sdk.Transaction>? newTransactions,
  ) {
    if (current == null || newTransactions == null) return false;
    if (current.length != newTransactions.length) return false;

    for (int i = 0; i < current.length; i++) {
      if (current[i].name != newTransactions[i].name) return false;
    }
    return true;
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

  List<sdk.Transaction> getTransactionsByState(
    sdk.TransactionStateEnum status,
  ) {
    return state.valueOrNull
            ?.where((transaction) => transaction.state == status)
            .toList() ??
        [];
  }
}

class TransactionException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic errorData;

  TransactionException(this.message, {this.statusCode, this.errorData});

  @override
  String toString() =>
      'TransactionException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

class TransactionValidationException extends TransactionException {
  TransactionValidationException(super.message);
}

class TransactionApiException extends TransactionException {
  TransactionApiException(super.message, {super.statusCode, super.errorData});
}

class TransactionAlreadyExistsException extends TransactionApiException {
  TransactionAlreadyExistsException()
    : super('Transaction already exists', statusCode: 409);
}
