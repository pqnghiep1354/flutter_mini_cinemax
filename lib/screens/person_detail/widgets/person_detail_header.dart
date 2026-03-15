import 'package:flutter/material.dart';
import '../../../config/app_colors.dart';
import '../../../models/person.dart';
import '../../../widgets/cached_image.dart';

class PersonDetailHeader extends StatelessWidget {
  final Person person;

  const PersonDetailHeader({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 400,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: person.fullProfilePath.isNotEmpty
            ? CachedImage(
                imageUrl: person.fullProfilePath,
                width: double.infinity,
                height: double.infinity,
              )
            : Container(
                color: AppColors.shimmerBase,
                child: const Icon(Icons.person, size: 100, color: AppColors.mediumGrey),
              ),
      ),
    );
  }
}
