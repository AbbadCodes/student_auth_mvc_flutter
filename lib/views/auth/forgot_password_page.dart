import 'package:flutter/material.dart';

import '../../controllers/auth_controller.dart';
import '../../utils/form_validators.dart';
import 'auth_widgets.dart';
import 'login_page.dart';
import 'reset_password_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key, required this.controller});

  final AuthController controller;

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();

  @override
  void dispose() {
    _identifierController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final success = await widget.controller.sendPasswordResetCode(_identifierController.text);
    if (!mounted) return;
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.controller.errorMessage ?? 'تعذر إرسال الرمز'),
          backgroundColor: Colors.red.shade700,
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('تم إرسال رمز التحقق بنجاح'),
        backgroundColor: Colors.green.shade700,
        duration: const Duration(seconds: 2),
      ),
    );
    await Future<void>.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => ResetPasswordPage(controller: widget.controller)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) => AuthPageShell(
        title: 'استعادة الحساب',
        subtitle: 'سنساعدك على استعادة الوصول إلى حسابك الأكاديمي.',
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE9F5F6),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFC9E7E9)),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.mark_email_read_outlined, color: authTeal),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'أدخل بريدك الجامعي أو رقمك الأكاديمي. سنرسل رمز تحقق لمتابعة تعيين كلمة مرور جديدة.',
                        style: TextStyle(height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              AuthField(
                controller: _identifierController,
                label: 'البريد أو الرقم الأكاديمي',
                icon: Icons.person_search_outlined,
                validator: FormValidators.resetIdentifier,
                textDirection: TextDirection.ltr,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 18),
              AuthPrimaryButton(
                label: 'إرسال رمز التحقق',
                isLoading: widget.controller.isLoading,
                onPressed: _submit,
              ),
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => LoginPage(controller: widget.controller)),
                  (route) => false,
                ),
                icon: const Icon(Icons.arrow_forward),
                label: const Text('العودة لتسجيل الدخول'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
