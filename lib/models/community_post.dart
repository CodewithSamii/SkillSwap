class CommunityPost {
  final String id;
  final String authorName;
  final String authorRole;
  final String authorAvatar;
  final String timeAgo;
  final String title;
  final String content;
  final String offeringTag;
  final String seekingTag;
  int likesCount;
  bool isLiked;
  final int commentsCount;

  CommunityPost({
    required this.id,
    required this.authorName,
    required this.authorRole,
    required this.authorAvatar,
    required this.timeAgo,
    required this.title,
    required this.content,
    required this.offeringTag,
    required this.seekingTag,
    required this.likesCount,
    this.isLiked = false,
    required this.commentsCount,
  });

  factory CommunityPost.fromJson(Map<String, dynamic> json) {
    return CommunityPost(
      id: json['id']?.toString() ?? '',
      authorName: json['authorName'] ?? 'Community Member',
      authorRole: json['authorRole'] ?? 'Skill Trader',
      authorAvatar: json['authorAvatar'] ?? '',
      timeAgo: json['timeAgo'] ?? 'Recently',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      offeringTag: json['offeringTag'] ?? '',
      seekingTag: json['seekingTag'] ?? '',
      likesCount: json['likesCount'] ?? 0,
      isLiked: json['isLiked'] ?? false,
      commentsCount: json['commentsCount'] ?? 0,
    );
  }

  static List<CommunityPost> get samplePosts => [
    CommunityPost(
      id: 'p1',
      authorName: 'Sofia Martinez',
      authorRole: 'Product Designer @ StudioMono',
      authorAvatar: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150',
      timeAgo: '15m ago',
      title: 'UI Design Critique for Next.js Optimization?',
      content:
          'Hey makers! I can audit your SaaS mobile screens, run UX heuristic evaluations, and redesign key onboarding flows. In return, I need someone to help debug my Next.js Supabase auth flow!',
      offeringTag: 'Design Audit & UI',
      seekingTag: 'Next.js & Supabase',
      likesCount: 24,
      isLiked: false,
      commentsCount: 9,
    ),
    CommunityPost(
      id: 'p2',
      authorName: 'Liam O’Connor',
      authorRole: 'Full-Stack Engineer',
      authorAvatar: 'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?w=150',
      timeAgo: '1h ago',
      title: 'Docker & Kubernetes Deep Dive for Japanese Basics',
      content:
          'Setting up local containerization, CI/CD pipelines with GitHub Actions, and cluster configs. Looking to exchange for beginner Hiragana/Katakana & speaking practice.',
      offeringTag: 'DevOps & Docker',
      seekingTag: 'Japanese N5',
      likesCount: 42,
      isLiked: true,
      commentsCount: 14,
    ),
    CommunityPost(
      id: 'p3',
      authorName: 'Clara Oswald',
      authorRole: 'Creative Director & Illustrator',
      authorAvatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=150',
      timeAgo: '3h ago',
      title: 'Digital Illustration in Procreate for Video Editing',
      content:
          'I teach digital painting, character sketching, and brushes customization. Want to barter with a Premiere Pro or After Effects wizard to animate short promo reels.',
      offeringTag: 'Procreate Illustration',
      seekingTag: 'After Effects Motion',
      likesCount: 31,
      isLiked: false,
      commentsCount: 7,
    ),
  ];
}

