typedef OperationExplanationSource = ({
  String id,
  String material,
  DateTime? executedAt,
  DateTime? recordedAt,
  String? executor,
  String? note,
  String? varianceReason,
});

class OperationExecutionExplanation {
  OperationExecutionExplanation._(this.text);

  final String text;
  final _materials = <String, ({String name, bool note, bool variance})>{};

  String get firstItemId => _materials.keys.first;
  int get itemCount => _materials.length;
  String get materials => _materials.values.map((item) => item.name).join(', ');

  String get title => switch ((
    _materials.values.any((item) => item.note),
    _materials.values.any((item) => item.variance),
  )) {
    (true, true) => 'Lý do ghi nhận',
    (false, true) => 'Lý do điều chỉnh lượng dùng',
    _ => 'Ghi chú của Kỹ thuật viên',
  };

  static List<OperationExecutionExplanation> forOccurrence(
    Iterable<OperationExplanationSource> items,
  ) {
    final explanations =
        <
          (int?, int?, String?, String?, String),
          OperationExecutionExplanation
        >{};
    for (final item in items) {
      final note = item.note?.trim() ?? '';
      final variance = item.varianceReason?.trim() ?? '';
      for (final value in {note, variance}.where((value) => value.isNotEmpty)) {
        // Rows written in one transaction share their recorded timestamp.
        final key = (
          item.executedAt?.microsecondsSinceEpoch,
          item.recordedAt?.microsecondsSinceEpoch,
          item.executor,
          item.recordedAt == null ? item.id : null,
          value,
        );
        final explanation = explanations.putIfAbsent(
          key,
          () => OperationExecutionExplanation._(value),
        );
        explanation._materials[item.id] = (
          name: item.material,
          note: value == note,
          variance: value == variance,
        );
      }
    }
    return explanations.values.toList(growable: false);
  }
}
