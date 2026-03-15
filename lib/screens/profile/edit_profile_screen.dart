import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/app_text_styles.dart';
import 'widgets/edit_profile_form.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text('Edit Profile', style: AppTextStyles.heading4),
      ),
      body: const EditProfileForm(),
    );
  }
}
