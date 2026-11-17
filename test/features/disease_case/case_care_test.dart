import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/features/disease_case/domain/entities/case_care_action.dart';
import 'package:smartshrimp_app/features/disease_case/domain/entities/disease_case.dart'
    as technician;
import 'package:smartshrimp_app/features/disease_case/domain/entities/owner_disease_case.dart'
    as owner;
import 'package:smartshrimp_app/features/disease_case/presentation/widgets/case_care_notice.dart';

void main() {
  Map<String, dynamic> reply([String? action]) => {
    'id': 'reply',
    'authorId': 'expert',
    'message': 'Chỉ dẫn chăm sóc.',
    'responseType': 'NORMAL',
    'createdAt': '2030-01-08T01:00:00Z',
    'careAction': ?action,
  };

  test(
    'ordinary conversation cannot impersonate a care decision by its message',
    () {
      final response = technician.CaseResponse.fromJson({
        ...reply(),
        'message': 'Tiếp tục theo dõi, tạm hoãn phác đồ nuôi.',
      });
      expect(response.careAction, isNull);
    },
  );

  test(
    'KTV parses the audited monitoring decision and preserves NORMAL conversation',
    () {
      final response = technician.CaseResponse.fromJson(reply('MONITOR'));
      expect(response.careAction, CaseCareAction.monitor);
      expect(response.responseType, technician.CaseResponseType.normal);
    },
  );

  test(
    'unknown care metadata remains readable without becoming a recognized decision',
    () {
      final response = technician.CaseResponse.fromJson(reply('FUTURE_ACTION'));
      expect(response.careAction?.isDecision, isFalse);
    },
  );

  test(
    'Owner timeline parses the same care action as the KTV conversation',
    () {
      final response =
          owner.DiseaseCaseEvent.fromJson({
                'kind': 'response',
                'at': '2030-01-08T01:00:00Z',
                'authorName': 'Expert',
                'authorRole': 'EXPERT',
                'responseType': 'NORMAL',
                'message': 'Cho phép nuôi tiếp.',
                'careAction': 'RESUME_PRODUCTION',
              })
              as owner.DiseaseCaseResponse;
      expect(response.careAction, CaseCareAction.resumeProduction);
    },
  );

  test(
    'a paused production notice comes from server state, not the case status alone',
    () {
      final item = technician.DiseaseCase.fromJson({
        'id': 'case',
        'seasonId': 'season',
        'title': 'Ca bệnh',
        'status': 'MONITORING',
        'severity': 'MEDIUM',
        'createdAt': '2030-01-08T01:00:00Z',
        'updatedAt': '2030-01-08T01:00:00Z',
        'productionPaused': true,
      });
      expect(item.productionPaused, isTrue);
    },
  );

  testWidgets(
    'the shared Owner and KTV notice displays the agreed paused wording',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: CaseCareNotice())),
      );
      expect(find.text('Phác đồ nuôi đang tạm hoãn'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
