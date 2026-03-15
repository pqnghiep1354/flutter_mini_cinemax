import 'package:flutter/material.dart';
import '../../../config/app_text_styles.dart';

class PersonDetailBio extends StatelessWidget {
  final String biography;

  const PersonDetailBio({super.key, required this.biography});

  @override
  Widget build(BuildContext context) {
    if (biography.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Biography', style: AppTextStyles.heading4),
          const SizedBox(height: 8),
          Text(
            biography,
            style: AppTextStyles.bodyMedium.copyWith(height: 1.5),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
