import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DestructiveActionButton extends StatelessWidget {
  const DestructiveActionButton({
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.filled = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final bool filled;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 47,
    child: filled
        ? FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFD43B57),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: loading ? null : onPressed,
            child: loading
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(label),
          )
        : OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFBB4D00),
              backgroundColor: const Color(0xFFFBF0DC),
              disabledForegroundColor: const Color(0xFFBB4D00),
              disabledBackgroundColor: const Color(0xFFFBF0DC),
              side: const BorderSide(color: Color(0xFFFEE685)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: loading ? null : onPressed,
            icon: const Icon(Icons.delete_outline_rounded, size: 16),
            label: Text(label),
          ),
  );
}
