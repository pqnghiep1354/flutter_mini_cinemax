import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/app_text_styles.dart';
import 'widgets/profile_menu_item.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Security', style: AppTextStyles.heading4),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ProfileMenuItem(
              icon: Icons.lock_outline,
              title: 'Change Password',
              onTap: () => context.push('/change-password'),
            ),
          ],
        ),
      ),
    );
  }
}
