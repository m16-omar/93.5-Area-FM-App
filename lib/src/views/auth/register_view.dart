import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../const/app_colors.dart';
import '../../../const/app_assets.dart';
import '../../routes/route_names.dart';
import '../../providers/auth_provider.dart';
import '../../../common/helpers/snackbar_helper.dart';

class RegisterView extends ConsumerStatefulWidget {
  const RegisterView({super.key});

  @override
  ConsumerState<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends ConsumerState<RegisterView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_agreedToTerms) {
      SnackbarHelper.showError(context, 'Please agree to the Terms of Use');
      return;
    }
    if (_passwordController.text != _confirmController.text) {
      SnackbarHelper.showError(context, 'Passwords do not match');
      return;
    }
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
      if (mounted) SnackbarHelper.showError(context, 'Registration failed. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            right: -10,
            top: 0,
            width: size.width * 0.68,
            height: size.height * 0.38,
            child: Image.asset(
              AppAssets.studioMicOnly,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.black,
                  Colors.black.withValues(alpha: 0.85),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.45, 1.0],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.3),
                  Colors.black.withValues(alpha: 0.7),
                  Colors.black,
                ],
                stops: const [0.0, 0.35, 0.65],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _LogoBadge(),
                  const SizedBox(height: 16),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'JOIN THE\n',
                          style: GoogleFonts.bebasNeue(
                            fontSize: 48,
                            color: Colors.white,
                            letterSpacing: 2,
                            height: 0.95,
                          ),
                        ),
                        TextSpan(
                          text: 'AREA ',
                          style: GoogleFonts.bebasNeue(
                            fontSize: 48,
                            color: AppColors.primary,
                            letterSpacing: 2,
                            height: 0.95,
                          ),
                        ),
                        TextSpan(
                          text: 'FAMILY!',
                          style: GoogleFonts.bebasNeue(
                            fontSize: 48,
                            color: Colors.white,
                            letterSpacing: 2,
                            height: 0.95,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(width: 36, height: 3, color: AppColors.primary),
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Create your account and enjoy live radio, amazing shows and ',
                          style: GoogleFonts.inter(color: Colors.white70, fontSize: 13, height: 1.5),
                        ),
                        TextSpan(
                          text: 'non-stop vibes.',
                          style: GoogleFonts.inter(
                            color: AppColors.primary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _FieldLabel(text: 'FULL NAME'),
                  const SizedBox(height: 8),
                  _DarkField(controller: _nameController, hint: 'Enter your full name', icon: Icons.person_outline_rounded),
                  const SizedBox(height: 14),
                  _FieldLabel(text: 'EMAIL ADDRESS'),
                  const SizedBox(height: 8),
                  _DarkField(controller: _emailController, hint: 'Enter your email', icon: Icons.email_outlined, keyboard: TextInputType.emailAddress),
                  const SizedBox(height: 14),
                  _FieldLabel(text: 'PHONE NUMBER'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                          decoration: const BoxDecoration(
                            border: Border(right: BorderSide(color: Colors.white24)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.phone_outlined, color: Colors.white38, size: 18),
                              const SizedBox(width: 6),
                              Text('+234', style: GoogleFonts.inter(color: Colors.white70, fontSize: 14)),
                              const SizedBox(width: 4),
                              const Icon(Icons.arrow_drop_down, color: Colors.white38, size: 16),
                            ],
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
                            decoration: InputDecoration(
                              hintText: 'Phone Number',
                              hintStyle: GoogleFonts.inter(color: Colors.white38, fontSize: 14),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  _FieldLabel(text: 'CREATE PASSWORD'),
                  const SizedBox(height: 8),
                  _DarkField(
                    controller: _passwordController,
                    hint: 'Create password',
                    icon: Icons.lock_outline_rounded,
                    obscure: _obscurePassword,
                    suffix: GestureDetector(
                      onTap: () => setState(() => _obscurePassword = !_obscurePassword),
                      child: Icon(
                        _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: Colors.white38,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _FieldLabel(text: 'CONFIRM PASSWORD'),
                  const SizedBox(height: 8),
                  _DarkField(
                    controller: _confirmController,
                    hint: 'Confirm password',
                    icon: Icons.lock_outline_rounded,
                    obscure: _obscureConfirm,
                    suffix: GestureDetector(
                      onTap: () => setState(() => _obscureConfirm = !_obscureConfirm),
                      child: Icon(
                        _obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: Colors.white38,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: Checkbox(
                          value: _agreedToTerms,
                          onChanged: (v) => setState(() => _agreedToTerms = v ?? false),
                          activeColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary, width: 2),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'I agree to the ',
                                style: GoogleFonts.inter(color: Colors.white70, fontSize: 13),
                              ),
                              TextSpan(
                                text: 'Terms of Use',
                                style: GoogleFonts.inter(
                                  color: AppColors.primary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: ' and ',
                                style: GoogleFonts.inter(color: Colors.white70, fontSize: 13),
                              ),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: GoogleFonts.inter(
                                  color: AppColors.primary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: _isLoading ? null : _handleRegister,
                      child: _isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Create Account',
                                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_forward_rounded, size: 20),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Expanded(child: Divider(color: Colors.white24)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text('OR SIGN UP WITH',
                            style: GoogleFonts.inter(color: Colors.white38, fontSize: 11, letterSpacing: 1)),
                      ),
                      const Expanded(child: Divider(color: Colors.white24)),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(child: _SocialButton(label: 'Google', icon: Icons.g_mobiledata_rounded)),
                      const SizedBox(width: 12),
                      Expanded(child: _SocialButton(label: 'Apple', icon: Icons.apple_rounded)),
                      const SizedBox(width: 12),
                      Expanded(child: _SocialButton(label: 'Facebook', icon: Icons.facebook_rounded)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Already have an account? ',
                            style: GoogleFonts.inter(color: Colors.white70, fontSize: 13),
                          ),
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Text(
                                'Log In',
                                style: GoogleFonts.inter(
                                  color: AppColors.primary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.logo,
      height: 40,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '93.5 ',
              style: GoogleFonts.bebasNeue(fontSize: 14, color: Colors.white, letterSpacing: 2),
            ),
            TextSpan(
              text: 'AREA ',
              style: GoogleFonts.bebasNeue(fontSize: 22, color: AppColors.primary, letterSpacing: 2),
            ),
            TextSpan(
              text: 'FM',
              style: GoogleFonts.bebasNeue(fontSize: 22, color: Colors.white, letterSpacing: 2),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
        color: Colors.white60,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _DarkField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscure;
  final TextInputType? keyboard;
  final Widget? suffix;
  const _DarkField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.keyboard,
    this.suffix,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboard,
        style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.inter(color: Colors.white38, fontSize: 14),
          prefixIcon: Icon(icon, color: Colors.white38, size: 18),
          suffixIcon: suffix,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final IconData icon;
  const _SocialButton({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
