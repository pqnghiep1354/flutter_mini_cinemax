import 'package:flutter/material.dart';
import '../../config/app_text_styles.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Language', style: AppTextStyles.heading4),
      ),
      body: ListView(
        children: [
          _buildLanguageItem('English (US)', true),
          _buildLanguageItem('English (UK)', false),
          _buildLanguageItem('Vietnamese', false),
          _buildLanguageItem('Spanish', false),
          _buildLanguageItem('French', false),
          _buildLanguageItem('German', false),
        ],
      ),
    );
  }

  Widget _buildLanguageItem(String language, bool isSelected) {
    return ListTile(
      title: Text(language),
      trailing: isSelected ? const Icon(Icons.check, color: Colors.red) : null,
      onTap: () {},
    );
  }
}
