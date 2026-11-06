import 'package:flutter/material.dart';

import '../../controllers/auth_controller.dart';
import '../../models/auth_requests.dart';
import '../../utils/form_validators.dart';
import 'auth_widgets.dart';
import 'forgot_password_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.controller});

  final AuthController controller;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final success = await widget.controller.login(
      LoginRequest(
        identifier: _identifierController.text.trim(),
        password: _passwordController.text,
      ),
    );
    if (!mounted) return;
    final message = success
        ? 'مرحبًا ${widget.controller.currentUser?.fullName}، تم تسجيل الدخول بنجاح'
        : widget.controller.errorMessage ?? 'تعذر تسجيل الدخول';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? Colors.green.shade700 : Colors.red.shade700,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) => AuthPageShell(
        title: 'تسجيل الدخول',
        subtitle: 'ادخل إلى بوابتك الأكاديمية بأمان.',
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthField(
                controller: _identifierController,
                label: 'المعرف الأكاديمي أو البريد',
                icon: Icons.person_outline,
                validator: FormValidators.loginIdentifier,
                textDirection: TextDirection.ltr,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.username],
              ),
              const SizedBox(height: 16),
              AuthField(
                controller: _passwordController,
                label: 'كلمة المرور',
                icon: Icons.lock_outline,
                validator: FormValidators.loginPassword,
                obscureText: _obscurePassword,
                autofillHints: const [AutofillHints.password],
                suffix: IconButton(
                  tooltip: _obscurePassword ? 'إظهار كلمة المرور' : 'إخفاء كلمة المرور',
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    activeColor: authTeal,
                    onChanged: (value) => setState(() => _rememberMe = value ?? false),
                  ),
                  const Text('تذكرني'),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ForgotPasswordPage(controller: widget.controller),
                      ),
                    ),
                    child: const Text('نسيت كلمة المرور؟'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              AuthPrimaryButton(
                label: 'تسجيل الدخول',
                isLoading: widget.controller.isLoading,
                onPressed: _submit,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('ليس لديك حساب؟'),
                  TextButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => RegisterPage(controller: widget.controller),
                      ),
                    ),
                    child: const Text('إنشاء حساب جديد'),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'حساب تجريبي: 123456789  |  كلمة المرور: Student1',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: Colors.blueGrey.shade500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
