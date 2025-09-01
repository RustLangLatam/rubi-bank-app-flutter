// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accounts_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$accountsHash() => r'e4367cb06f2bab9eb4dd883b808f31bf5e6097ea';

/// See also [Accounts].
@ProviderFor(Accounts)
final accountsProvider =
    NotifierProvider<Accounts, AsyncValue<List<sdk.Account>>>.internal(
      Accounts.new,
      name: r'accountsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$accountsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Accounts = Notifier<AsyncValue<List<sdk.Account>>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
