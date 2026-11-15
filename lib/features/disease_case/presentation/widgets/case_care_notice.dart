import 'package:flutter/material.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';

/// Share the server-reported production suspension notice between Owner and technician views.
class CaseCareNotice extends StatelessWidget {
  const CaseCareNotice({super.key});

  @override
  Widget build(BuildContext context) {
    final visual = appNoticeVisualFor(AppNoticeLevel.warning);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: visual.background,
        border: Border.all(color: visual.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(visual.icon, color: visual.foreground, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Phác đồ nuôi đang tạm hoãn',
              style: TextStyle(
                color: visual.foreground,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
