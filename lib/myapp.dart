import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cinemax/config/app_theme.dart';
import 'package:cinemax/config/app_router.dart';
import 'package:cinemax/providers/auth_provider.dart' as app_auth;
import 'package:cinemax/providers/home_provider.dart';
import 'package:cinemax/providers/movie_detail_provider.dart';
import 'package:cinemax/providers/series_provider.dart';
import 'package:cinemax/providers/search_provider.dart';
import 'package:cinemax/providers/explore_provider.dart';
import 'package:cinemax/providers/my_list_provider.dart';
import 'package:cinemax/providers/profile_provider.dart';
import 'package:cinemax/providers/navigation_provider.dart';
import 'package:cinemax/providers/person_detail_provider.dart';
import 'package:cinemax/providers/theme_provider.dart';
import 'package:cinemax/providers/notification_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => app_auth.AuthProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => MovieDetailProvider()),
        ChangeNotifierProvider(create: (_) => SeriesProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => ExploreProvider()),
        ChangeNotifierProvider(create: (_) => MyListProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => PersonDetailProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp.router(
            title: 'CineMax',
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            routerConfig: AppRouter.router(context),
          );
        },
      ),
    );
  }
}
