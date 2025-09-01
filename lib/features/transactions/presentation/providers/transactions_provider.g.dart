// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$transactionsHash() => r'138bddf11b1f931df292ccb50244eedc9811554e';

/// See also [Transactions].
@ProviderFor(Transactions)
final transactionsProvider =
    NotifierProvider<Transactions, AsyncValue<List<sdk.Transaction>>>.internal(
      Transactions.new,
      name: r'transactionsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$transactionsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Transactions = Notifier<AsyncValue<List<sdk.Transaction>>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
