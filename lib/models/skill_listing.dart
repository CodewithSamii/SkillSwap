class SkillListing {
  final String id;
  final String title;
  final String category;
  final String instructorName;
  final String instructorAvatar;
  final double rating;
  final int reviewsCount;
  final String teachingSkill;
  final String wantingSkill;
  final String estimatedHours;
  final String skillLevel;
  final String description;
  final List<String> keyTopics;

  const SkillListing({
    required this.id,
    required this.title,
    required this.category,
    required this.instructorName,
    required this.instructorAvatar,
    required this.rating,
    required this.reviewsCount,
    required this.teachingSkill,
    required this.wantingSkill,
    required this.estimatedHours,
    required this.skillLevel,
    required this.description,
    required this.keyTopics,
  });

  factory SkillListing.fromJson(Map<String, dynamic> json) {
    return SkillListing(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? 'General',
      instructorName: json['instructorName'] ?? 'Instructor',
      instructorAvatar: json['instructorAvatar'] ?? 'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
      rating: (json['rating'] as num?)?.toDouble() ?? 4.9,
      reviewsCount: json['reviewsCount'] ?? 12,
      teachingSkill: json['teachingSkill'] ?? '',
      wantingSkill: json['wantingSkill'] ?? '',
      estimatedHours: json['estimatedHours'] ?? '2 hrs/week',
      skillLevel: json['skillLevel'] ?? 'Intermediate',
      description: json['description'] ?? '',
      keyTopics: (json['keyTopics'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'instructorName': instructorName,
      'instructorAvatar': instructorAvatar,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'teachingSkill': teachingSkill,
      'wantingSkill': wantingSkill,
      'estimatedHours': estimatedHours,
      'skillLevel': skillLevel,
      'description': description,
      'keyTopics': keyTopics,
    };
  }

  static List<SkillListing> get sampleListings => [
    const SkillListing(
      id: '1',
      title: 'Full-Stack Flutter & State Management',
      category: 'Tech',
      instructorName: 'Marcus Vance',
      instructorAvatar: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150',
      rating: 4.9,
      reviewsCount: 38,
      teachingSkill: 'Flutter & Riverpod',
      wantingSkill: 'Figma UI/UX Systems',
      estimatedHours: '3 hrs/wk',
      skillLevel: 'Advanced',
      description:
          'Learn clean architecture in Flutter, custom painters, and reactive state management. In exchange, I need hands-on mentoring to build polished Figma component libraries.',
      keyTopics: ['Clean Architecture', 'Custom Render Objects', 'Riverpod 2.0', 'Repository Pattern'],
    ),
    const SkillListing(
      id: '2',
      title: 'Conversational French & Pronunciation',
      category: 'Language',
      instructorName: 'Amélie Laurent',
      instructorAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
      rating: 5.0,
      reviewsCount: 44,
      teachingSkill: 'Native French',
      wantingSkill: 'Python Automation',
      estimatedHours: '2 hrs/wk',
      skillLevel: 'All Levels',
      description:
          'Parisian native providing immersive conversational French, slang, and accent tuning. Seeking someone to guide me through basic Python scripting for web scraping.',
      keyTopics: ['Everyday Slang', 'Phonetics & Nasal Vowels', 'Business Etiquette', 'Cinema Dialogues'],
    ),
    const SkillListing(
      id: '3',
      title: 'Modern Brand Identity & Typography',
      category: 'Design',
      instructorName: 'Elena Rostova',
      instructorAvatar: 'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=150',
      rating: 4.8,
      reviewsCount: 29,
      teachingSkill: 'Brand Identity',
      wantingSkill: 'SQL & Data Analysis',
      estimatedHours: '2.5 hrs/wk',
      skillLevel: 'Intermediate',
      description:
          'Senior visual designer teaching modular design systems, typographic hierarchy, and vector branding. Wanting to exchange for intermediate PostgreSQL & metrics dashboards.',
      keyTopics: ['Grid Systems', 'Typographic Pairings', 'Style Guides', 'Packaging Aesthetics'],
    ),
    const SkillListing(
      id: '4',
      title: 'Cinematic Video Editing & DaVinci Resolve',
      category: 'Media',
      instructorName: 'Kai Tanaka',
      instructorAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      rating: 4.95,
      reviewsCount: 52,
      teachingSkill: 'Color Grading',
      wantingSkill: 'SEO & Copywriting',
      estimatedHours: '3 hrs/wk',
      skillLevel: 'Beginner to Pro',
      description:
          'Hands-on color science, LUT creation, and pacing in DaVinci Resolve. In return, looking for conversion copywriting and technical SEO strategies for YouTube creator channels.',
      keyTopics: ['Node-based Grading', 'Audio Ducking & EQ', 'Pacing & Transitions', 'Export Optimization'],
    ),
    const SkillListing(
      id: '5',
      title: 'Guitar Harmony & Jazz Fingerstyle',
      category: 'Music',
      instructorName: 'Julian Croft',
      instructorAvatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
      rating: 4.85,
      reviewsCount: 19,
      teachingSkill: 'Jazz Guitar',
      wantingSkill: 'Spanish Fluency',
      estimatedHours: '1.5 hrs/wk',
      skillLevel: 'Intermediate',
      description:
          'Berklee-trained guitarist teaching chord substitutions, modal soloing, and Travis picking. Looking to learn conversational Spanish for South American travel.',
      keyTopics: ['Drop 2 Chords', 'Walking Basslines', 'Modal Soloing', 'Ear Training'],
    ),
  ];
}

