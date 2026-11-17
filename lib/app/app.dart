import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:smartshrimp_app/app/router/app_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/config/app_config.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/notifications/presentation/view_models/push_providers.dart';

class SmartShrimpApp extends ConsumerStatefulWidget {
  const SmartShrimpApp({super.key});

  @override
  ConsumerState<SmartShrimpApp> createState() => _SmartShrimpAppState();
}

class _SmartShrimpAppState extends ConsumerState<SmartShrimpApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(pushStatusProvider.notifier).synchronize();
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    ref.listen(pushOpenedProvider, (_, next) {
      final id = next.asData?.value;
      if (id != null) {
        router.go('${AppRoutes.notifications}/${Uri.encodeComponent(id)}');
      }
    });
    ref.listen(pushEventsProvider, (_, next) {
      next.whenData(ref.read(pushStatusProvider.notifier).reportPermission);
      if (next.hasError) {
        ref
            .read(pushStatusProvider.notifier)
            .reportError(
              next.error is AppException
                  ? next.error! as AppException
                  : const ApiException('Chưa thể cập nhật thông báo thiết bị.'),
            );
      }
    });
    ref.watch(pushStatusProvider);
    return MaterialApp.router(
      title: AppConfig.appName,
      locale: const Locale('vi', 'VN'),
      supportedLocales: const [Locale('vi', 'VN')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: router,
    );
  }
}
