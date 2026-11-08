import 'package:smartshrimp_app/features/water_log/domain/entities/water_log.dart';

Map<String, dynamic> statisticsJson({bool counts = true, bool empty = false}) =>
    {
      'seasonId': 'season',
      'from': '2026-01-01T00:00:00Z',
      'to': '2026-05-01T00:00:00Z',
      'granularity': 'day',
      'summary': {
        'totalRecords': empty ? 0 : 13,
        'validRecords': empty ? 0 : 11,
        'voidedRecords': empty ? 0 : 2,
        'parameters': <String, dynamic>{
          if (!empty) ...{
            'dissolvedOxygenMgL': {
              'count': 10,
              'min': 3,
              'max': 9,
              'avg': 6.37,
              'exceedanceRate': .4,
              if (counts) 'exceedCount': 4,
              if (counts) ...{
                'belowMinCount': 4,
                'aboveMaxCount': 0,
                'belowMinRate': .4,
                'aboveMaxRate': 0,
              },
            },
            'ph': {
              'count': 7,
              'min': 7,
              'max': 9,
              'avg': 8.12,
              'exceedanceRate': 2 / 7,
              if (counts) 'exceedCount': 2,
              if (counts) ...{
                'belowMinCount': 1,
                'aboveMaxCount': 1,
                'belowMinRate': 1 / 7,
                'aboveMaxRate': 1 / 7,
              },
            },
          },
        },
      },
      'series': [
        if (!empty)
          for (var i = 0; i < 3; i++)
            {
              'bucket': '2026-01-0${i + 1}',
              'dissolvedOxygenMgL': {
                'count': 2,
                'avg': 5 + i,
                'min': 3 + i,
                'max': 7 + i,
              },
            },
      ],
    };

WaterLogStatistics sampleStatistics({bool counts = true, bool empty = false}) =>
    WaterLogStatistics.parse(statisticsJson(counts: counts, empty: empty));
