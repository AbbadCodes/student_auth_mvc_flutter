import '../models/auth_requests.dart';
import '../models/user_model.dart';
import 'auth_repository.dart';

/// محاكاة محلية لواجهة API. استبدل هذه الطبقة بطلبات HTTP في التطبيق الحقيقي.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl()
      : _users = [
          const UserModel(
            fullName: 'طالب تجريبي',
            studentId: '123456789',
            universityEmail: 'student@university.edu',
            password: 'Student1',
          ),
        ];

  final List<UserModel> _users;
  final Map<String, String> _issuedCodes = {};

  static const String demoOtp = '123456';

  String _normalize(String value) => value.trim().toLowerCase();

  UserModel? _findByIdentifier(String identifier) {
    final key = _normalize(identifier);
    for (final user in _users) {
      if (_normalize(user.studentId) == key ||
          _normalize(user.universityEmail) == key) {
        return user;
      }
    }
    return null;
  }

  @override
  Future<UserModel> login(LoginRequest request) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    final user = _findByIdentifier(request.identifier);
    if (user == null || user.password != request.password) {
      throw StateError('المعرف أو كلمة المرور غير صحيحة');
    }
    return user;
  }

  @override
  Future<UserModel> register(RegisterRequest request) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    final duplicate = _users.any((user) =>
        _normalize(user.studentId) == _normalize(request.studentId) ||
        _normalize(user.universityEmail) == _normalize(request.universityEmail));
    if (duplicate) {
      throw StateError('الرقم الأكاديمي أو البريد مسجل مسبقًا');
    }
    final user = UserModel(
      fullName: request.fullName.trim(),
      studentId: request.studentId.trim(),
      universityEmail: request.universityEmail.trim(),
      password: request.password,
    );
    _users.add(user);
    return user;
  }

  @override
  Future<void> sendPasswordResetCode(SendResetCodeRequest request) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    final user = _findByIdentifier(request.identifier);
    if (user == null) {
      throw StateError('لم يتم العثور على حساب بهذا البريد أو الرقم الأكاديمي');
    }
    final key = _normalize(request.identifier);
    // في التطبيق التجريبي لا يوجد إرسال فعلي؛ الرمز الثابت هو 123456.
    _issuedCodes[key] = demoOtp;
  }

  @override
  Future<void> resetPassword(ResetPasswordRequest request) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    final key = _normalize(request.identifier);
    if (_issuedCodes[key] != request.otp) {
      throw StateError('رمز التحقق غير صحيح أو لم يتم إصداره');
    }
    final index = _users.indexWhere((user) =>
        _normalize(user.studentId) == key || _normalize(user.universityEmail) == key);
    if (index < 0) throw StateError('الحساب غير موجود');
    _users[index] = _users[index].copyWith(password: request.newPassword);
    _issuedCodes.remove(key);
  }
}
