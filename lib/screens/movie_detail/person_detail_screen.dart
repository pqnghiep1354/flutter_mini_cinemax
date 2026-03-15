import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../config/app_colors.dart';
import '../../config/app_text_styles.dart';
import '../../providers/person_detail_provider.dart';
import '../../widgets/cached_image.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_widget.dart';

class PersonDetailScreen extends StatefulWidget {
  final int personId;

  const PersonDetailScreen({super.key, required this.personId});

  @override
  State<PersonDetailScreen> createState() => _PersonDetailScreenState();
}

class _PersonDetailScreenState extends State<PersonDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PersonDetailProvider>().loadPersonDetail(widget.personId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PersonDetailProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const LoadingIndicator();
          }

          if (provider.errorMessage != null) {
            return AppErrorWidget(
              message: provider.errorMessage!,
              onRetry: () => provider.loadPersonDetail(widget.personId),
            );
          }

          final person = provider.person;
          if (person == null) return const SizedBox.shrink();

          return CustomScrollView(
            slivers: [
              // Header with profile image
              SliverAppBar(
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
              ),

              // Info Section
              SliverToBoxAdapter(
                child: Padding(
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
                        const SizedBox(height: 24),
                      ],

                      // Biography
                      if (person.biography != null && person.biography!.isNotEmpty) ...[
                        Text('Biography', style: AppTextStyles.heading4),
                        const SizedBox(height: 8),
                        Text(
                          person.biography!,
                          style: AppTextStyles.bodyMedium.copyWith(height: 1.5),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Known For (Movie Credits)
                      if (provider.movieCredits.isNotEmpty) ...[
                        Text('Known For', style: AppTextStyles.heading4),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 220,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: provider.movieCredits.length > 10 ? 10 : provider.movieCredits.length,
                            itemBuilder: (context, index) {
                              final movie = provider.movieCredits[index];
                              return GestureDetector(
                                onTap: () => context.push('/movie/${movie.id}'),
                                child: Container(
                                  width: 130,
                                  margin: const EdgeInsets.only(right: 12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: CachedImage(
                                          imageUrl: movie.fullPosterPath,
                                          borderRadius: 12,
                                          width: double.infinity,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        movie.title,
                                        style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
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
