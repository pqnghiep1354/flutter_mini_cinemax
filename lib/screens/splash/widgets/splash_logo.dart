import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_constants.dart';
import '../../../config/app_text_styles.dart';
import '../../../providers/auth_provider.dart' as app_auth;

class SplashLogo extends StatefulWidget {
  const SplashLogo({super.key});

  @override
  State<SplashLogo> createState() => _SplashLogoState();
}

class _SplashLogoState extends State<SplashLogo> {
  @override
  void initState() {
    super.initState();
    debugPrint('>>> SplashLogo initState');

    Future.delayed(AppConstants.splashDuration, () async {
      if (!mounted) return;
      debugPrint('>>> SplashLogo navigating...');
      
      final authProvider = context.read<app_auth.AuthProvider>();
      
      // Wait for AuthProvider to be initialized if it's not yet
      while (!authProvider.isInitialized && mounted) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      
      if (!mounted) return;

      if (authProvider.isLoggedIn || authProvider.isGuest) {
        context.go('/home');
      } else {
        context.go('/welcome');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('>>> SplashLogo build');
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.background,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: Text(
                  'M',
                  style: AppTextStyles.heading1.copyWith(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'CineMax',
              style: AppTextStyles.heading2.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
