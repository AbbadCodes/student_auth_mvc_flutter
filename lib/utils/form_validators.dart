class FormValidators {
  FormValidators._();

  static final RegExp _emailPattern = RegExp(
    r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
  );
  static final RegExp _digitsPattern = RegExp(r'^\d+$');
  static final RegExp _strongPasswordPattern = RegExp(r'^(?=.*[A-Z])(?=.*\d).{8,}$');

  static String? loginIdentifier(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'هذا الحقل مطلوب';
    if (text.length < 5) return 'يجب ألا يقل المعرف عن 5 خانات';
    if (text.contains('@') && !_emailPattern.hasMatch(text)) {
      return 'أدخل بريدًا إلكترونيًا صحيحًا';
    }
    return null;
  }

  static String? loginPassword(String? value) {
    if (value == null || value.isEmpty) return 'كلمة المرور مطلوبة';
    if (value.length < 6) return 'يجب ألا تقل كلمة المرور عن 6 محارف';
    return null;
  }

  static String? fullName(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'الاسم الكامل مطلوب';
    if (text.length < 3) return 'يجب ألا يقل الاسم عن 3 محارف';
    return null;
  }

  static String? studentId(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'الرقم الأكاديمي مطلوب';
    if (!_digitsPattern.hasMatch(text)) return 'استخدم الأرقام فقط';
    if (text.length < 9 || text.length > 10) {
      return 'يجب أن يتكون الرقم الأكاديمي من 9 أو 10 أرقام';
    }
    return null;
  }

  static String? universityEmail(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'البريد الجامعي مطلوب';
    if (!_emailPattern.hasMatch(text)) return 'أدخل بريدًا إلكترونيًا صحيحًا';
    return null;
  }

  static String? strongPassword(String? value) {
    if (value == null || value.isEmpty) return 'كلمة المرور مطلوبة';
    if (!_strongPasswordPattern.hasMatch(value)) {
      return '8 محارف على الأقل، مع رقم وحرف إنجليزي كبير';
    }
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) return 'تأكيد كلمة المرور مطلوب';
    if (value != password) return 'كلمتا المرور غير متطابقتين';
    return null;
  }

  static String? resetIdentifier(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'أدخل البريد أو الرقم الأكاديمي';
    if (text.length < 5) return 'يجب ألا يقل المعرف عن 5 خانات';
    if (text.contains('@')) {
      return _emailPattern.hasMatch(text) ? null : 'أدخل بريدًا إلكترونيًا صحيحًا';
    }
    return _digitsPattern.hasMatch(text) ? null : 'أدخل بريدًا صحيحًا أو رقمًا أكاديميًا';
  }

  static String? otp(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'رمز التحقق مطلوب';
    if (!RegExp(r'^\d{6}$').hasMatch(text)) return 'أدخل 6 أرقام بالضبط';
    return null;
  }
}
