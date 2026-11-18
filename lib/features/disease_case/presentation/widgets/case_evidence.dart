import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartshrimp_app/core/widgets/app_image_viewer.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/core/widgets/app_svg_icon.dart';
import 'package:smartshrimp_app/features/protocol/presentation/widgets/protocol_ui.dart'
    show protocolDate;
import 'package:url_launcher/url_launcher.dart';
import '../../domain/entities/owner_disease_case.dart';
import 'disease_case_ui.dart';

class CaseEvidence extends StatelessWidget {
  const CaseEvidence({required this.attachments, super.key});

  final List<DiseaseCaseAttachment> attachments;

  @override
  Widget build(BuildContext context) {
    final images = attachments.where(_isEvidenceImage).toList(growable: false);
    final files = attachments
        .where((item) => !_isEvidenceImage(item))
        .toList(growable: false);
    return Column(
      spacing: 8,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: DiseaseCaseSectionTitle(
            'Bằng chứng ban đầu',
            trailing: DiseaseCaseBadge(
              [
                if (images.isNotEmpty) '${images.length} ảnh',
                if (files.isNotEmpty) '${files.length} tệp',
              ].join(' · '),
            ),
          ),
        ),
        for (final (index, item) in images.indexed)
          DiseaseCaseSurface(
            key: ValueKey('case-evidence-image-$index'),
            padding: EdgeInsets.zero,
            onTap: () => showAppImageViewer(
              context,
              builder: (_) => AppImageViewer(
                itemCount: images.length,
                initialIndex: index,
                selectionColor: caseAiAccent,
                imageBuilder: (i, fit) =>
                    _CaseEvidenceImage(images[i].fileUrl, fit: fit),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Semantics(
                  image: true,
                  button: true,
                  label: 'Xem ảnh bằng chứng ${index + 1}',
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: AspectRatio(
                      aspectRatio: 16 / 10,
                      child: _CaseEvidenceImage(item.fileUrl),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (item.caption?.trim().isNotEmpty == true)
                        Text(
                          item.caption!,
                          style: caseTitleStyle.copyWith(
                            fontSize: 12,
                            height: 1.5,
                          ),
                        ),
                      Text(
                        '${item.uploaderName} · ${protocolDate(item.createdAt, year: true, time: true)}',
                        style: caseMetadataStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        for (final item in files)
          DiseaseCaseSurface(
            onTap: () => _openAttachment(context, item.fileUrl),
            child: Row(
              spacing: 12,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: casePurple.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: AppSvgIcon(
                      item.mediaType?.toLowerCase().startsWith('image/') == true
                          ? AppSvgIconName.camera
                          : AppSvgIconName.document,
                      color: caseAiAccent,
                      size: 18,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.caption ?? 'Tệp đính kèm',
                        style: caseTitleStyle.copyWith(
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${item.uploaderName} · ${protocolDate(item.createdAt, year: true, time: true)}',
                        style: caseMetadataStyle,
                      ),
                      if (item.mediaType case final type?)
                        Text(
                          type.toUpperCase(),
                          style: caseMetadataStyle.copyWith(fontSize: 9),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Future<void> _openAttachment(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null &&
        (uri.isScheme('https') || uri.isScheme('http')) &&
        uri.host.isNotEmpty) {
      try {
        if (await launchUrl(uri, mode: LaunchMode.externalApplication)) return;
      } on PlatformException {
        // Use the same notice when the device cannot open the file.
      }
    }
    if (context.mounted) {
      AppNoticeService.danger(context, 'Không thể mở tệp đính kèm.');
    }
  }
}

// KTV uploads image URLs without MIME metadata, including extensionless CDN URLs.
// Explicit non-image files keep their existing external-file behavior.
bool _isEvidenceImage(DiseaseCaseAttachment item) {
  final type = item.mediaType?.split(';').first.trim().toLowerCase();
  final path = Uri.tryParse(item.fileUrl)?.path.toLowerCase() ?? '';
  if (type != null && type.isNotEmpty && type != 'application/octet-stream') {
    return type.startsWith('image/');
  }
  return ![
    '.pdf',
    '.doc',
    '.docx',
    '.xls',
    '.xlsx',
    '.txt',
    '.mp4',
    '.mov',
  ].any(path.endsWith);
}

class _CaseEvidenceImage extends StatefulWidget {
  const _CaseEvidenceImage(this.url, {this.fit = BoxFit.cover});
  final String url;
  final BoxFit fit;
  @override
  State<_CaseEvidenceImage> createState() => _CaseEvidenceImageState();
}

class _CaseEvidenceImageState extends State<_CaseEvidenceImage> {
  int _retryCount = 0;
  @override
  Widget build(BuildContext context) {
    final provider = ResizeImage.resizeIfNeeded(
      widget.fit == BoxFit.cover ? 600 : 2048,
      null,
      NetworkImage(widget.url),
    );
    return Image(
      key: ValueKey((widget.url, _retryCount)),
      image: provider,
      fit: widget.fit,
      loadingBuilder: (_, child, progress) => progress == null
          ? child
          : const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      errorBuilder: (_, _, _) => ColoredBox(
        color: const Color(0xFFEEF1F6),
        child: Center(
          child: TextButton.icon(
            onPressed: () async {
              await provider.evict();
              if (mounted) setState(() => _retryCount++);
            },
            icon: const AppSvgIcon(AppSvgIconName.camera, size: 20),
            label: const Text('Tải lại ảnh'),
          ),
        ),
      ),
    );
  }
}
