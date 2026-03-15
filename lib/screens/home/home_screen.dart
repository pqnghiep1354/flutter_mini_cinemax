import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/home_provider.dart';
import '../../providers/navigation_provider.dart';
import '../../providers/explore_provider.dart';
import 'package:cinemax/providers/auth_provider.dart' as app_auth;
import '../../providers/notification_provider.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_widget.dart';
import 'widgets/home_featured_carousel.dart';
import 'widgets/home_section_header.dart';
import 'widgets/home_movie_card.dart';
import 'widgets/home_category_chips.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<HomeProvider>().loadHomeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFE21221),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'M',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'CineMax',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
            ),
          ],
        ),
        actions: [
          Consumer<app_auth.AuthProvider>(
            builder: (context, auth, _) {
              if (auth.isGuest) {
                return IconButton(
                  icon: const Icon(Icons.login),
                  onPressed: () => context.push('/lets-you-in'),
                  tooltip: 'Login',
                );
              }
              return const SizedBox.shrink();
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/search'),
          ),
          Consumer<NotificationProvider>(
            builder: (context, notificationProvider, _) {
              final unreadCount = notificationProvider.unreadCount;
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () => context.push('/notifications'),
                  ),
                  if (unreadCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          unreadCount > 9 ? '9+' : '$unreadCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: Consumer<HomeProvider>(
        builder: (context, homeProvider, child) {
          if (homeProvider.isLoading) {
            return const LoadingIndicator();
          }

          if (homeProvider.errorMessage != null) {
            return AppErrorWidget(
              message: homeProvider.errorMessage!,
              onRetry: homeProvider.refresh,
            );
          }

          return RefreshIndicator(
            onRefresh: homeProvider.refresh,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Featured carousel
                  if (homeProvider.trending.isNotEmpty)
                    HomeFeaturedCarousel(movies: homeProvider.trending),

                  const SizedBox(height: 24),

                  // Category chips
                  if (homeProvider.genres.isNotEmpty)
                    HomeCategoryChips(
                      genres: homeProvider.genres,
                      selectedIndex: homeProvider.selectedGenreIndex,
                      onSelected: (index) {
                        homeProvider.selectGenre(index);
                        if (index > 0) {
                          final genre = homeProvider.genres[index - 1];
                          context.read<ExploreProvider>().selectGenre(genre.id);
                          context.read<NavigationProvider>().setTab(1); // Explore tab
                        }
                      },
                    ),

                  const SizedBox(height: 24),

                  // Now Playing
                  if (homeProvider.nowPlaying.isNotEmpty) ...[
                    HomeSectionHeader(
                      title: 'Now Playing',
                      onSeeAll: () => context.push(
                        Uri(path: '/section', queryParameters: {
                          'title': 'Now Playing',
                          'type': 'nowPlaying'
                        }).toString(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildHorizontalList(homeProvider.nowPlaying),
                  ],

                  const SizedBox(height: 24),

                  // Popular
                  if (homeProvider.popular.isNotEmpty) ...[
                    HomeSectionHeader(
                      title: 'Popular',
                      onSeeAll: () => context.push(
                        Uri(path: '/section', queryParameters: {
                          'title': 'Popular',
                          'type': 'popular'
                        }).toString(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildHorizontalList(homeProvider.popular),
                  ],

                  const SizedBox(height: 24),

                  // Top Rated
                  if (homeProvider.topRated.isNotEmpty) ...[
                    HomeSectionHeader(
                      title: 'Top Rated',
                      onSeeAll: () => context.push(
                        Uri(path: '/section', queryParameters: {
                          'title': 'Top Rated',
                          'type': 'topRated'
                        }).toString(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildHorizontalList(homeProvider.topRated),
                  ],

                  const SizedBox(height: 24),

                  // Upcoming
                  if (homeProvider.upcoming.isNotEmpty) ...[
                    HomeSectionHeader(
                      title: 'Upcoming',
                      onSeeAll: () => context.push(
                        Uri(path: '/section', queryParameters: {
                          'title': 'Upcoming',
                          'type': 'upcoming'
                        }).toString(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildHorizontalList(homeProvider.upcoming),
                  ],

                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHorizontalList(List movies) {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: HomeMovieCard(movie: movies[index]),
          );
        },
      ),
    );
  }
}
