import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';

class ProfileScreenHeader extends StatelessWidget {
  const ProfileScreenHeader({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      child: Row(
        children: <Widget>[
          Material(
            color: const Color(0xFFF5F8FC),
            shape: const CircleBorder(),
            child: IconButton(
              tooltip: 'Quay lại',
              onPressed: () => context.pop(),
              icon: const Icon(
                Icons.chevron_left_rounded,
                color: AppColors.inkSoft,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.ink,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
