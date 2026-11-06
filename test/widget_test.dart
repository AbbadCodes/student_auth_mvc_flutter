import 'package:flutter_test/flutter_test.dart';
import 'package:student_auth_mvc_flutter/main.dart';

void main() {
  testWidgets('يعرض شاشة تسجيل الدخول', (WidgetTester tester) async {
    await tester.pumpWidget(const StudentAuthApp());

    expect(find.text('تسجيل الدخول'), findsOneWidget);
    expect(find.text('المعرف الأكاديمي أو البريد'), findsOneWidget);
    expect(find.text('إنشاء حساب جديد'), findsOneWidget);
  });
}
