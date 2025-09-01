import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rubi_bank_api_sdk/rubi_bank_api_sdk.dart';

part 'api_provider.g.dart';

const baseApiUrl = 'http://244.178.44.111';

/// ✅ **Global State for API Base URL**
final baseUrlProvider = StateProvider<String>((ref) => baseApiUrl);

/// ✅ **Provider to get the RubiBank API (uses global baseUrlProvider)**
@Riverpod(keepAlive: true)
RubiBankApiSdk rubiBankApi(Ref ref) {
  final baseUrl = ref.watch(baseUrlProvider);
  return RubiBankApiSdk(basePathOverride: baseUrl);
}

/// ✅ **Provider Customers API**
@Riverpod(keepAlive: true)
CustomersServiceApi customersApi(Ref ref) {
  final api = ref.watch(rubiBankApiProvider);
  return api.getCustomersServiceApi();
}

/// ✅ **Provider to get the Accounts API**
@Riverpod(keepAlive: true)
AccountsServiceApi accountsApi(Ref ref) {
  final api = ref.watch(rubiBankApiProvider);
  return api.getAccountsServiceApi();
}

/// ✅ **Provider to get the Transactions API**
@Riverpod(keepAlive: true)
TransactionsServiceApi transactionsApi(Ref ref) {
  final api = ref.watch(rubiBankApiProvider);
  return api.getTransactionsServiceApi();
}


/// ✅ **Function to Initialize All API Providers with a Custom Base URL**
void initializeApiProviders(
  ProviderContainer container, {
  required String apiKey,
  required String baseUrl,
}) {
  container.read(baseUrlProvider.notifier).state = baseUrl;
  final rubiBankApi = container.read(rubiBankApiProvider);
  rubiBankApi.setApiKey('ApiKey', apiKey);

  container.read(customersApiProvider);
  container.read(accountsApiProvider);
  container.read(transactionsApiProvider);
}
