# نظام مصادقة طلابي — Flutter / MVC + Repository

تطبيق تعليمي بأربع شاشات: تسجيل الدخول، إنشاء الحساب، استعادة الحساب، وتعيين كلمة مرور جديدة. يستخدم Flutter وDart فقط، ولا يعتمد على حزم خارجية.

## التشغيل

من مجلد المشروع:

```bash
flutter pub get
flutter run
```

يتطلب التشغيل وجود Flutter SDK مثبتًا على جهازك.

## بيانات التجربة

- المعرف الأكاديمي: `123456789`
- البريد: `student@university.edu`
- كلمة المرور: `Student1`
- رمز OTP التجريبي بعد طلب الاستعادة: `123456`

يمكن كذلك إنشاء حساب جديد من شاشة التسجيل. البيانات تحفظ في الذاكرة أثناء تشغيل التطبيق فقط.

## البنية

```text
lib/
├── main.dart
├── models/
│   ├── auth_requests.dart
│   └── user_model.dart
├── repositories/
│   ├── auth_repository.dart
│   └── auth_repository_impl.dart
├── controllers/
│   └── auth_controller.dart
├── utils/
│   └── form_validators.dart
└── views/auth/
    ├── auth_widgets.dart
    ├── login_page.dart
    ├── register_page.dart
    ├── forgot_password_page.dart
    └── reset_password_page.dart
```

- **Model:** `UserModel` ونماذج الطلبات.
- **Repository:** `AuthRepository` عقد العمليات و`AuthRepositoryImpl` تطبيق تجريبي يحاكي تأخير الشبكة.
- **Controller:** `AuthController extends ChangeNotifier` يدير التحميل والأخطاء والعمليات.
- **View:** الشاشات الأربع مستقلة عن تخزين البيانات، وتستخدم `GlobalKey<FormState>`.
- **Validation:** دوال ثابتة نقية في `FormValidators`.

## ملاحظات مهمة

هذا نموذج تعليمي محلي وليس نظام مصادقة إنتاجيًا: لا يوجد خادم أو إرسال بريد فعلي، ورمز OTP ثابت للتجربة، وكلمات المرور تبقى في الذاكرة كنص صريح. في التطبيق الحقيقي يجب استبدال تطبيق المستودع بـ API آمن واستخدام HTTPS وتجزئة كلمات المرور على الخادم وتدفق OTP حقيقي. مربع «تذكرني» واجهة توضيحية ولا يحفظ جلسة دائمًا، التزامًا بعدم إضافة حزم تخزين خارجية.
