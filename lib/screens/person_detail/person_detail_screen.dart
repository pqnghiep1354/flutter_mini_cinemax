import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/person_detail_provider.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_widget.dart';
import 'widgets/person_detail_header.dart';
import 'widgets/person_detail_info.dart';
import 'widgets/person_detail_bio.dart';
import 'widgets/person_detail_movies.dart';

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
              PersonDetailHeader(person: person),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PersonDetailInfo(person: person),
                    PersonDetailBio(biography: person.biography ?? ''),
                    PersonDetailMovies(movieCredits: provider.movieCredits),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
