import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart' as app_auth;
import '../../providers/my_list_provider.dart';
import '../home/home_screen.dart';
import '../explore/explore_screen.dart';
import '../my_list/my_list_screen.dart';
import '../profile/profile_screen.dart';
import '../../providers/navigation_provider.dart';
import '../../providers/notification_provider.dart';
import '../../services/notification_service.dart';
import 'widgets/main_nav_bottom_bar.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  final List<Widget> _screens = const [
    HomeScreen(),
    ExploreScreen(),
    MyListScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      // Link notification provider
      NotificationService.instance.setProvider(context.read<NotificationProvider>());

      final uid = context.read<app_auth.AuthProvider>().user?.uid;
      if (uid != null) {
        context.read<MyListProvider>().setUser(uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<NavigationProvider>();

    return Scaffold(
      body: IndexedStack(
        index: navProvider.currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: MainNavBottomBar(
        currentIndex: navProvider.currentIndex,
        onTap: (index) => navProvider.setTab(index),
      ),
    );
  }
}
