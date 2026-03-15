import 'package:flutter/material.dart';
import '../../config/app_text_styles.dart';

class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Downloads', style: AppTextStyles.heading4),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.download_for_offline_outlined, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            Text('No downloads yet', style: AppTextStyles.heading4),
            const SizedBox(height: 8),
            Text(
              'Movies you download will appear here.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
