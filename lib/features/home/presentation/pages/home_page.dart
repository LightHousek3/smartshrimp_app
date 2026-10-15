import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/home/presentation/pages/owner_home_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Semantics(
    label: 'Trang chủ',
    container: true,
    child:
        ref.watch(authControllerProvider).value?.role == AccountRole.farmOwner
        ? const OwnerHomePage()
        : const AppGradientBackground(child: SizedBox.expand()),
  );
}
