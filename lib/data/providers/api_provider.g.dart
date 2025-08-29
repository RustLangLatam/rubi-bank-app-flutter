// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$rubiBankApiHash() => r'f3d1f918bfdcd3c104c17c35e8c49cc6141931cd';

/// ✅ **Provider to get the RubiBank API (uses global baseUrlProvider)**
///
/// Copied from [rubiBankApi].
@ProviderFor(rubiBankApi)
final rubiBankApiProvider = Provider<RubiBankApiSdk>.internal(
  rubiBankApi,
  name: r'rubiBankApiProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$rubiBankApiHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RubiBankApiRef = ProviderRef<RubiBankApiSdk>;
String _$customersApiHash() => r'e00a7dcf6135065a76d2e677b4fe895b372eb4ff';

/// ✅ **Provider Customers API**
///
/// Copied from [customersApi].
@ProviderFor(customersApi)
final customersApiProvider = Provider<CustomersServiceApi>.internal(
  customersApi,
  name: r'customersApiProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$customersApiHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CustomersApiRef = ProviderRef<CustomersServiceApi>;
String _$accountsApiHash() => r'2011b09c3b002adabf30d05c36c2d0b4a04a111a';

/// ✅ **Provider to get the Accounts API**
///
/// Copied from [accountsApi].
@ProviderFor(accountsApi)
final accountsApiProvider = Provider<AccountsServiceApi>.internal(
  accountsApi,
  name: r'accountsApiProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$accountsApiHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AccountsApiRef = ProviderRef<AccountsServiceApi>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
