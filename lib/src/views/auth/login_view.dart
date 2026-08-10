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

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      SnackbarHelper.showError(context, 'Please fill in all fields');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final user = await ref.read(authRepositoryProvider).login(email, password);
      ref.read(currentUserProvider.notifier).setUser(user);
      if (mounted) {
        SnackbarHelper.showSuccess(context, 'Welcome back, ${user.name}!');
        context.go(RouteNames.home);
      }
    } catch (e) {
      if (mounted) SnackbarHelper.showError(context, 'Login failed');
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
                title: 'Welcome Back',
                subtitle: 'Sign in to access personalized radio channels and podcasts.',
              ),
              const SizedBox(height: 32),
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
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => context.push(RouteNames.forgotPassword),
                  child: const Text('Forgot Password?'),
                ),
              ),
              const SizedBox(height: 24),
              AppButton(
                title: 'Sign In',
                isLoading: _isLoading,
                onPressed: _handleLogin,
              ),
              const SizedBox(height: 24),
              AuthFooterWidget(
                questionText: "Don't have an account?",
                actionText: 'Register',
                onActionTap: () => context.push(RouteNames.register),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
