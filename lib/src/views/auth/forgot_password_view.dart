import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../const/app_colors.dart';
import '../../../const/app_assets.dart';
import '../../routes/route_names.dart';
import '../../../common/helpers/snackbar_helper.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleReset() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      SnackbarHelper.showError(context, 'Please enter your email address');
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _isLoading = false);
      SnackbarHelper.showSuccess(context, 'Password reset link sent to $email');
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      } else {
        context.go(RouteNames.login);
      }
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
          // Studio Microphone Graphic Artwork
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
          // Gradient overlays
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
          // Foreground Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  // Back button
                  GestureDetector(
                    onTap: () {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      } else {
                        context.go(RouteNames.login);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Station Logo Image
                  _LogoBadge(),
                  const SizedBox(height: 16),
                  // Headline
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'FORGOT\n',
                          style: GoogleFonts.bebasNeue(
                            fontSize: 48,
                            color: Colors.white,
                            letterSpacing: 2,
                            height: 0.95,
                          ),
                        ),
                        TextSpan(
                          text: 'PASSWORD?',
                          style: GoogleFonts.bebasNeue(
                            fontSize: 48,
                            color: AppColors.primary,
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
                          text: 'Enter your registered email address to receive password ',
                          style: GoogleFonts.inter(
                            color: Colors.white70,
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                        TextSpan(
                          text: 'reset instructions.',
                          style: GoogleFonts.inter(
                            color: AppColors.primary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Email Address Field
                  _FieldLabel(text: 'EMAIL ADDRESS'),
                  const SizedBox(height: 8),
                  _DarkTextField(
                    controller: _emailController,
                    hintText: 'Enter your registered email',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 28),

                  // Send Instructions Button
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: _isLoading ? null : _handleReset,
                      child: _isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Send Reset Instructions',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_forward_rounded, size: 20),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Back to login footer
                  Center(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Remember your password? ',
                            style: GoogleFonts.inter(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: () {
                                if (Navigator.of(context).canPop()) {
                                  Navigator.of(context).pop();
                                } else {
                                  context.go(RouteNames.login);
                                }
                              },
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

class _DarkTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final TextInputType? keyboardType;

  const _DarkTextField({
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1C2639),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFF1C2639),
          hintText: hintText,
          hintStyle: GoogleFonts.inter(color: Colors.white38, fontSize: 14),
          prefixIcon: Icon(prefixIcon, color: Colors.white60, size: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}
