abstract final class TaskRules {
  static const titleLimit = 255;
  static const descriptionLimit = 500;
  static const cancellationReasonLimit = 500;
  static const deadlineLead = Duration(minutes: 10);
  static const deadlineMessage =
      'Hạn hoàn thành phải lớn hơn thời gian hiện tại 10 phút.';

  static String? titleError(String? value) =>
      value == null || value.trim().isEmpty
      ? 'Vui lòng nhập tiêu đề nhiệm vụ.'
      : value.trim().runes.length > titleLimit
      ? 'Tiêu đề tối đa 255 ký tự.'
      : null;
  static String? descriptionError(String? value) =>
      (value?.trim().runes.length ?? 0) > descriptionLimit
      ? 'Mô tả tối đa 500 ký tự.'
      : null;
  static String? cancellationReasonError(String? value) =>
      value == null || value.trim().isEmpty
      ? 'Vui lòng nhập lý do hủy.'
      : value.trim().runes.length > cancellationReasonLimit
      ? 'Lý do hủy tối đa 500 ký tự.'
      : null;
  static String? deadlineError(DateTime? value, DateTime now) => value == null
      ? 'Vui lòng chọn hạn hoàn thành.'
      : !value.isAfter(now.add(deadlineLead))
      ? deadlineMessage
      : null;

  static DateTime firstSelectableDeadline(DateTime now) =>
      DateTime.fromMillisecondsSinceEpoch(
        ((now.add(deadlineLead).millisecondsSinceEpoch ~/ 60000) + 1) * 60000,
      );
}
