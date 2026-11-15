import 'package:json_annotation/json_annotation.dart';

/// Actions linked by the server to an audited Expert decision, separate from chat types.
enum CaseCareAction {
  @JsonValue('MONITOR')
  monitor,
  @JsonValue('RESUME_PRODUCTION')
  resumeProduction,
  @JsonValue('CLOSE_WITHOUT_PRODUCTION')
  closeWithoutProduction,
  unknown;

  bool get isDecision => this != unknown;
}
