import 'package:flutter/material.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_text_styles.dart';
import '../../../models/person.dart';

class PersonDetailInfo extends StatelessWidget {
  final Person person;

  const PersonDetailInfo({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(person.name, style: AppTextStyles.heading2),
          if (person.knownForDepartment != null) ...[
            const SizedBox(height: 4),
            Text(
              person.knownForDepartment!,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary),
            ),
          ],
          const SizedBox(height: 16),
          
          // Personal Details
          if (person.birthday != null || person.placeOfBirth != null) ...[
            _buildInfoRow('Birthday', person.birthday ?? 'Unknown'),
            const SizedBox(height: 8),
            _buildInfoRow('Place of Birth', person.placeOfBirth ?? 'Unknown'),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text('$label: ', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w700)),
        Expanded(
          child: Text(value, style: AppTextStyles.bodySmall),
        ),
      ],
    );
  }
}
