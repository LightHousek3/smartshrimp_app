import 'package:smartshrimp_app/features/protocol/domain/entities/protocol.dart';

/// DOC 1 is the stocking date, evaluated on Vietnam's calendar, independent of device timezone.
int? protocolCurrentDoc(ProtocolDetail detail, DateTime now) {
  if (detail.card.protocolType != ProtocolType.production ||
      detail.anchorDate == null ||
      detail.durationDays == 0) {
    return null;
  }
  final local = now.toUtc().add(const Duration(hours: 7));
  final today = DateTime.utc(local.year, local.month, local.day);
  final anchor = DateTime.parse('${detail.anchorDate}T00:00:00Z');
  final day = today.difference(anchor).inDays + 1;
  return day >= 1 && day <= detail.durationDays ? day : null;
}

int protocolInitialDay(ProtocolDetail detail, DateTime now) {
  final current = protocolCurrentDoc(detail, now);
  if (current != null) return current;
  if (detail.card.protocolType == ProtocolType.production &&
      detail.anchorDate != null &&
      detail.durationDays > 0) {
    final local = now.toUtc().add(const Duration(hours: 7));
    final today = DateTime.utc(local.year, local.month, local.day);
    if (today.isAfter(DateTime.parse('${detail.anchorDate}T00:00:00Z'))) {
      return detail.durationDays;
    }
  }
  return 1;
}
