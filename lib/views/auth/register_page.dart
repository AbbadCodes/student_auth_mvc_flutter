import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../controllers/auth_controller.dart';
import '../../models/auth_requests.dart';
import '../../utils/form_validators.dart';
import 'auth_widgets.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.controller});

  final AuthController controller;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameController.dispose();
    _studentIdController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final success = await widget.controller.register(
      RegisterRequest(
        fullName: _nameController.text.trim(),
        studentId: _studentIdController.text.trim(),
        universityEmail: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
    if (!mounted) return;
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.controller.errorMessage ?? 'تعذر إنشاء الحساب'),
          backgroundColor: Colors.red.shade700,
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: const Text('تم إنشاء الحساب بنجاح'), backgroundColor: Colors.green.shade700),
    );
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
        title: 'إنشاء حساب',
        subtitle: 'سجّل بياناتك الأكاديمية لإنشاء حساب الطالب.',
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthField(
                controller: _nameController,
                label: 'الاسم الكامل',
                icon: Icons.badge_outlined,
                validator: FormValidators.fullName,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 14),
              AuthField(
                controller: _studentIdController,
                label: 'الرقم الأكاديمي (9–10 أرقام)',
                icon: Icons.numbers,
                validator: FormValidators.studentId,
                keyboardType: TextInputType.number,
                textDirection: TextDirection.ltr,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                maxLength: 10,
              ),
              const SizedBox(height: 14),
              AuthField(
                controller: _emailController,
                label: 'البريد الجامعي',
                icon: Icons.alternate_email,
                validator: FormValidators.universityEmail,
                keyboardType: TextInputType.emailAddress,
                textDirection: TextDirection.ltr,
              ),
              const SizedBox(height: 14),
              AuthField(
                controller: _passwordController,
                label: 'كلمة المرور (8+، رقم وحرف كبير)',
                icon: Icons.lock_outline,
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
                label: 'تأكيد كلمة المرور',
                icon: Icons.lock_reset_outlined,
                validator: (value) => FormValidators.confirmPassword(value, _passwordController.text),
                obscureText: _obscureConfirm,
                suffix: IconButton(
                  onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                  icon: Icon(_obscureConfirm ? Icons.visibility : Icons.visibility_off),
                ),
              ),
              const SizedBox(height: 8),
              FormField<bool>(
                initialValue: false,
                validator: (value) => value == true ? null : 'يجب الموافقة على اللوائح والشروط',
                builder: (field) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: authTeal,
                      value: field.value ?? false,
                      onChanged: field.didChange,
                      title: const Text('أوافق على اللوائح والشروط الأكاديمية', style: TextStyle(fontSize: 13)),
                    ),
                    if (field.hasError)
                      Padding(
                        padding: const EdgeInsetsDirectional.only(start: 12, bottom: 6),
                        child: Text(field.errorText!, style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12)),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              AuthPrimaryButton(
                label: 'إنشاء الحساب',
                isLoading: widget.controller.isLoading,
                onPressed: _submit,
              ),
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_forward),
                label: const Text('لديك حساب؟ العودة لتسجيل الدخول'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
