import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../models/skill_listing.dart';
import '../../models/swap_activity.dart';
import '../../models/user_profile.dart';
import '../../services/api_service.dart';
import 'tabs/activity_tab.dart';
import 'tabs/explore_tab.dart';
import 'tabs/feed_tab.dart';
import 'tabs/profile_tab.dart';
import 'widgets/home_drawer.dart';

class HomeScreen extends StatefulWidget {
  final List<SkillListing>? initialListings;
  final List<SwapActivity>? initialActivities;
  final UserProfile? initialProfile;

  const HomeScreen({
    super.key,
    this.initialListings,
    this.initialActivities,
    this.initialProfile,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List<SkillListing> _listings = [];
  List<SwapActivity> _activities = [];
  UserProfile _profile = UserProfile.defaultProfile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);

    try {
      final itemsFuture = ApiService.getItems();
      final activitiesFuture = ApiService.getActivities();
      final profileFuture = ApiService.getProfile();

      final results = await Future.wait([itemsFuture, activitiesFuture, profileFuture]);

      if (mounted) {
        setState(() {
          _listings = results[0] as List<SkillListing>;
          _activities = results[1] as List<SwapActivity>;
          _profile = results[2] as UserProfile;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _listings = SkillListing.sampleListings;
          _activities = SwapActivity.sampleActivities;
          _profile = UserProfile.defaultProfile;
          _isLoading = false;
        });
      }
    }
  }

  void _handleLogout() async {
    await ApiService.logout();
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }

  void _showNewListingDialog() {
    final titleController = TextEditingController();
    final teachController = TextEditingController();
    final wantController = TextEditingController();
    final descController = TextEditingController();
    String category = 'Tech';
    bool isPosting = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: const Text(
            'Create Skill Exchange Listing',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Listing Title',
                    hintText: 'e.g. Kotlin Android Architecture',
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: category,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: ['Tech', 'Language', 'Design', 'Media', 'Music']
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setDialogState(() => category = val);
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: teachController,
                  decoration: const InputDecoration(
                    labelText: 'Skill You Will Teach',
                    hintText: 'e.g. Jetpack Compose & Coroutines',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: wantController,
                  decoration: const InputDecoration(
                    labelText: 'Skill You Want in Return',
                    hintText: 'e.g. Conversational German',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Description & Syllabus',
                    hintText: 'Detail your background and what you expect to cover...',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
            ),
            ElevatedButton(
              onPressed: isPosting
                  ? null
                  : () async {
                      if (titleController.text.trim().isNotEmpty &&
                          teachController.text.trim().isNotEmpty &&
                          wantController.text.trim().isNotEmpty) {
                        setDialogState(() => isPosting = true);

                        final newListing = SkillListing(
                          id: 'item-${DateTime.now().millisecondsSinceEpoch}',
                          title: titleController.text.trim(),
                          category: category,
                          instructorName: _profile.name,
                          instructorAvatar: '',
                          rating: 5.0,
                          reviewsCount: 1,
                          teachingSkill: teachController.text.trim(),
                          wantingSkill: wantController.text.trim(),
                          estimatedHours: '2 hrs/wk',
                          skillLevel: 'All Levels',
                          description: descController.text.trim().isEmpty
                              ? 'Collaborative peer-to-peer exchange.'
                              : descController.text.trim(),
                          keyTopics: ['Core Fundamentals', 'Practical Exercise', 'Review & Feedback'],
                        );

                        final navigator = Navigator.of(ctx);
                        final messenger = ScaffoldMessenger.of(context);
                        final created = await ApiService.createItem(newListing);

                        if (mounted) {
                          setState(() {
                            _listings.insert(0, created ?? newListing);
                          });
                        }

                        navigator.pop();
                        messenger.showSnackBar(
                          const SnackBar(
                            content: Text('Your skill listing has been published to the REST server!'),
                            backgroundColor: AppColors.success,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
              child: isPosting
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Publish Listing'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleToggleStatus(String id) async {
    final updated = await ApiService.toggleActivity(id);
    if (updated != null && mounted) {
      setState(() {
        final index = _activities.indexWhere((a) => a.id == id);
        if (index != -1) {
          _activities[index] = updated;
        }
      });
    }
  }

  String get _appBarTitle {
    switch (_currentIndex) {
      case 0:
        return 'Explore Exchanges';
      case 1:
        return 'Community Feed';
      case 2:
        return 'Swap Schedule';
      case 3:
        return 'My Profile';
      default:
        return 'SkillSwap';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(_appBarTitle),
        elevation: 0,
        actions: [
          if (_currentIndex == 0)
            IconButton(
              icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primary),
              tooltip: 'Post New Listing',
              onPressed: _showNewListingDialog,
            ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppColors.textPrimary),
            tooltip: 'Sync with API Server',
            onPressed: () {
              _loadInitialData();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Synced state with REST API backend (port 5000).'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: HomeDrawer(
        currentIndex: _currentIndex,
        onSelectTab: (idx) {
          setState(() {
            _currentIndex = idx;
          });
        },
        onLogout: _handleLogout,
        user: _profile,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            )
          : IndexedStack(
              index: _currentIndex,
              children: [
                ExploreTab(externalListings: _listings),
                const FeedTab(),
                ActivityTab(
                  externalActivities: _activities,
                  onToggleStatus: _handleToggleStatus,
                ),
                ProfileTab(
                  user: _profile,
                  onLogout: _handleLogout,
                ),
              ],
            ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(top: BorderSide(color: AppColors.border, width: 1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (idx) {
            setState(() {
              _currentIndex = idx;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textMuted,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              activeIcon: Icon(Icons.explore_rounded),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.forum_outlined),
              activeIcon: Icon(Icons.forum_rounded),
              label: 'Community',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event_note_outlined),
              activeIcon: Icon(Icons.event_note_rounded),
              label: 'Activity',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton.extended(
              onPressed: _showNewListingDialog,
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add_rounded),
              label: const Text(
                'Post Swap',
                style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.2),
              ),
            )
          : null,
    );
  }
}
