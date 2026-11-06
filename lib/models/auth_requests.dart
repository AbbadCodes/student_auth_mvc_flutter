class LoginRequest {
  const LoginRequest({required this.identifier, required this.password});

  final String identifier;
  final String password;
}

class RegisterRequest {
  const RegisterRequest({
    required this.fullName,
    required this.studentId,
    required this.universityEmail,
    required this.password,
  });

  final String fullName;
  final String studentId;
  final String universityEmail;
  final String password;
}

class SendResetCodeRequest {
  const SendResetCodeRequest({required this.identifier});

  final String identifier;
}

class ResetPasswordRequest {
  const ResetPasswordRequest({
    required this.identifier,
    required this.otp,
    required this.newPassword,
  });

  final String identifier;
  final String otp;
  final String newPassword;
}
