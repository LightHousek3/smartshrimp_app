import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/features/disease_case/domain/domain.dart';
import 'package:smartshrimp_app/features/disease_case/presentation/view_models/disease_case_controller.dart';
import 'package:smartshrimp_app/features/notifications/data/services/notification_socket.dart';

import '../../support/load_app_fonts.dart';
import '../task/task_api_test.dart' show TaskSessionStore;
import 'disease_case_test.dart' show CaseFixtureRepository, fixture, showCase;

class _RealtimeRepository extends CaseFixtureRepository {
  int detailCalls = 0;
  Completer<DiseaseCase>? pendingDetail;

  @override
  Future<DiseaseCase> detail(String seasonId, String id) async {
    detailCalls++;
    return pendingDetail?.future ?? item;
  }
}

void main() {
  setUpAll(loadAppFonts);

  (NotificationSocket, io.Socket) socketFixture({
    void Function()? onChanged,
    void Function(String, DateTime)? onRead,
  }) {
    final transport = io.io(
      'http://localhost:1',
      io.OptionBuilder().disableAutoConnect().enableForceNew().build(),
    );
    final dio = Dio();
    final realtime = NotificationSocket(
      serverUrl: 'http://localhost:1',
      apiClient: ApiClient(dio, TaskSessionStore()),
      onChanged: onChanged ?? () {},
      onRead: onRead,
      onSessionExpired: () {},
      socket: transport,
    );
    addTearDown(() {
      realtime.dispose();
      dio.close();
    });
    return (realtime, transport);
  }

  test('a valid notification read bypasses the full inbox refresh', () {
    final events = <(String, DateTime)>[];
    var refreshes = 0;
    final (_, transport) = socketFixture(
      onChanged: () => refreshes++,
      onRead: (id, readAt) => events.add((id, readAt)),
    );
    final timestamp = DateTime.utc(2026, 11, 28, 2);
    transport.emitEvent([
      'notification:read',
      {'id': 'notice', 'readAt': timestamp.toIso8601String()},
    ]);
    expect(events, [('notice', timestamp)]);
    expect(refreshes, 0);

    transport.emitEvent([
      'notification:read',
      {'id': 'legacy'},
    ]);
    expect(refreshes, 1);
  });

  test(
    'routes case events, legacy ids and reconnects, ignoring read events',
    () async {
      final (realtime, transport) = socketFixture();
      final updates = <String?>[];
      final subscription = realtime.caseChanges.listen(updates.add);
      addTearDown(subscription.cancel);

      transport.emitEvent([
        'notification:new',
        {'referenceType': 'disease_case', 'referenceId': 'case'},
      ]);
      transport.emitEvent([
        'notification:new',
        {'referenceType': 'task', 'referenceId': 'task'},
      ]);
      transport.emitEvent([
        'notification:read',
        {'id': 'read'},
      ]);
      transport.emitEvent(['notification:read-all', {}]);
      transport.emitEvent([
        'notification:new',
        {'id': 'legacy'},
      ]);
      transport.emitReserved('connect');
      await Future<void>.delayed(Duration.zero);

      expect(updates, ['case', null, null]);
    },
  );

  testWidgets(
    'expert reply and reconnect refresh the case without losing the draft',
    (tester) async {
      final (realtime, transport) = socketFixture();
      final repo = _RealtimeRepository();
      final container = await showCase(
        tester,
        repo,
        path: '/seasons/season/disease-cases/case',
        realtimeSocket: realtime,
      );
      final detail = diseaseCaseDetailProvider((
        seasonId: 'season',
        id: 'case',
      ));
      await tester.enterText(find.byType(TextFormField), 'Bản nháp đang nhập');
      final initialCalls = repo.detailCalls;

      transport.emitEvent([
        'notification:new',
        {'referenceType': 'disease_case', 'referenceId': 'other-case'},
      ]);
      await tester.pumpAndSettle();
      expect(repo.detailCalls, initialCalls);

      repo.item = fixture.copyWith(
        status: DiseaseCaseStatus.monitoring,
        updatedAt: fixture.updatedAt.add(const Duration(seconds: 1)),
        responses: [
          CaseResponse(
            id: 'expert-reply',
            authorId: 'expert',
            responseType: CaseResponseType.instruction,
            message: 'Theo dõi tôm sau xử lý',
            createdAt: DateTime(2026, 11, 11),
          ),
        ],
      );
      repo.pendingDetail = Completer<DiseaseCase>();
      transport.emitEvent([
        'notification:new',
        {'referenceType': 'disease_case', 'referenceId': 'case'},
      ]);
      await tester.pump();
      await tester.pump();
      expect(
        tester.widget<TextFormField>(find.byType(TextFormField)).enabled,
        isTrue,
      );
      expect(find.text('Bản nháp đang nhập'), findsOneWidget);
      repo.pendingDetail!.complete(repo.item);
      await tester.pumpAndSettle();

      expect(repo.detailCalls, initialCalls + 1);
      expect(
        container.read(detail).requireValue.responses.single.id,
        'expert-reply',
      );
      expect(
        container.read(detail).requireValue.status,
        DiseaseCaseStatus.monitoring,
      );
      expect(find.text('Bản nháp đang nhập'), findsOneWidget);

      // A response missed while offline is recovered by the connect event.
      repo.pendingDetail = null;
      repo.item = repo.item.copyWith(
        description: 'Dữ liệu mới sau kết nối lại',
      );
      transport.emitReserved('connect');
      await tester.pumpAndSettle();
      expect(repo.detailCalls, initialCalls + 2);
      await tester.tap(find.text('Dữ liệu lúc mở ca'));
      await tester.pumpAndSettle();
      expect(find.text('Ghi chú: Dữ liệu mới sau kết nối lại'), findsOneWidget);
      expect(find.text('Bản nháp đang nhập'), findsOneWidget);
      expect(container.read(detail).requireValue.responses, hasLength(1));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('open case list reloads on new case events and reconnect', (
    tester,
  ) async {
    final (realtime, transport) = socketFixture();
    final repo = _RealtimeRepository();
    await showCase(tester, repo, realtimeSocket: realtime);
    final initialCalls = repo.lists;
    repo.item = fixture.copyWith(title: 'Ca bệnh được cập nhật');
    transport.emitEvent([
      'notification:new',
      {'referenceType': 'disease_case', 'referenceId': 'case'},
    ]);
    await tester.pumpAndSettle();
    expect(repo.lists, initialCalls + 1);
    expect(find.text('Ca bệnh được cập nhật'), findsOneWidget);

    transport.emitReserved('connect');
    await tester.pumpAndSettle();
    expect(repo.lists, initialCalls + 2);
    expect(tester.takeException(), isNull);
  });
}
