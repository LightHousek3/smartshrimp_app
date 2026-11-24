import 'package:flutter/material.dart';
import 'package:smartshrimp_app/features/assigned_season/domain/entities/assigned_season_detail.dart';
import 'package:smartshrimp_app/features/season/presentation/widgets/season_progress.dart';

class AssignedSeasonProgress extends StatelessWidget {
  const AssignedSeasonProgress({required this.season, super.key});

  final AssignedSeasonDetail season;

  @override
  Widget build(BuildContext context) => SeasonProgress(
    status: season.status,
    stockingDate: season.stockingDate,
    expectedEndDate: season.expectedEndDate,
    dayOfCulture: season.dayOfCulture,
  );
}
