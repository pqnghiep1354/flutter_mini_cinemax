import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../config/app_colors.dart';
import '../../config/app_text_styles.dart';
import '../../providers/auth_provider.dart' as app_auth;
import '../../providers/profile_provider.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/loading_indicator.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_menu_item.dart';
import 'widgets/profile_logout_dialog.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final user = context.read<app_auth.AuthProvider>().user;
      if (user != null) {
        context.read<ProfileProvider>().loadProfile(user.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: AppTextStyles.heading3),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer3<app_auth.AuthProvider, ProfileProvider, ThemeProvider>(
        builder: (context, authProvider, profileProvider, themeProvider, _) {
          if (profileProvider.isLoading) return const LoadingIndicator();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ProfileHeader(
                  name: profileProvider.profile?.displayName ?? authProvider.user?.displayName ?? 'User',
                  email: profileProvider.profile?.email ?? authProvider.user?.email ?? '',
                  photoUrl: profileProvider.profile?.photoUrl ?? authProvider.user?.photoURL,
                  phoneNumber: profileProvider.profile?.phoneNumber,
                  gender: profileProvider.profile?.gender,
                ),
                const SizedBox(height: 32),
                ProfileMenuItem(
                  icon: Icons.person_outline,
                  title: 'Edit Profile',
                  onTap: () => context.push('/edit-profile'),
                ),
                ProfileMenuItem(
                  icon: Icons.notifications_outlined,
                  title: 'Notification',
                  onTap: () => context.push('/notifications'),
                ),
                ProfileMenuItem(
                  icon: Icons.download_outlined,
                  title: 'Download',
                  onTap: () => context.push('/downloads'),
                ),
                ProfileMenuItem(
                  icon: Icons.security_outlined,
                  title: 'Security',
                  onTap: () => context.push('/security'),
                ),
                ProfileMenuItem(
                  icon: Icons.language,
                  title: 'Language',
                  trailing: 'English (US)',
                  onTap: () => context.push('/language'),
                ),
                ProfileMenuItem(
                  icon: Icons.dark_mode_outlined,
                  title: 'Dark Mode',
                  trailingWidget: Switch(
                    value: themeProvider.isDarkMode,
                    onChanged: (value) => themeProvider.toggleTheme(),
                    activeColor: AppColors.primary,
                  ),
                ),
                ProfileMenuItem(
                  icon: Icons.help_outline,
                  title: 'Help Center',
                  onTap: () {},
                ),
                ProfileMenuItem(
                  icon: Icons.info_outline,
                  title: 'About CineMax',
                  onTap: () {},
                ),
                const SizedBox(height: 16),
                if (authProvider.isGuest) ...[
                  const SizedBox(height: 24),
                  Card(
                    color: Colors.red.withValues(alpha: 0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Icon(Icons.info_outline, color: Colors.red, size: 48),
                          const SizedBox(height: 16),
                          const Text(
                            'Please login to track your activity, manage your list and write reviews.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => context.push('/lets-you-in'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 48),
                            ),
                            child: const Text('Sign In Now'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  ProfileMenuItem(
                    icon: Icons.logout,
                    title: 'Logout',
                    isDestructive: true,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => const ProfileLogoutDialog(),
                      );
                    },
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
