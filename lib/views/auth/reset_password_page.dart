import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../controllers/auth_controller.dart';
import '../../utils/form_validators.dart';
import 'auth_widgets.dart';
import 'login_page.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key, required this.controller});

  final AuthController controller;

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _otpController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final success = await widget.controller.resetPassword(
      otp: _otpController.text,
      newPassword: _passwordController.text,
    );
    if (!mounted) return;
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.controller.errorMessage ?? 'تعذر تحديث كلمة المرور'),
          backgroundColor: Colors.red.shade700,
        ),
      );
      return;
    }
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        icon: Icon(Icons.check_circle, color: Colors.green.shade700, size: 42),
        title: const Text('تم تحديث كلمة المرور'),
        content: const Text('أصبحت كلمة المرور الجديدة جاهزة. يمكنك تسجيل الدخول الآن.'),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('الانتقال لتسجيل الدخول'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => LoginPage(controller: widget.controller)),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) => AuthPageShell(
        title: 'تعيين كلمة مرور جديدة',
        subtitle: 'أدخل رمز التحقق ثم اختر كلمة مرور قوية.',
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthField(
                controller: _otpController,
                label: 'رمز التحقق (6 أرقام)',
                icon: Icons.password_outlined,
                validator: FormValidators.otp,
                keyboardType: TextInputType.number,
                textDirection: TextDirection.ltr,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                maxLength: 6,
              ),
              const SizedBox(height: 14),
              AuthField(
                controller: _passwordController,
                label: 'كلمة المرور الجديدة',
                icon: Icons.lock_reset_outlined,
                validator: FormValidators.strongPassword,
                obscureText: _obscurePassword,
                suffix: IconButton(
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                ),
              ),
              const SizedBox(height: 14),
              AuthField(
                controller: _confirmController,
                label: 'تأكيد كلمة المرور الجديدة',
                icon: Icons.lock_outline,
                validator: (value) => FormValidators.confirmPassword(value, _passwordController.text),
                obscureText: _obscureConfirm,
                suffix: IconButton(
                  onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                  icon: Icon(_obscureConfirm ? Icons.visibility : Icons.visibility_off),
                ),
              ),
              const SizedBox(height: 20),
              AuthPrimaryButton(
                label: 'تحديث كلمة المرور',
                isLoading: widget.controller.isLoading,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
