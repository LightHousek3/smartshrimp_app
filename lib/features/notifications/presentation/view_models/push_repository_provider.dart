import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/core/di/core_providers.dart';
import 'package:smartshrimp_app/features/notifications/data/repositories/push_repository_impl.dart';
import 'package:smartshrimp_app/features/notifications/data/services/push_api_service.dart';
import 'package:smartshrimp_app/features/notifications/data/services/push_messaging_service.dart';
import 'package:smartshrimp_app/features/notifications/domain/repositories/push_repository.dart';

final pushRepositoryProvider = Provider<PushRepository>((ref) {
  final repository = PushRepositoryImpl(
    PushApiService(
      ref.watch(apiClientProvider),
      ref.watch(sessionStoreProvider),
    ),
    PushMessagingService(),
  );
  ref.onDispose(() => unawaited(repository.dispose()));
  return repository;
});
