import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/gradient_button.dart';
import 'package:smartshrimp_app/features/assigned_season/domain/entities/assigned_season.dart';
import 'package:smartshrimp_app/features/assigned_season/domain/entities/assigned_season_detail.dart';
import 'package:smartshrimp_app/features/assigned_season/domain/repositories/assigned_season_repository.dart';
import 'package:smartshrimp_app/features/assigned_season/presentation/view_models/assigned_season_controller.dart';
import 'package:smartshrimp_app/features/season/domain/entities/aquaculture_season.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log_metadata.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log_threshold.dart';
import 'package:smartshrimp_app/features/water_log/domain/repositories/water_log_repository.dart';
import 'package:smartshrimp_app/features/water_log/presentation/view_models/water_log_controller.dart';
import 'package:smartshrimp_app/features/water_log/presentation/widgets/water_log_form_sheet.dart';

Future<void> _open(
  WidgetTester tester,
  _Repository repository, {
  String apiShrimpType = 'BLACK_TIGER',
  bool failSeason = false,
  Size size = const Size(402, 875),
}) async {
  GoogleFonts.config.allowRuntimeFetching = false;
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        waterLogRepositoryProvider.overrideWithValue(repository),
        assignedSeasonRepositoryProvider.overrideWithValue(
          _Seasons(apiShrimpType, fail: failSeason),
        ),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () =>
                  showWaterLogFormSheet(context: context, seasonId: 'season'),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('Open'));
  await tester.pumpAndSettle();
  await tester.runAsync(() => GoogleFonts.pendingFonts());
  await tester.pumpAndSettle();
}

Future<void> _save(WidgetTester tester) async {
  await tester.tap(find.text('Lưu nhật ký'));
  await tester.pumpAndSettle();
}

void main() {
  for (final fail in [false, true]) {
    testWidgets(
      'pending create blocks dismissal and then resolves: fail=$fail',
      (tester) async {
        final repository = _PendingRepository();
        await _open(tester, repository);
        await tester.enterText(find.byType(TextField).at(1), '8');
        await tester.tap(find.text('Lưu nhật ký'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        expect(repository.calls, 1);
        await tester.binding.handlePopRoute();
        await tester.tapAt(const Offset(5, 5));
        await tester.drag(
          find.byKey(const Key('water_log_form_sheet')),
          const Offset(0, 500),
        );
        await tester.pump();
        expect(find.byKey(const Key('water_log_form_sheet')), findsOneWidget);
        if (fail) {
          repository.pending.completeError(
            const ApiException('Không lưu được mẫu đo.', statusCode: 409),
          );
          await tester.pumpAndSettle();
          expect(find.text('Không lưu được mẫu đo.'), findsOneWidget);
          expect(find.byType(SnackBar), findsNothing);
          await tester.binding.handlePopRoute();
          await tester.pumpAndSettle();
          expect(find.byKey(const Key('water_log_form_sheet')), findsNothing);
        } else {
          repository.pending.complete(
            WaterLog(
              id: 'saved',
              seasonId: 'season',
              recordedAt: DateTime(2026),
              createdAt: DateTime(2026),
              isVoided: false,
              exceededParameters: [],
            ),
          );
          await tester.pumpAndSettle();
          expect(find.byKey(const Key('water_log_form_sheet')), findsNothing);
          expect(find.text('Đã lưu nhật ký đo nước.'), findsOneWidget);
        }
        expect(tester.takeException(), isNull);
      },
    );
  }
  for (final invalid in ['-1', '-0,1', '1abc2', '1.2.3']) {
    testWidgets(
      'invalid pasted input $invalid is preserved and blocks saving',
      (tester) async {
        final repository = _Repository();
        await _open(tester, repository);
        final field = find.byType(TextField).at(2);
        await tester.enterText(field, invalid);
        await tester.pump();
        final input = tester.widget<TextField>(field);
        expect(input.controller!.text, invalid);
        expect(input.decoration!.errorText, isNotNull);
        expect(
          tester.widget<GradientButton>(find.byType(GradientButton)).onPressed,
          isNull,
        );
        expect(repository.payloads, isEmpty);
        await tester.enterText(field, '4,5');
        await tester.pump();
        expect(tester.widget<TextField>(field).decoration!.errorText, isNull);
        await _save(tester);
        expect(repository.payloads.single['dissolvedOxygenMgL'], 4.5);
        expect(tester.takeException(), isNull);
      },
    );
  }

  for (final error in [
    const ApiException('Metadata not found', statusCode: 404),
    const ApiException('Không có quyền đọc vụ', statusCode: 403),
    const ApiException('Máy chủ tạm lỗi', statusCode: 500),
    const InvalidResponseException(),
  ]) {
    testWidgets(
      'metadata failure $error keeps the form and blocks POST until retry',
      (tester) async {
        final repository = _Repository()..metadataError = error;
        await _open(tester, repository);
        await tester.enterText(find.byType(TextField).first, '28');
        await _save(tester);
        expect(repository.payloads, isEmpty);
        expect(find.text(error.message), findsOneWidget);
        expect(
          tester
              .widget<TextField>(find.byType(TextField).first)
              .controller!
              .text,
          '28',
        );
        repository.metadataError = null;
        await _save(tester);
        expect(repository.payloads.single['temperatureC'], 28);
      },
    );
  }
  testWidgets(
    'future timestamp is sent to BE; its error preserves form and retry key',
    (tester) async {
      const error = ApiException(
        'Thời điểm đo không được vượt quá hiện tại 5 phút',
        statusCode: 400,
      );
      final repository = _Repository()..createError = error;
      await _open(tester, repository);
      await tester.enterText(find.byType(TextField).first, '28');
      await tester.tap(find.textContaining('Thời điểm đo:'));
      await tester.pumpAndSettle();
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      await tester.tap(find.text('${tomorrow.day}').last);
      await tester.tap(find.text('OK').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK').last);
      await tester.pumpAndSettle();
      await _save(tester);
      expect(repository.payloads, hasLength(1));
      final timestamp = repository.payloads.single['recordedAt'] as String;
      expect(timestamp.endsWith('Z'), isTrue);
      expect(
        DateTime.parse(
          timestamp,
        ).isAfter(DateTime.now().add(const Duration(minutes: 5))),
        isTrue,
      );
      expect(find.text(error.message), findsOneWidget);
      expect(
        tester.widget<TextField>(find.byType(TextField).first).controller!.text,
        '28',
      );
      await _save(tester);
      expect(repository.keys, hasLength(2));
      expect(repository.keys[0], repository.keys[1]);
      expect(repository.payloads[0], repository.payloads[1]);
      // A server whose clock is ahead may accept the same device-future timestamp.
      repository.createError = null;
      await _save(tester);
      expect(repository.keys[2], repository.keys[0]);
      expect(repository.payloads[2], repository.payloads[0]);
      expect(find.byKey(const Key('water_log_form_sheet')), findsNothing);
    },
  );
  testWidgets('server policy controls the warning dialog before saving', (
    tester,
  ) async {
    final legacy = WaterLogMetadata.legacy(ShrimpType.whiteleg);
    final repository = _Repository()
      ..metadata = legacy.copyWith(
        metrics: [
          for (final metric in legacy.metrics)
            metric.field == 'temperatureC'
                ? metric.copyWith(warningMax: 28)
                : metric,
        ],
      );
    await _open(tester, repository);
    await tester.enterText(find.byType(TextField).first, '29');
    await _save(tester);
    expect(find.byKey(const Key('water_log_warning_dialog')), findsOneWidget);
    expect(repository.payloads, isEmpty);
  });
  testWidgets('preview and submitted value use the persisted decimal scale', (
    tester,
  ) async {
    final repository = _Repository()
      ..metadata = WaterLogMetadata.legacy(ShrimpType.whiteleg);
    await _open(tester, repository);
    await tester.enterText(find.byType(TextField).at(1), '8.504');
    await _save(tester);
    expect(find.byKey(const Key('water_log_warning_dialog')), findsNothing);
    expect(repository.payloads.single['ph'], 8.5);
  });
  testWidgets(
    'metadata network failure keeps input and never bypasses the warning step',
    (tester) async {
      final repository = _Repository()
        ..metadataError = const NetworkException();
      await _open(tester, repository);
      await tester.enterText(find.byType(TextField).first, '34');
      await _save(tester);
      expect(repository.payloads, isEmpty);
      expect(
        tester.widget<TextField>(find.byType(TextField).first).controller!.text,
        '34',
      );
      expect(find.text(const NetworkException().message), findsOneWidget);
    },
  );
  testWidgets(
    'validates ranges while typing and unlocks save after correction',
    (tester) async {
      final repository = _Repository();
      await _open(tester, repository);
      await tester.enterText(find.byType(TextField).at(0), '50.1');
      await tester.enterText(find.byType(TextField).at(1), '14.1');
      await tester.pump();
      expect(
        tester
            .widget<TextField>(find.byType(TextField).at(0))
            .decoration!
            .errorText,
        '0 – 50 °C',
      );
      expect(
        tester
            .widget<TextField>(find.byType(TextField).at(1))
            .decoration!
            .errorText,
        '0 – 14',
      );
      expect(
        tester.widget<GradientButton>(find.byType(GradientButton)).onPressed,
        isNull,
      );
      expect(repository.payloads, isEmpty);
      await tester.enterText(find.byType(TextField).at(0), '50');
      await tester.enterText(find.byType(TextField).at(1), '14');
      await tester.pump();
      expect(
        tester
            .widget<TextField>(find.byType(TextField).at(0))
            .decoration!
            .errorText,
        isNull,
      );
      expect(
        tester
            .widget<TextField>(find.byType(TextField).at(1))
            .decoration!
            .errorText,
        isNull,
      );
      expect(
        tester.widget<GradientButton>(find.byType(GradientButton)).onPressed,
        isNotNull,
      );
      await _save(tester);
      expect(find.byKey(const Key('water_log_warning_dialog')), findsOneWidget);
      expect(repository.payloads, isEmpty);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'malformed decimal clears on edit and empty optional fields stay valid',
    (tester) async {
      final repository = _Repository();
      await _open(tester, repository);
      await tester.enterText(find.byType(TextField).at(1), '7..5');
      await tester.pump();
      expect(
        tester
            .widget<TextField>(find.byType(TextField).at(1))
            .decoration!
            .errorText,
        'Số không hợp lệ',
      );
      expect(
        tester.widget<GradientButton>(find.byType(GradientButton)).onPressed,
        isNull,
      );
      await tester.enterText(find.byType(TextField).at(1), '');
      await tester.enterText(find.byType(TextField).at(2), '4,5');
      await tester.pump();
      expect(
        tester
            .widget<TextField>(find.byType(TextField).at(1))
            .decoration!
            .errorText,
        isNull,
      );
      expect(
        tester.widget<GradientButton>(find.byType(GradientButton)).onPressed,
        isNotNull,
      );
      await _save(tester);
      expect(repository.payloads.single['dissolvedOxygenMgL'], 4.5);
      expect(repository.payloads.single.containsKey('ph'), isFalse);
      expect(tester.takeException(), isNull);
    },
  );

  test('thresholds include both boundaries and skip unmeasured fields', () {
    for (final type in [ShrimpType.whiteleg, ShrimpType.blackTiger]) {
      final min = type == ShrimpType.whiteleg ? 25.0 : 26.0;
      final max = type == ShrimpType.whiteleg ? 33.0 : 32.0;
      for (final values in [
        {
          'temperatureC': min,
          'ph': 7.5,
          'dissolvedOxygenMgL': 4.0,
          'salinityPpt': 10.0,
          'nh3MgL': 0.0,
          'no2MgL': 0.0,
          'alkalinityMgLCaCO3': 100.0,
          'h2sMgL': 0.0,
        },
        {
          'temperatureC': max,
          'ph': 8.5,
          'dissolvedOxygenMgL': 20.0,
          'salinityPpt': 30.0,
          'nh3MgL': 0.1,
          'no2MgL': 0.5,
          'alkalinityMgLCaCO3': 250.0,
          'h2sMgL': 0.05,
        },
        <String, double>{},
      ]) {
        expect(checkWaterLogThresholds(type, values), isEmpty);
      }
      final warnings = checkWaterLogThresholds(type, {
        'temperatureC': min - 0.01,
        'ph': 8.51,
        'dissolvedOxygenMgL': 3.99,
        'salinityPpt': 30.01,
        'nh3MgL': 0.10001,
        'no2MgL': 0.50001,
        'alkalinityMgLCaCO3': 99.99,
        'h2sMgL': 0.05001,
      });
      expect(
        warnings.map((e) => e.threshold.param.field),
        waterLogFormParams.map((e) => e.field),
      );
      expect(warnings.where((e) => e.isBelowMinimum).length, 3);
    }
    expect(
      checkWaterLogThresholds(ShrimpType.whiteleg, {'temperatureC': 25.5}),
      isEmpty,
    );
    expect(
      checkWaterLogThresholds(ShrimpType.blackTiger, {'temperatureC': 25.5}),
      hasLength(1),
    );
    expect(
      () => checkWaterLogThresholds(ShrimpType.unknown, {'ph': 9}),
      throwsArgumentError,
    );
  });

  testWidgets('in-range readings save directly without a confirmation', (
    tester,
  ) async {
    final repository = _Repository();
    await _open(tester, repository);
    await tester.enterText(find.byType(TextField).at(1), '8,5');
    await _save(tester);
    expect(find.byKey(const Key('water_log_warning_dialog')), findsNothing);
    expect(repository.payloads.single['ph'], 8.5);
    expect(find.byKey(const Key('water_log_form_sheet')), findsNothing);
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Đã lưu nhật ký đo nước.'), findsOneWidget);
    expect(find.byKey(const ValueKey('app_notice_success')), findsOneWidget);
  });

  testWidgets(
    'only exceeded values appear; review preserves input; confirm saves once',
    (tester) async {
      final repository = _Repository();
      await _open(tester, repository);
      await tester.enterText(find.byType(TextField).at(0), '28');
      await tester.enterText(find.byType(TextField).at(1), '9');
      await tester.enterText(find.byType(TextField).at(2), '3');
      await _save(tester);
      expect(repository.payloads, isEmpty);
      expect(
        find.byKey(const ValueKey('water_warning_temperatureC')),
        findsNothing,
      );
      expect(find.byKey(const ValueKey('water_warning_ph')), findsOneWidget);
      expect(
        find.byKey(const ValueKey('water_warning_dissolvedOxygenMgL')),
        findsOneWidget,
      );
      expect(find.text('Cao hơn mức tối đa'), findsOneWidget);
      expect(find.text('Thấp hơn mức tối thiểu'), findsOneWidget);
      await tester.tap(find.text('Kiểm tra lại'));
      await tester.pumpAndSettle();
      expect(repository.payloads, isEmpty);
      expect(
        tester.widget<TextField>(find.byType(TextField).at(1)).controller!.text,
        '9',
      );
      await tester.enterText(find.byType(TextField).at(1), '8');
      await _save(tester);
      expect(find.byKey(const ValueKey('water_warning_ph')), findsNothing);
      await tester.tap(find.text('Vẫn lưu'));
      await tester.pumpAndSettle();
      expect(repository.payloads, hasLength(1));
      expect(repository.payloads.single['ph'], 8);
      expect(repository.payloads.single['dissolvedOxygenMgL'], 3);
      expect(find.byKey(const Key('water_log_form_sheet')), findsNothing);
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Đã lưu nhật ký đo nước.'), findsOneWidget);
      expect(find.byKey(const ValueKey('app_notice_success')), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('uses metadata species and does not save on barrier dismissal', (
    tester,
  ) async {
    final repository = _Repository()
      ..metadata = WaterLogMetadata.legacy(ShrimpType.blackTiger);
    await _open(tester, repository, apiShrimpType: 'WHITELEG');
    await tester.enterText(find.byType(TextField).at(0), '25.5');
    await _save(tester);
    expect(find.textContaining('cho Tôm sú.'), findsOneWidget);
    expect(find.text('Ngưỡng khuyến nghị: 26–32 °C'), findsOneWidget);
    expect(repository.payloads, isEmpty);
    await tester.tapAt(const Offset(5, 5));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('water_log_warning_dialog')), findsNothing);
    expect(find.byKey(const Key('water_log_form_sheet')), findsOneWidget);
    expect(repository.payloads, isEmpty);
  });

  testWidgets('all eight warnings scroll and actions fit on a small screen', (
    tester,
  ) async {
    final repository = _Repository();
    await _open(tester, repository, size: const Size(320, 568));
    final input = ['1', '1', '1', '1', '1', '1', '1', '1'];
    for (var i = 0; i < input.length; i++) {
      await tester.enterText(find.byType(TextField).at(i), input[i]);
    }
    await _save(tester);
    expect(find.textContaining('8 chỉ số'), findsOneWidget);
    await tester.drag(
      find.byKey(const Key('water_log_warnings_list')),
      const Offset(0, -800),
    );
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('water_warning_h2sMgL')).hitTestable(),
      findsOneWidget,
    );
    expect(find.text('Kiểm tra lại').hitTestable(), findsOneWidget);
    expect(find.text('Vẫn lưu').hitTestable(), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'failed warning save reuses the retry key and preserves the form',
    (tester) async {
      final repository = _Repository()..failCreate = true;
      await _open(tester, repository);
      await tester.enterText(find.byType(TextField).at(1), '9');
      for (var i = 0; i < 2; i++) {
        await _save(tester);
        await tester.tap(find.text('Vẫn lưu'));
        await tester.pumpAndSettle();
      }
      expect(repository.keys, hasLength(2));
      expect(repository.keys[0], repository.keys[1]);
      expect(find.byKey(const Key('water_log_form_sheet')), findsOneWidget);
      expect(
        find.text('Không thể lưu nhật ký. Vui lòng thử lại.'),
        findsOneWidget,
      );
      expect(find.byType(SnackBar), findsNothing);
    },
  );

  testWidgets('metadata allows saving even when the season detail API fails', (
    tester,
  ) async {
    final repository = _Repository();
    await _open(tester, repository, failSeason: true);
    await tester.enterText(find.byType(TextField).at(1), '9');
    await _save(tester);
    expect(repository.payloads, isEmpty);
    expect(find.byKey(const Key('water_log_warning_dialog')), findsOneWidget);
    await tester.tap(find.text('Vẫn lưu'));
    await tester.pumpAndSettle();
    expect(repository.payloads.single['ph'], 9);
    expect(find.byKey(const Key('water_log_form_sheet')), findsNothing);
    expect(tester.takeException(), isNull);
  });
}

class _PendingRepository extends _Repository {
  final pending = Completer<WaterLog>();
  int calls = 0;
  @override
  Future<WaterLog> createWaterLog({
    required String seasonId,
    required Map<String, Object?> payload,
    required String idempotencyKey,
  }) {
    calls++;
    return pending.future;
  }
}

class _Repository implements WaterLogRepository {
  WaterLogMetadata? metadata;
  AppException? metadataError;
  @override
  Future<WaterLogMetadata> getMetadata({required String seasonId}) async {
    if (metadataError != null) throw metadataError!;
    if (metadata != null) return metadata!;
    // Supply metadata at the repository boundary for existing warning UI cases.
    return WaterLogMetadata.legacy(ShrimpType.whiteleg);
  }

  final payloads = <Map<String, Object?>>[];
  final keys = <String>[];
  bool failCreate = false;
  AppException? createError;

  @override
  Future<WaterLogPage> getWaterLogs({
    required String seasonId,
    DateTime? from,
    DateTime? to,
    bool includeVoided = false,
    WaterLogFilter? filter,
    bool includeCounts = false,
    int limit = 20,
    String? cursor,
  }) async =>
      const WaterLogPage(items: [], totalResults: 0, hasNextPage: false);

  @override
  Future<WaterLog> createWaterLog({
    required String seasonId,
    required Map<String, Object?> payload,
    required String idempotencyKey,
  }) async {
    payloads.add(payload);
    keys.add(idempotencyKey);
    if (createError != null) throw createError!;
    if (failCreate) throw StateError('timeout');
    return WaterLog(
      id: 'log',
      seasonId: seasonId,
      recordedAt: DateTime.now(),
      createdAt: DateTime.now(),
      isVoided: false,
      exceededParameters: [],
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Seasons implements AssignedSeasonRepository {
  _Seasons(this.shrimpType, {this.fail = false});
  final String shrimpType;
  final bool fail;

  @override
  Future<AssignedSeasonDetail> getAssignedSeason(String seasonId) async {
    if (fail) throw StateError('offline');
    return AssignedSeasonDetail(
      id: seasonId,
      name: 'Vụ nuôi',
      status: AssignedSeasonStatus.active,
      shrimpType: shrimpType,
      pondId: 'pond',
      pondName: 'Ao A3',
      pondType: 'LINED',
      pondStatus: 'ACTIVE',
      farmId: 'farm',
      farmName: 'Trại',
      personnel: [],
      otherAssignedSeasons: [],
      assignedAt: DateTime(2026),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
