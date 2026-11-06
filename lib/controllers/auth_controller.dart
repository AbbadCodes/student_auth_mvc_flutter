import 'package:flutter/foundation.dart';

import '../models/auth_requests.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';

class AuthController extends ChangeNotifier {
  AuthController(this._repository);

  final AuthRepository _repository;

  bool isLoading = false;
  String? errorMessage;
  UserModel? currentUser;
  String? _resetIdentifier;

  String? get resetIdentifier => _resetIdentifier;

  void _begin() {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
  }

  void _failed(Object error) {
    final message = error.toString();
    errorMessage = message.startsWith('Bad state: ')
        ? message.substring('Bad state: '.length)
        : message;
    isLoading = false;
    notifyListeners();
  }

  Future<bool> login(LoginRequest request) async {
    _begin();
    try {
      currentUser = await _repository.login(request);
      isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _failed(error);
      return false;
    }
  }

  Future<bool> register(RegisterRequest request) async {
    _begin();
    try {
      await _repository.register(request);
      isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _failed(error);
      return false;
    }
  }

  Future<bool> sendPasswordResetCode(String identifier) async {
    _begin();
    try {
      await _repository.sendPasswordResetCode(
        SendResetCodeRequest(identifier: identifier.trim()),
      );
      _resetIdentifier = identifier.trim();
      isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _failed(error);
      return false;
    }
  }

  Future<bool> resetPassword({required String otp, required String newPassword}) async {
    final identifier = _resetIdentifier;
    if (identifier == null) {
      errorMessage = 'ابدأ بطلب رمز التحقق أولًا';
      notifyListeners();
      return false;
    }
    _begin();
    try {
      await _repository.resetPassword(
        ResetPasswordRequest(
          identifier: identifier,
          otp: otp.trim(),
          newPassword: newPassword,
        ),
      );
      _resetIdentifier = null;
      isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _failed(error);
      return false;
    }
  }
}
