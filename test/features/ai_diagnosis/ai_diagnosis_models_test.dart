import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/ai_diagnosis/domain/ai_diagnosis_rules.dart';
import 'package:smartshrimp_app/features/ai_diagnosis/domain/entities/ai_diagnosis.dart';
import 'ai_diagnosis_fixtures.dart';

void main() {
  test('N: parses success and technical failure without invented results', () {
    final detail = AiDiagnosisDetail.parse(diagnosisJson());
    expect(detail.predictedLabel, AiDiseaseLabel.wssv);
    expect(detail.predictions.length, 4);
    final failure = AiDiagnosisDetail.parse(diagnosisJson(error: true));
    expect(failure.error?.code, 'AI_UNAVAILABLE');
    expect(failure.confidence, isNull);
    expect(
      AiDiagnosisSummary.parse(summaryJson(error: true)).runStatus,
      AiRunStatus.error,
    );
  });
  test(
    'B: accepts SQL confidence rounding while retaining prediction precision',
    () {
      final json = diagnosisJson();
      (json['predictions'] as List)[0]['probability'] = 0.900004;
      (json['predictions'] as List)[1]['probability'] = 0.049996;
      expect(AiDiagnosisDetail.parse(json).confidence, 0.9);
    },
  );
  for (final entry in <String, void Function(Map<String, dynamic>)>{
    'unknown label': (j) => j['predictedLabel'] = 'White Feces Syndrome',
    'unknown status': (j) => j['runStatus'] = 'PENDING',
    'missing recognition status': (j) => j.remove('recognitionStatus'),
    'unknown recognition status': (j) => j['recognitionStatus'] = 'OTHER',
    'recognized without label': (j) => j['predictedLabel'] = null,
    'unrecognized with disease label': (j) =>
        j['recognitionStatus'] = 'UNRECOGNIZED',
    'missing identity': (j) => j.remove('id'),
    'empty images': (j) => j['imageUrls'] = [],
    'insecure URL': (j) => j['imageUrls'] = ['http://images.test/a'],
    'credential URL': (j) => j['imageUrls'] = ['https://secret@images.test/a'],
    'negative latency': (j) => j['processingTimeMs'] = -1,
    'fractional latency': (j) => j['processingTimeMs'] = 1.5,
    'non-finite confidence': (j) => j['confidence'] = double.nan,
    'mismatched confidence': (j) => j['confidence'] = 0.79,
    'duplicate predictions': (j) =>
        (j['predictions'] as List)[1]['label'] = 'Đốm trắng',
    'unnormalized probabilities': (j) =>
        (j['predictions'] as List)[1]['probability'] = 0.2,
    'unsorted probabilities': (j) {
      final p = j['predictions'] as List;
      final last = p.removeLast();
      p.insert(1, last);
    },
  }.entries) {
    test('A: rejects ${entry.key}', () {
      final json = diagnosisJson();
      entry.value(json);
      expect(
        () => AiDiagnosisDetail.parse(json),
        throwsA(isA<InvalidResponseException>()),
      );
    });
  }
  test(
    'N: unrecognized results preserve four probabilities without a public disease label',
    () {
      final detail = AiDiagnosisDetail.parse(
        diagnosisJson(confidence: 0.79, recognized: false),
      );
      expect(detail.runStatus, AiRunStatus.success);
      expect(detail.recognitionStatus, AiRecognitionStatus.unrecognized);
      expect(detail.isRecognized, isFalse);
      expect(detail.predictedLabel, isNull);
      expect(detail.predictions.length, 4);
      expect(detail.confidence, 0.79);
      final summary = AiDiagnosisSummary.parse(
        summaryJson(confidence: 0.79, recognized: false),
      );
      expect(summary.predictedLabel, isNull);
      expect(summary.isRecognized, isFalse);
    },
  );
  test('B: signed image expiry includes a five-second safety margin', () {
    final d = AiDiagnosisDetail.parse(diagnosisJson());
    expect(
      d.imageUrlsExpiredAt(
        d.imageUrlsExpireAt!.subtract(const Duration(seconds: 6)),
      ),
      isFalse,
    );
    expect(
      d.imageUrlsExpiredAt(
        d.imageUrlsExpireAt!.subtract(const Duration(seconds: 5)),
      ),
      isTrue,
    );
  });
  test('A/B: rejects incorrect summary counts and inconsistent cursors', () {
    for (final count in [0, 6, 1.5]) {
      expect(
        () => AiDiagnosisSummary.parse({...summaryJson(), 'imageCount': count}),
        throwsA(isA<InvalidResponseException>()),
      );
    }
    expect(
      () =>
          AiDiagnosisPagination.parse({'totalResults': 1, 'hasNextPage': true}),
      throwsA(isA<InvalidResponseException>()),
    );
    expect(
      () => AiDiagnosisPagination.parse({
        'totalResults': 1,
        'hasNextPage': false,
        'nextCursor': 'stale',
      }),
      throwsA(isA<InvalidResponseException>()),
    );
  });
  test('B: enforces image count and exact byte boundaries', () {
    AiDiagnosisRules.validate([sampleImage()]);
    AiDiagnosisRules.validate(List.filled(5, sampleImage()));
    expect(() => AiDiagnosisRules.validate([]), throwsA(isA<ApiException>()));
    expect(
      () => AiDiagnosisRules.validate(List.filled(6, sampleImage())),
      throwsA(isA<ApiException>()),
    );
    AiDiagnosisRules.validateSize(10 * 1024 * 1024);
    for (final size in [0, -1, 10 * 1024 * 1024 + 1]) {
      expect(
        () => AiDiagnosisRules.validateSize(size),
        throwsA(isA<ApiException>()),
      );
    }
    expect(
      () => AiDiagnosisRules.validate([
        sampleImage().copyWith(mimeType: 'image/jpeg'),
      ]),
      throwsA(isA<ApiException>()),
    );
  });
  test('A: derives supported MIME from bytes and rejects disguised files', () {
    expect(
      AiDiagnosisRules.mimeType(Uint8List.fromList([255, 216, 255])),
      'image/jpeg',
    );
    expect(
      AiDiagnosisRules.mimeType(
        Uint8List.fromList([82, 73, 70, 70, 0, 0, 0, 0, 87, 69, 66, 80]),
      ),
      'image/webp',
    );
    expect(AiDiagnosisRules.mimeType(sampleImage().bytes), 'image/png');
    expect(
      () => AiDiagnosisRules.mimeType(
        Uint8List.fromList([60, 115, 118, 103, 62]),
      ),
      throwsA(isA<ApiException>()),
    );
  });
}
