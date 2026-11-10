import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../models/community_post.dart';
import '../../../widgets/community_card.dart';

class FeedTab extends StatefulWidget {
  const FeedTab({super.key});

  @override
  State<FeedTab> createState() => _FeedTabState();
}

class _FeedTabState extends State<FeedTab> {
  final List<CommunityPost> _posts = CommunityPost.samplePosts;

  void _showNewPostDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    final offerController = TextEditingController();
    final seekController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text(
          'Share a Skill Barter',
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
                  labelText: 'Discussion Title',
                  hintText: 'e.g. Seeking Rust mentor for TypeScript advice',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: offerController,
                decoration: const InputDecoration(
                  labelText: 'What skill are you offering?',
                  hintText: 'e.g. Advanced TypeScript',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: seekController,
                decoration: const InputDecoration(
                  labelText: 'What skill are you seeking?',
                  hintText: 'e.g. Rust memory management',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: contentController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Details / Description',
                  hintText: 'Describe what you want to achieve together...',
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
            onPressed: () {
              if (titleController.text.trim().isNotEmpty &&
                  offerController.text.trim().isNotEmpty &&
                  seekController.text.trim().isNotEmpty) {
                setState(() {
                  _posts.insert(
                    0,
                    CommunityPost(
                      id: 'p-${DateTime.now().millisecondsSinceEpoch}',
                      authorName: 'Alex Chen',
                      authorRole: 'Full-Stack Developer',
                      authorAvatar: '',
                      timeAgo: 'Just now',
                      title: titleController.text.trim(),
                      content: contentController.text.trim().isEmpty
                          ? 'Looking forward to learning together!'
                          : contentController.text.trim(),
                      offeringTag: offerController.text.trim(),
                      seekingTag: seekController.text.trim(),
                      likesCount: 1,
                      isLiked: true,
                      commentsCount: 0,
                    ),
                  );
                });
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Your community barter post is live!'),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: const Text('Post Barter'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      children: [
        // Community Banner
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryLight],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Community Barter Feed',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Propose direct skill trades and collaborate with peer learners worldwide.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: _showNewPostDialog,
                icon: const Icon(Icons.add_rounded, size: 16),
                label: const Text('Post', style: TextStyle(fontSize: 13)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Posts
        ..._posts.map((post) => CommunityCard(post: post)),
      ],
    );
  }
}

