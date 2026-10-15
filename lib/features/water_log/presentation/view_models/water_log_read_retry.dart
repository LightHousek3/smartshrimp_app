import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';

/// Access denial needs an explicit retry after permissions have changed.
Duration? waterLogReadRetry(int retryCount, Object error) {
  if (error is AppException && error.statusCode == 403) return null;
  return ProviderContainer.defaultRetry(retryCount, error);
}
