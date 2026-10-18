import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Register bundled font faces so screenshots use the same typography as the app.
Future<void> loadAppFonts() async {
  GoogleFonts.config.allowRuntimeFetching = false;
  for (final (family, file) in [
    ('Sora_700', 'Sora-Bold.ttf'),
    ('Sora_800', 'Sora-ExtraBold.ttf'),
    ('PlusJakartaSans_regular', 'PlusJakartaSans-Regular.ttf'),
    ('PlusJakartaSans_500', 'PlusJakartaSans-Medium.ttf'),
    ('PlusJakartaSans_600', 'PlusJakartaSans-SemiBold.ttf'),
    ('PlusJakartaSans_700', 'PlusJakartaSans-Bold.ttf'),
    ('PlusJakartaSans_800', 'PlusJakartaSans-ExtraBold.ttf'),
  ]) {
    await (FontLoader(
      family,
    )..addFont(rootBundle.load('assets/fonts/google_fonts/$file'))).load();
  }
  for (final (family, files) in [
    ('JetBrainsMono', ['JetBrainsMono-Regular.ttf']),
    ('Sora', ['Sora-Bold.ttf', 'Sora-ExtraBold.ttf']),
    (
      'PlusJakartaSans',
      [
        'PlusJakartaSans-Regular.ttf',
        'PlusJakartaSans-Medium.ttf',
        'PlusJakartaSans-SemiBold.ttf',
        'PlusJakartaSans-Bold.ttf',
        'PlusJakartaSans-ExtraBold.ttf',
      ],
    ),
  ]) {
    final loader = FontLoader(family);
    for (final file in files) {
      loader.addFont(rootBundle.load('assets/fonts/google_fonts/$file'));
    }
    await loader.load();
  }
  await (FontLoader(
    'MaterialIcons',
  )..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'))).load();
}
