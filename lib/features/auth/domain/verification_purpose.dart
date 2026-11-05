enum VerificationPurpose {
  activation('activation'),
  passwordReset('forgot-password');

  const VerificationPurpose(this.apiPath);
  final String apiPath;
}
