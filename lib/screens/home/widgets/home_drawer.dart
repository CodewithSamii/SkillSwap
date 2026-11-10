import 'package:flutter/material.dart';
import '../../../core/supabase_config.dart';
import '../../../core/theme.dart';
import '../../../models/user_profile.dart';

class HomeDrawer extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onSelectTab;
  final VoidCallback onLogout;
  final UserProfile? user;

  const HomeDrawer({
    super.key,
    required this.currentIndex,
    required this.onSelectTab,
    required this.onLogout,
    this.user,
  });

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Row(
          children: const [
            Icon(Icons.logout_rounded, color: AppColors.error, size: 24),
            SizedBox(width: 10),
            Text('Sign Out', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
          ],
        ),
        content: const Text(
          'Are you sure you want to log out of your SkillSwap account?',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop(); // Close drawer
              onLogout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = user ?? UserProfile.defaultProfile;

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Drawer Header
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 20,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primaryLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white24,
                  child: Text(
                    profile.name.substring(0, 1),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        profile.handle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.accent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${profile.karmaCredits} Karma Credits',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Drawer Links
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 12),
              children: [
                _buildDrawerItem(
                  icon: Icons.explore_outlined,
                  activeIcon: Icons.explore_rounded,
                  title: 'Explore Skills',
                  index: 0,
                  context: context,
                ),
                _buildDrawerItem(
                  icon: Icons.forum_outlined,
                  activeIcon: Icons.forum_rounded,
                  title: 'Community Feed',
                  index: 1,
                  context: context,
                ),
                _buildDrawerItem(
                  icon: Icons.event_note_outlined,
                  activeIcon: Icons.event_note_rounded,
                  title: 'Swap Schedule',
                  index: 2,
                  context: context,
                ),
                _buildDrawerItem(
                  icon: Icons.person_outline_rounded,
                  activeIcon: Icons.person_rounded,
                  title: 'My Profile',
                  index: 3,
                  context: context,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Divider(color: AppColors.border),
                ),
                ListTile(
                  leading: const Icon(Icons.cloud_sync_rounded, color: AppColors.accent, size: 22),
                  title: const Text('Backend Provider', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: Text(
                    SupabaseConfig.backendDisplayName,
                    style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                  trailing: const Icon(Icons.swap_vert_rounded, size: 18, color: AppColors.accent),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (dlgCtx) => StatefulBuilder(
                        builder: (dlgCtx, setDlgState) => AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          title: const Text('Select Backend Engine', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildBackendTile(
                                title: 'Hybrid (Auto-Failover)',
                                subtitle: 'Prefers Supabase if configured, falls back to Node.js REST',
                                isSelected: SupabaseConfig.activeBackend == BackendType.hybrid,
                                onTap: () {
                                  setDlgState(() => SupabaseConfig.activeBackend = BackendType.hybrid);
                                  Navigator.of(dlgCtx).pop();
                                },
                              ),
                              _buildBackendTile(
                                title: 'Node.js REST API',
                                subtitle: 'Direct http://localhost:5000 via adb reverse',
                                isSelected: SupabaseConfig.activeBackend == BackendType.nodeRest,
                                onTap: () {
                                  setDlgState(() => SupabaseConfig.activeBackend = BackendType.nodeRest);
                                  Navigator.of(dlgCtx).pop();
                                },
                              ),
                              _buildBackendTile(
                                title: 'Supabase Cloud',
                                subtitle: 'Direct PostgreSQL & Auth via Supabase SDK',
                                isSelected: SupabaseConfig.activeBackend == BackendType.supabase,
                                onTap: () {
                                  setDlgState(() => SupabaseConfig.activeBackend = BackendType.supabase);
                                  Navigator.of(dlgCtx).pop();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.shield_outlined, color: AppColors.textSecondary, size: 22),
                  title: const Text('Trust & Safety', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  trailing: const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.textMuted),
                  onTap: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Trust & Safety guidelines are up to date.')),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings_outlined, color: AppColors.textSecondary, size: 22),
                  title: const Text('App Settings', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  trailing: const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.textMuted),
                  onTap: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Settings preferences saved.')),
                    );
                  },
                ),
              ],
            ),
          ),

          // Logout Item at bottom of drawer
          const Divider(color: AppColors.border, height: 1),
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: AppColors.error),
            title: const Text(
              'Log Out',
              style: TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            subtitle: const Text('Sign out of your account', style: TextStyle(fontSize: 11)),
            onTap: () => _confirmLogout(context),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 10),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required IconData activeIcon,
    required String title,
    required int index,
    required BuildContext context,
  }) {
    final isSelected = currentIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        selected: isSelected,
        selectedTileColor: AppColors.primary.withValues(alpha: 0.08),
        leading: Icon(
          isSelected ? activeIcon : icon,
          color: isSelected ? AppColors.primary : AppColors.textSecondary,
          size: 22,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            color: isSelected ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
        onTap: () {
          Navigator.of(context).pop(); // Close drawer
          onSelectTab(index);
        },
      ),
    );
  }

  static Widget _buildBackendTile({
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded,
        color: isSelected ? AppColors.accent : AppColors.textMuted,
        size: 20,
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      trailing: isSelected
          ? const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 18)
          : null,
      onTap: onTap,
    );
  }
}

