import 'dart:typed_data';
import 'package:smartshrimp_app/core/errors/app_exception.dart';

abstract final class TaskRules {
  static const titleLimit = 255;
  static const descriptionLimit = 500;
  static const cancellationReasonLimit = 500;
  static const maxEvidenceImages = 5;
  static const maxEvidenceImageBytes = 5 * 1024 * 1024;
  static const evidenceUrlLimit = 2048;
  static const deadlineLead = Duration(minutes: 10);
  static const deadlineMessage =
      'Hạn hoàn thành phải lớn hơn thời gian hiện tại 10 phút.';
  static const missingSeasonTechnicianMessage =
      'Vụ nuôi chưa có kỹ thuật viên đang phụ trách. Vui lòng phân công trước khi giao nhiệm vụ.';

  static String? assigneeError(String? assignedTo, {required bool hasSeason}) =>
      assignedTo != null
      ? null
      : hasSeason
      ? missingSeasonTechnicianMessage
      : 'Vui lòng chọn nhân sự.';

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

  static bool validEvidenceUrls(List<String> urls) =>
      urls.length <= maxEvidenceImages &&
      urls.toSet().length == urls.length &&
      urls.every((url) {
        final uri = Uri.tryParse(url);
        return url.length <= evidenceUrlLimit &&
            uri != null &&
            uri.scheme == 'https' &&
            uri.host.isNotEmpty &&
            !RegExp(r'\s').hasMatch(url);
      });

  static void validateEvidenceUrls(List<String> urls) {
    if (!validEvidenceUrls(urls)) {
      throw const ApiException(
        'Chọn tối đa 5 ảnh minh chứng hợp lệ, không trùng lặp.',
      );
    }
  }

  static void validateEvidenceImage(Uint8List bytes) {
    if (bytes.isEmpty || bytes.length > maxEvidenceImageBytes) {
      throw const ApiException(
        'Ảnh minh chứng phải có dung lượng từ 1 byte đến 5 MB.',
      );
    }
    final jpeg =
        bytes.length >= 3 &&
        bytes[0] == 0xff &&
        bytes[1] == 0xd8 &&
        bytes[2] == 0xff;
    final png =
        bytes.length >= 8 &&
        bytes.take(8).join(',') == '137,80,78,71,13,10,26,10';
    final webp =
        bytes.length >= 12 &&
        String.fromCharCodes(bytes.take(4)) == 'RIFF' &&
        String.fromCharCodes(bytes.skip(8).take(4)) == 'WEBP';
    if (!jpeg && !png && !webp) {
      throw const ApiException('Chọn ảnh JPG, PNG hoặc WebP.');
    }
  }
}
