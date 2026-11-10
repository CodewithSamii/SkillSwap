class SwapActivity {
  final String id;
  final String partnerName;
  final String partnerAvatar;
  final String exchangeTitle;
  final String sessionTime;
  final String platform;
  bool isCompleted;
  final String status; // 'Active', 'Scheduled', 'Review'
  final List<String> checklist;
  List<bool> checklistDone;

  SwapActivity({
    required this.id,
    required this.partnerName,
    required this.partnerAvatar,
    required this.exchangeTitle,
    required this.sessionTime,
    required this.platform,
    this.isCompleted = false,
    required this.status,
    required this.checklist,
    required this.checklistDone,
  });

  factory SwapActivity.fromJson(Map<String, dynamic> json) {
    final cl = (json['checklist'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
    final cld = (json['checklistDone'] as List<dynamic>?)?.map((e) => e as bool).toList() ??
        List.filled(cl.length, false);

    return SwapActivity(
      id: json['id']?.toString() ?? '',
      partnerName: json['partnerName'] ?? 'Partner',
      partnerAvatar: json['partnerAvatar'] ?? '',
      exchangeTitle: json['exchangeTitle'] ?? '',
      sessionTime: json['sessionTime'] ?? 'TBD',
      platform: json['platform'] ?? 'Google Meet',
      isCompleted: json['isCompleted'] ?? false,
      status: json['status'] ?? 'Active',
      checklist: cl,
      checklistDone: cld,
    );
  }

  static List<SwapActivity> get sampleActivities => [
    SwapActivity(
      id: 'act-1',
      partnerName: 'Marcus Vance',
      partnerAvatar: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150',
      exchangeTitle: 'Flutter Architecture ⇄ Figma Design System',
      sessionTime: 'Today at 6:30 PM (45 mins)',
      platform: 'Google Meet',
      isCompleted: false,
      status: 'Active',
      checklist: [
        'Review StateNotifier implementation',
        'Figma auto-layout & tokens audit',
        'Set up repository interfaces',
      ],
      checklistDone: [true, false, false],
    ),
    SwapActivity(
      id: 'act-2',
      partnerName: 'Amélie Laurent',
      partnerAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
      exchangeTitle: 'French Pronunciation ⇄ Python Scraping',
      sessionTime: 'Tomorrow at 4:00 PM (60 mins)',
      platform: 'Discord Voice',
      isCompleted: false,
      status: 'Scheduled',
      checklist: [
        'Practice nasal vowels & linking syllables',
        'Intro to BeautifulSoup and requests',
        'Parse restaurant menu dataset',
      ],
      checklistDone: [false, false, false],
    ),
    SwapActivity(
      id: 'act-3',
      partnerName: 'Julian Croft',
      partnerAvatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
      exchangeTitle: 'Jazz Fingerstyle ⇄ Spanish Vocabulary',
      sessionTime: 'Completed Oct 31 (60 mins)',
      platform: 'Zoom',
      isCompleted: true,
      status: 'Completed',
      checklist: [
        'Dominant 7th chord voicings',
        'Travel conversation phrases & verbs',
        'Mutual peer review submitted',
      ],
      checklistDone: [true, true, true],
    ),
  ];
}

