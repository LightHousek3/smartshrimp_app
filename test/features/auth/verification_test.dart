import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/app/app.dart';
import 'package:smartshrimp_app/app/router/app_router.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/core/widgets/app_form_field.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/core/storage/session_store.dart';
import 'package:smartshrimp_app/features/auth/data/services/verification_api_service.dart';
import 'package:smartshrimp_app/features/auth/domain/auth_form_rules.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/verification_state.dart';
import 'package:smartshrimp_app/features/auth/domain/verification_purpose.dart';
import 'package:smartshrimp_app/features/auth/presentation/pages/login_page.dart';
import 'package:smartshrimp_app/features/auth/presentation/pages/verification_page.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/verification_controller.dart';
import 'package:smartshrimp_app/features/auth/presentation/widgets/auth_widgets.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:smartshrimp_app/features/profile/domain/profile_rules.dart';
import '../../support/load_app_fonts.dart';

class _Remote implements VerificationRemoteDataSource {
  int requests = 0;
  Object? error;
  Completer<void>? pending;
  Map<String, dynamic>? payload;
  @override
  Future<void> requestOtp(String email, VerificationPurpose purpose) async {
    requests++;
    await pending?.future;
    if (error != null) throw error!;
  }

  @override
  Future<String> verifyOtp(
    String email,
    String code,
    VerificationPurpose purpose,
  ) async {
    if (error != null) throw error!;
    return 'a' * 43;
  }

  @override
  Future<void> activate(Map<String, dynamic> payload) async {
    this.payload = payload;
    if (error != null) throw error!;
  }

  @override
  Future<void> resetPassword(Map<String, dynamic> payload) => activate(payload);
}

class _Auth implements AuthRepository {
  @override
  Future<AuthAccount?> restoreSession() async => null;
  @override
  Future<AuthAccount> login({
    required String email,
    required String password,
  }) => throw UnimplementedError();
  @override
  Future<void> logout() async {}
}

class _Store implements SessionStore {
  @override
  String? get accessToken => 'existing-access';
  @override
  String? get refreshToken => 'existing-refresh';
  @override
  Future<void> initialize() async {}
  @override
  Future<void> clear() async {}
  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {}
}

void main() {
  for (final purpose in VerificationPurpose.values) {
    for (final (size, textScale) in [
      (const Size(402, 874), 1.0),
      (const Size(320, 568), 1.6),
    ]) {
      testWidgets(
        '${purpose.name}: OTP spacing stays even with guidance at $size/$textScale',
        (tester) async {
          final remote = _Remote();
          await _openVerification(
            tester,
            remote,
            purpose,
            size: size,
            textScale: textScale,
          );
          await tester.tap(
            find.text(
              purpose == VerificationPurpose.activation
                  ? 'Gửi mã kích hoạt'
                  : 'Gửi mã xác thực',
            ),
          );
          await tester.pumpAndSettle();
          final input = find.byKey(const Key('otp_digit_0'));
          final confirm = find.widgetWithText(AuthSubmitButton, 'Xác nhận mã');
          final resend = find.byKey(const Key('verification_resend'));
          expect(
            tester.getTopLeft(confirm).dy - tester.getBottomLeft(input).dy,
            closeTo(16, .01),
          );
          expect(
            tester.getTopLeft(resend).dy - tester.getBottomLeft(confirm).dy,
            closeTo(16, .01),
          );
          final cooldownHeight = tester.getSize(resend).height;
          remote.error = ApiException(
            purpose == VerificationPurpose.activation
                ? 'Tài khoản đã được kích hoạt. Vui lòng đăng nhập.'
                : 'Tài khoản chưa được kích hoạt. Vui lòng làm theo hướng dẫn bên dưới để tiếp tục.',
            statusCode: 403,
            details: {
              'code': purpose == VerificationPurpose.activation
                  ? 'AUTH_ACCOUNT_ALREADY_ACTIVATED'
                  : 'AUTH_PENDING_ACTIVATION',
            },
          );
          await tester.enterText(input, '012345');
          await tester.ensureVisible(confirm);
          await tester.tap(confirm);
          await tester.pumpAndSettle();
          final error = find.byKey(const Key('verification_error'));
          final guidance = find.byKey(const Key('verification_guidance'));
          expect(
            find.widgetWithText(
              TextButton,
              purpose == VerificationPurpose.activation
                  ? 'Đăng nhập'
                  : 'Kích hoạt tài khoản',
            ),
            findsOneWidget,
          );
          expect(
            tester.getTopLeft(error).dy - tester.getBottomLeft(input).dy,
            closeTo(16, .01),
          );
          expect(
            tester.getTopLeft(guidance).dy - tester.getBottomLeft(error).dy,
            closeTo(16, .01),
          );
          expect(
            tester.getTopLeft(confirm).dy - tester.getBottomLeft(guidance).dy,
            closeTo(16, .01),
          );
          expect(
            tester.getTopLeft(resend).dy - tester.getBottomLeft(confirm).dy,
            closeTo(16, .01),
          );
          expect(tester.getSize(resend).height, cooldownHeight);
          expect(tester.takeException(), isNull);
          await tester.ensureVisible(guidance);
          await tester.tap(guidance);
          await tester.pumpAndSettle();
          if (purpose == VerificationPurpose.activation) {
            expect(find.byType(LoginPage), findsOneWidget);
            expect(
              tester
                  .widget<AppTextField>(
                    find.byKey(const Key('login_email_field')),
                  )
                  .controller!
                  .text,
              'owner@example.com',
            );
          } else {
            expect(find.text('Kích hoạt tài khoản'), findsOneWidget);
          }
          expect(tester.takeException(), isNull);
          await tester.pumpWidget(const SizedBox());
        },
      );
    }

    testWidgets(
      '${purpose.name}: local, server and network OTP errors stay between input and confirm button',
      (tester) async {
        final remote = _Remote();
        await _openVerification(tester, remote, purpose);
        await tester.tap(
          find.text(
            purpose == VerificationPurpose.activation
                ? 'Gửi mã kích hoạt'
                : 'Gửi mã xác thực',
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text('Xác nhận mã'));
        await tester.pumpAndSettle();
        _expectOtpErrorPosition(tester, 'Vui lòng nhập đủ 6 chữ số.');
        remote.error = const ApiException(
          'Mã OTP không hợp lệ',
          statusCode: 400,
          details: {'code': 'AUTH_INVALID_OTP'},
        );
        await tester.enterText(find.byKey(const Key('otp_digit_0')), '012345');
        await tester.tap(find.text('Xác nhận mã'));
        await tester.pumpAndSettle();
        _expectOtpErrorPosition(tester, 'Mã OTP không hợp lệ');
        await tester.enterText(find.byKey(const Key('otp_digit_0')), '111111');
        await tester.pump();
        expect(find.text('Mã OTP không hợp lệ'), findsNothing);
        remote.error = const NetworkException();
        await tester.tap(find.text('Xác nhận mã'));
        await tester.pumpAndSettle();
        _expectOtpErrorPosition(tester, const NetworkException().message);
        await tester.pumpWidget(const SizedBox());
      },
    );

    testWidgets(
      '${purpose.name}: strength is shared; successful completion returns immediately to login with a blue banner',
      (tester) async {
        final remote = _Remote();
        final container = await _openVerification(tester, remote, purpose);
        await tester.tap(
          find.text(
            purpose == VerificationPurpose.activation
                ? 'Gửi mã kích hoạt'
                : 'Gửi mã xác thực',
          ),
        );
        await tester.pumpAndSettle();
        await tester.enterText(find.byKey(const Key('otp_digit_0')), '012345');
        await tester.tap(find.text('Xác nhận mã'));
        await tester.pumpAndSettle();
        expect(find.byType(AuthPasswordStrength), findsOneWidget);
        for (final (password, label) in [
          ('abc', 'Quá ngắn'),
          ('abcdef', 'Trung bình'),
          ('Abcdef12', 'Khá mạnh'),
          ('Abcdef123!@#', 'Mạnh'),
        ]) {
          await tester.enterText(
            find.byKey(const Key('verification_password')),
            password,
          );
          await tester.pump();
          expect(find.text(label), findsOneWidget);
        }
        if (purpose == VerificationPurpose.activation) {
          await tester.enterText(
            find.byKey(const Key('activation_name')),
            'Trần An',
          );
        }
        await tester.enterText(
          find.byKey(const Key('verification_confirmation')),
          'Abcdef123!@#',
        );
        final submit = find.widgetWithText(
          AuthSubmitButton,
          purpose == VerificationPurpose.activation
              ? 'Hoàn tất & kích hoạt'
              : 'Xác nhận mật khẩu mới',
        );
        await tester.ensureVisible(submit);
        remote.error = const ApiException(
          'Không thể lưu. Vui lòng thử lại.',
          statusCode: 500,
        );
        await tester.tap(submit);
        await tester.pumpAndSettle();
        expect(find.byType(VerificationPage), findsOneWidget);
        expect(find.text('Không thể lưu. Vui lòng thử lại.'), findsOneWidget);
        remote.error = null;
        await tester.ensureVisible(submit);
        await tester.tap(submit);
        await tester.pumpAndSettle();
        expect(find.byType(LoginPage), findsOneWidget);
        expect(find.byType(VerificationPage), findsNothing);
        expect(find.text('Về đăng nhập'), findsNothing);
        expect(
          find.text(
            purpose == VerificationPurpose.activation
                ? 'Kích hoạt tài khoản thành công'
                : 'Đặt lại mật khẩu thành công',
          ),
          findsOneWidget,
        );
        expect(
          tester
              .widget<AppTextField>(find.byKey(const Key('login_email_field')))
              .controller!
              .text,
          'owner@example.com',
        );
        final banner = find.byType(AppFormMessageBanner);
        expect(banner, findsOneWidget);
        expect(find.byType(AppFormErrorBanner), findsNothing);
        final icon = tester.widget<Icon>(
          find.descendant(of: banner, matching: find.byType(Icon)),
        );
        expect(icon.icon, Icons.info_outline_rounded);
        expect(icon.color, AppColors.ocean);
        container
            .read(appRouterProvider)
            .go('/login?email=owner%40example.com');
        await tester.pumpAndSettle();
        expect(find.byType(AppFormMessageBanner), findsNothing);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
      },
    );
  }
  test(
    'B: shared profile validation normalizes NFC and validates characters/bytes without trimming passwords',
    () {
      expect(ProfileRules.normalizeFullName('  Trần   An  '), 'Trần An');
      for (final length in [2, 50]) {
        expect(AuthFormRules.fullName('A' * length), isNull);
      }
      for (final value in ['', 'A', 'A' * 51, '123']) {
        expect(AuthFormRules.fullName(value), isNotNull);
      }
      for (final value in ['p' * 6, 'p' * 71, 'p' * 72, '😀' * 18]) {
        expect(AuthFormRules.password(value), isNull);
      }
      for (final value in ['p' * 5, 'p' * 73, '😀' * 19]) {
        expect(AuthFormRules.password(value), isNotNull);
      }
      expect(ProfileRules.normalizePhone('+84 912 345 678'), '0912345678');
      expect(ProfileRules.validatePhone(''), isNull);
      expect(ProfileRules.validatePhone('0123456789'), isNotNull);
      expect(AuthFormRules.confirmation('secret ', 'secret '), isNull);
      expect(AuthFormRules.confirmation('secret', 'secret '), isNotNull);
    },
  );
  test(
    'N/A: six API requests are public with exact paths/payloads and strict token parsing',
    () async {
      final requests = <RequestOptions>[];
      var malformed = false;
      final dio = Dio(BaseOptions(baseUrl: 'http://test/api/v1'))
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (request, handler) {
              requests.add(request);
              handler.resolve(
                Response(
                  requestOptions: request,
                  statusCode: 200,
                  data: {
                    'success': true,
                    'message': 'OK',
                    'data': {'actionToken': malformed ? '' : 'a' * 43},
                  },
                ),
              );
            },
          ),
        );
      final api = VerificationApiService(ApiClient(dio, _Store()));
      for (final purpose in VerificationPurpose.values) {
        await api.requestOtp('owner@example.com', purpose);
        expect(
          await api.verifyOtp('owner@example.com', '012345', purpose),
          'a' * 43,
        );
      }
      await api.activate({
        'actionToken': 'token',
        'fullName': 'An',
        'phone': null,
        'password': ' secret ',
      });
      await api.resetPassword({'actionToken': 'token', 'password': ' secret '});
      expect(requests.map((request) => request.path), [
        '/auth/activation/request-otp',
        '/auth/activation/verify-otp',
        '/auth/forgot-password/request-otp',
        '/auth/forgot-password/verify-otp',
        '/auth/activation/complete',
        '/auth/forgot-password/reset',
      ]);
      expect(
        requests.every(
          (request) =>
              request.method == 'POST' &&
              request.headers['Authorization'] == null,
        ),
        isTrue,
      );
      expect(requests[1].data, {
        'email': 'owner@example.com',
        'code': '012345',
      });
      expect(requests.last.data['password'], ' secret ');
      malformed = true;
      await expectLater(
        api.verifyOtp(
          'owner@example.com',
          '012345',
          VerificationPurpose.activation,
        ),
        throwsA(isA<InvalidResponseException>()),
      );
    },
  );
  test(
    'N/B: controller serializes requests, preserves cooldown and drops action tokens',
    () async {
      final remote = _Remote()..pending = Completer<void>();
      final container = ProviderContainer(
        overrides: [
          verificationRemoteDataSourceProvider.overrideWithValue(remote),
        ],
      );
      addTearDown(container.dispose);
      final provider = verificationControllerProvider((
        purpose: VerificationPurpose.activation,
        initialEmail: '',
      ));
      final subscription = container.listen(provider, (_, _) {});
      addTearDown(subscription.close);
      final controller = container.read(provider.notifier);
      final pending = controller.requestOtp(' OWNER@EXAMPLE.COM ');
      await controller.requestOtp('different@example.com');
      expect(remote.requests, 1);
      remote.pending!.complete();
      await pending;
      expect(container.read(provider).email, 'owner@example.com');
      await controller.verifyOtp('012345');
      expect(container.read(provider).actionToken, isNotNull);
      controller.backToEmail();
      expect(container.read(provider).actionToken, isNull);
      await controller.requestOtp('owner@example.com');
      expect(remote.requests, 1);
      await controller.verifyOtp('012345');
      await controller.complete(
        password: ' secret ',
        fullName: '  Trần  An ',
        phone: '',
      );
      expect(remote.payload, containsPair('fullName', 'Trần An'));
      expect(remote.payload, containsPair('phone', null));
      expect(container.read(provider).step, VerificationStep.success);
      expect(container.read(provider).actionToken, isNull);
    },
  );
  test(
    'A: invalid action token returns to OTP; disposal ignores late requests',
    () async {
      final remote = _Remote();
      final container = ProviderContainer(
        overrides: [
          verificationRemoteDataSourceProvider.overrideWithValue(remote),
        ],
      );
      final provider = verificationControllerProvider((
        purpose: VerificationPurpose.activation,
        initialEmail: '',
      ));
      container.listen(provider, (_, _) {});
      final controller = container.read(provider.notifier);
      await controller.requestOtp('a@example.com');
      await controller.verifyOtp('012345');
      remote.error = const ApiException(
        'Hết phiên',
        statusCode: 400,
        details: {'code': 'AUTH_INVALID_ACTION_TOKEN'},
      );
      await controller.complete(password: 'secret', fullName: 'An');
      expect(container.read(provider).step, VerificationStep.otp);
      expect(container.read(provider).actionToken, isNull);
      remote.error = null;
      remote.pending = Completer<void>();
      controller.backToEmail();
      final pending = controller.requestOtp('b@example.com');
      container.dispose();
      remote.pending!.complete();
      await pending;
    },
  );
  for (final size in [
    const Size(320, 568),
    const Size(360, 640),
    const Size(390, 844),
    const Size(402, 874),
    const Size(1440, 900),
  ]) {
    testWidgets('B: login fits viewport $size without scrolling', (
      tester,
    ) async {
      await loadAppFonts();
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [authRepositoryProvider.overrideWithValue(_Auth())],
          child: MaterialApp(theme: AppTheme.light, home: const LoginPage()),
        ),
      );
      await tester.pumpAndSettle();
      final scrollable = tester.state<ScrollableState>(
        find.byType(Scrollable).first,
      );
      expect(scrollable.position.maxScrollExtent, 0);
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets(
    'N/A: activation supports prefill, six-digit paste, required fields and retry',
    (tester) async {
      await loadAppFonts();
      tester.view.physicalSize = const Size(402, 874);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final remote = _Remote();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            verificationRemoteDataSourceProvider.overrideWithValue(remote),
          ],
          child: MaterialApp(
            theme: AppTheme.light,
            home: const VerificationPage(
              purpose: VerificationPurpose.activation,
              initialEmail: 'owner@example.com',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('owner@example.com'), findsOneWidget);
      await tester.tap(find.text('Gửi mã kích hoạt'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('otp_digit_0')), '012345');
      expect(
        tester
            .widget<TextField>(find.byKey(const Key('otp_digit_0')))
            .controller!
            .text,
        '0',
      );
      await tester.tap(find.text('Xác nhận mã'));
      await tester.pumpAndSettle();
      expect(find.text('Hoàn tất hồ sơ'), findsOneWidget);
      await tester.tap(find.text('Hoàn tất & kích hoạt'));
      await tester.pumpAndSettle();
      expect(find.text('Vui lòng nhập họ và tên.'), findsOneWidget);
      expect(find.text('Vui lòng nhập mật khẩu.'), findsOneWidget);
      expect(find.text('Vui lòng xác nhận mật khẩu.'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );
}

Future<ProviderContainer> _openVerification(
  WidgetTester tester,
  _Remote remote,
  VerificationPurpose purpose, {
  Size size = const Size(402, 874),
  double textScale = 1,
}) async {
  await loadAppFonts();
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        verificationRemoteDataSourceProvider.overrideWithValue(remote),
        authRepositoryProvider.overrideWithValue(_Auth()),
      ],
      child: const SmartShrimpApp(),
    ),
  );
  await tester.pumpAndSettle();
  final container = ProviderScope.containerOf(
    tester.element(find.byType(SmartShrimpApp)),
  );
  final path = purpose == VerificationPurpose.activation
      ? AppRoutes.activateAccount
      : AppRoutes.forgotPassword;
  container.read(appRouterProvider).go('$path?email=owner%40example.com');
  await tester.pumpAndSettle();
  return container;
}

void _expectOtpErrorPosition(WidgetTester tester, String message) {
  final error = find.byKey(const Key('verification_error'));
  expect(error, findsOneWidget);
  expect(find.text(message), findsOneWidget);
  final input = find.byKey(const Key('otp_digit_0'));
  final button = find.widgetWithText(AuthSubmitButton, 'Xác nhận mã');
  expect(
    tester.getTopLeft(error).dy - tester.getBottomLeft(input).dy,
    closeTo(16, .01),
  );
  expect(
    tester.getTopLeft(button).dy - tester.getBottomLeft(error).dy,
    closeTo(16, .01),
  );
}
