class UserProfile {
  final String name;
  final String handle;
  final String title;
  final String bio;
  final String location;
  final double rating;
  final int totalReviews;
  final int karmaCredits;
  final int hoursSwapped;
  final int activePartners;
  final List<String> skillsTeaching;
  final List<String> skillsLearning;

  const UserProfile({
    required this.name,
    required this.handle,
    required this.title,
    required this.bio,
    required this.location,
    required this.rating,
    required this.totalReviews,
    required this.karmaCredits,
    required this.hoursSwapped,
    required this.activePartners,
    required this.skillsTeaching,
    required this.skillsLearning,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] ?? 'Alex Chen',
      handle: json['handle'] ?? '@alexchen',
      title: json['title'] ?? 'Full-Stack Developer & UI Enthusiast',
      bio: json['bio'] ??
          'Passionate about building performant mobile apps and microservices. Eager to exchange programming mentorship for language and digital design skills.',
      location: json['location'] ?? 'San Francisco, CA',
      rating: (json['rating'] as num?)?.toDouble() ?? 4.95,
      totalReviews: json['totalReviews'] ?? 28,
      karmaCredits: json['karmaCredits'] ?? 140,
      hoursSwapped: json['hoursSwapped'] ?? 36,
      activePartners: json['activePartners'] ?? 4,
      skillsTeaching: (json['skillsTeaching'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          ['Flutter', 'Dart', 'Node.js', 'PostgreSQL'],
      skillsLearning: (json['skillsLearning'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          ['Conversational French', 'Figma Tokens', 'Color Grading'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'handle': handle,
      'title': title,
      'bio': bio,
      'location': location,
      'rating': rating,
      'totalReviews': totalReviews,
      'karmaCredits': karmaCredits,
      'hoursSwapped': hoursSwapped,
      'activePartners': activePartners,
      'skillsTeaching': skillsTeaching,
      'skillsLearning': skillsLearning,
    };
  }

  static UserProfile get defaultProfile => const UserProfile(
    name: 'Alex Chen',
    handle: '@alexchen',
    title: 'Full-Stack Developer & UI Enthusiast',
    bio:
        'Passionate about building performant mobile apps and microservices. Eager to exchange programming mentorship for language and digital design skills.',
    location: 'San Francisco, CA',
    rating: 4.95,
    totalReviews: 28,
    karmaCredits: 140,
    hoursSwapped: 36,
    activePartners: 4,
    skillsTeaching: ['Flutter', 'Dart', 'Node.js', 'PostgreSQL'],
    skillsLearning: ['Conversational French', 'Figma Tokens', 'Color Grading'],
  );
}

