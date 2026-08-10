import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../routes/route_names.dart';
import '../../../common/widgets/app_button.dart';
import '../../../common/helpers/snackbar_helper.dart';
import '../../providers/auth_provider.dart';
import 'widgets/auth_header.dart';
import 'widgets/auth_text_field.dart';
import 'widgets/auth_footer.dart';

class RegisterView extends ConsumerStatefulWidget {
  const RegisterView({super.key});

  @override
  ConsumerState<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends ConsumerState<RegisterView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleRegister() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      SnackbarHelper.showError(context, 'Please fill in all fields');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final user = await ref.read(authRepositoryProvider).register(name, email, password);
      ref.read(currentUserProvider.notifier).setUser(user);
      if (mounted) {
        SnackbarHelper.showSuccess(context, 'Account created successfully!');
        context.go(RouteNames.home);
      }
    } catch (e) {
      if (mounted) SnackbarHelper.showError(context, 'Registration failed');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AuthHeaderWidget(
                title: 'Create Account',
                subtitle: 'Join 93.5 Area FM listener community today.',
              ),
              const SizedBox(height: 32),
              AuthTextFieldWidget(
                controller: _nameController,
                labelText: 'Full Name',
                hintText: 'John Doe',
                prefixIcon: const Icon(Icons.person_outline),
              ),
              const SizedBox(height: 16),
              AuthTextFieldWidget(
                controller: _emailController,
                labelText: 'Email Address',
                hintText: 'name@example.com',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.email_outlined),
              ),
              const SizedBox(height: 16),
              AuthTextFieldWidget(
                controller: _passwordController,
                labelText: 'Password',
                hintText: '••••••••',
                obscureText: true,
                prefixIcon: const Icon(Icons.lock_outline),
              ),
              const SizedBox(height: 24),
              AppButton(
                title: 'Register',
                isLoading: _isLoading,
                onPressed: _handleRegister,
              ),
              const SizedBox(height: 24),
              AuthFooterWidget(
                questionText: 'Already have an account?',
                actionText: 'Sign In',
                onActionTap: () => context.pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
