import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cinemax/screens/welcome/welcome_screen.dart';
import 'package:cinemax/screens/splash/splash_screen.dart';
import 'package:cinemax/screens/auth/lets_you_in_screen.dart';
import 'package:cinemax/screens/auth/login_screen.dart';
import 'package:cinemax/screens/auth/register_screen.dart';
import 'package:cinemax/screens/auth/forgot_password_screen.dart';
import 'package:cinemax/screens/main_nav/main_nav_screen.dart';
import 'package:cinemax/screens/movie_detail/movie_detail_screen.dart';
import 'package:cinemax/screens/series_detail/series_detail_screen.dart';
import 'package:cinemax/screens/search/search_screen.dart';
import 'package:cinemax/screens/top_movies/top_movies_screen.dart';
import 'package:cinemax/screens/profile/edit_profile_screen.dart';
import 'package:cinemax/screens/trailer/trailer_screen.dart';
import 'package:cinemax/screens/home/section_movies_screen.dart';
import 'package:cinemax/screens/person_detail/person_detail_screen.dart';
import 'package:cinemax/screens/notifications/notifications_screen.dart';
import 'package:cinemax/screens/downloads/downloads_screen.dart';
import 'package:cinemax/screens/profile/security_screen.dart';
import 'package:cinemax/screens/profile/change_password_screen.dart';
import 'package:cinemax/screens/profile/language_screen.dart';
import 'package:cinemax/providers/auth_provider.dart';

class AppRouter {
  static GoRouter? _router;

  static GoRouter router(BuildContext context) {
    _router ??= _createRouter(context);
    return _router!;
  }

  static GoRouter _createRouter(BuildContext context) {
    final authProvider = context.read<AuthProvider>();

    return GoRouter(
      initialLocation: '/',
      refreshListenable: authProvider,
      redirect: (context, state) {
        final publicRoute = state.matchedLocation == '/login' ||
            state.matchedLocation == '/register' ||
            state.matchedLocation == '/welcome' ||
            state.matchedLocation == '/lets-you-in' ||
            state.matchedLocation == '/forgot-password' ||
            state.matchedLocation == '/';

        if (!authProvider.isInitialized) return null;

        if (!authProvider.isLoggedIn && !authProvider.isGuest) {
          return publicRoute ? null : '/welcome';
        }

        if (authProvider.isLoggedIn && (publicRoute && state.matchedLocation != '/')) {
          return '/home';
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/welcome',
          builder: (context, state) => const WelcomeScreen(),
        ),
        GoRoute(
          path: '/lets-you-in',
          builder: (context, state) => const LetsYouInScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/forgot-password',
          builder: (context, state) => const ForgotPasswordScreen(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const MainNavScreen(),
        ),
        GoRoute(
          path: '/movie/:id',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return MovieDetailScreen(movieId: id);
          },
        ),
        GoRoute(
          path: '/series/:id',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return SeriesDetailScreen(seriesId: id);
          },
        ),
        GoRoute(
          path: '/search',
          builder: (context, state) => const SearchScreen(),
        ),
        GoRoute(
          path: '/top-movies',
          builder: (context, state) => const TopMoviesScreen(),
        ),
        GoRoute(
          path: '/edit-profile',
          builder: (context, state) => const EditProfileScreen(),
        ),
        GoRoute(
          path: '/trailer',
          builder: (context, state) {
            final videoKey = state.uri.queryParameters['key'] ?? '';
            final title = state.uri.queryParameters['title'] ?? '';
            return TrailerScreen(videoKey: videoKey, title: title);
          },
        ),
        GoRoute(
          path: '/section',
          builder: (context, state) {
            final title = state.uri.queryParameters['title'] ?? 'Movies';
            final typeStr = state.uri.queryParameters['type'] ?? 'popular';
            final type = MovieSectionType.values.firstWhere(
              (e) => e.toString().split('.').last == typeStr,
              orElse: () => MovieSectionType.popular,
            );
            return SectionMoviesScreen(title: title, sectionType: type);
          },
        ),
        GoRoute(
          path: '/person/:id',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return PersonDetailScreen(personId: id);
          },
        ),
        GoRoute(
          path: '/notifications',
          builder: (context, state) => const NotificationsScreen(),
        ),
        GoRoute(
          path: '/downloads',
          builder: (context, state) => const DownloadsScreen(),
        ),
        GoRoute(
          path: '/security',
          builder: (context, state) => const SecurityScreen(),
        ),
        GoRoute(
          path: '/change-password',
          builder: (context, state) => const ChangePasswordScreen(),
        ),
        GoRoute(
          path: '/language',
          builder: (context, state) => const LanguageScreen(),
        ),
      ],
    );
  }
}
