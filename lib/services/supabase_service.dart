import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/supabase_config.dart';
import '../models/skill_listing.dart';
import '../models/swap_activity.dart';
import '../models/user_profile.dart';

class SupabaseService {
  static bool _isInitialized = false;
  static bool get isInitialized => _isInitialized;

  /// Safe initialization called at app startup
  static Future<bool> initialize() async {
    if (!SupabaseConfig.isConfigured) {
      debugPrint('[SupabaseService] Supabase credentials not set. Running in local/REST mode.');
      return false;
    }

    try {
      await Supabase.initialize(
        url: SupabaseConfig.supabaseUrl,
        publishableKey: SupabaseConfig.supabaseAnonKey,
      );
      _isInitialized = true;
      debugPrint('[SupabaseService] Connected to Supabase Cloud successfully!');
      return true;
    } catch (e) {
      debugPrint('[SupabaseService] Initialization failed: $e');
      _isInitialized = false;
      return false;
    }
  }

  static SupabaseClient? get client {
    if (!_isInitialized) return null;
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  // 1. Authentication: Register
  static Future<Map<String, dynamic>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final sb = client;
    if (sb == null) return {'success': false, 'error': 'Supabase is not initialized'};

    try {
      final res = await sb.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': name},
      );

      final user = res.user;
      if (user != null) {
        try {
          await sb.from('profiles').upsert({
            'id': user.id,
            'name': name,
            'email': email,
            'handle': '@${name.toLowerCase().replaceAll(RegExp(r'\s+'), '')}',
            'title': 'SkillSwap Member',
            'bio': 'Passionate about sharing skills and learning new crafts.',
            'location': 'Global Community',
            'rating': 5.0,
            'total_reviews': 0,
            'karma_credits': 100,
            'hours_swapped': 0,
            'active_partners': 0,
            'skills_teaching': ['General Skills'],
            'skills_learning': ['Exploring'],
          });
        } catch (profileErr) {
          debugPrint('[SupabaseService] Profile upsert note: $profileErr');
        }

        return {
          'success': true,
          'message': 'Account created successfully in Supabase!',
          'token': res.session?.accessToken ?? 'sb-session-active',
          'user': {
            'id': user.id,
            'name': name,
            'email': email,
          },
        };
      }

      return {'success': false, 'error': 'Registration failed: No user returned'};
    } on AuthException catch (e) {
      return {'success': false, 'error': e.message};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // 2. Authentication: Login
  static Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    final sb = client;
    if (sb == null) return {'success': false, 'error': 'Supabase is not initialized'};

    try {
      final res = await sb.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = res.user;
      if (user != null) {
        UserProfile? profile;
        try {
          final profileData = await sb.from('profiles').select().eq('id', user.id).maybeSingle();
          if (profileData != null) {
            profile = UserProfile.fromJson(profileData);
          }
        } catch (_) {}

        return {
          'success': true,
          'message': 'Signed in successfully via Supabase!',
          'token': res.session?.accessToken,
          'user': profile?.toJson() ?? {'email': email, 'name': user.userMetadata?['full_name'] ?? email},
        };
      }

      return {'success': false, 'error': 'Invalid credentials'};
    } on AuthException catch (e) {
      return {'success': false, 'error': e.message};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // 3. Authentication: Sign Out
  static Future<void> signOut() async {
    final sb = client;
    if (sb != null) {
      try {
        await sb.auth.signOut();
      } catch (e) {
        debugPrint('[SupabaseService] SignOut error: $e');
      }
    }
  }

  // 4. Database: Get Skill Listings
  static Future<List<SkillListing>> getListings({String? category, String? query}) async {
    final sb = client;
    if (sb == null) return [];

    try {
      var queryBuilder = sb.from('skill_listings').select();

      if (category != null && category != 'All') {
        queryBuilder = queryBuilder.eq('category', category);
      }

      if (query != null && query.isNotEmpty) {
        queryBuilder = queryBuilder.ilike('title', '%$query%');
      }

      final response = await queryBuilder.order('created_at', ascending: false);
      final List<dynamic> rows = response;

      return rows.map((r) => SkillListing(
        id: r['id']?.toString() ?? '',
        title: r['title'] ?? '',
        category: r['category'] ?? 'General',
        instructorName: r['instructor_name'] ?? 'Mentor',
        instructorAvatar: r['instructor_avatar'] ?? '',
        rating: (r['rating'] as num?)?.toDouble() ?? 5.0,
        reviewsCount: r['reviews_count'] ?? 0,
        teachingSkill: r['teaching_skill'] ?? '',
        wantingSkill: r['wanting_skill'] ?? '',
        estimatedHours: r['estimated_hours'] ?? '2 hrs/wk',
        skillLevel: r['skill_level'] ?? 'All Levels',
        description: r['description'] ?? '',
        keyTopics: (r['key_topics'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      )).toList();
    } catch (e) {
      debugPrint('[SupabaseService] getListings error: $e');
      return [];
    }
  }

  // 5. Database: Create Skill Listing
  static Future<SkillListing?> createListing(SkillListing listing) async {
    final sb = client;
    if (sb == null) return null;

    try {
      final row = {
        'title': listing.title,
        'category': listing.category,
        'instructor_name': listing.instructorName,
        'instructor_avatar': listing.instructorAvatar,
        'rating': listing.rating,
        'reviews_count': listing.reviewsCount,
        'teaching_skill': listing.teachingSkill,
        'wanting_skill': listing.wantingSkill,
        'estimated_hours': listing.estimatedHours,
        'skill_level': listing.skillLevel,
        'description': listing.description,
        'key_topics': listing.keyTopics,
      };

      final response = await sb.from('skill_listings').insert(row).select().single();

      return SkillListing(
        id: response['id']?.toString() ?? listing.id,
        title: response['title'] ?? listing.title,
        category: response['category'] ?? listing.category,
        instructorName: response['instructor_name'] ?? listing.instructorName,
        instructorAvatar: response['instructor_avatar'] ?? listing.instructorAvatar,
        rating: (response['rating'] as num?)?.toDouble() ?? listing.rating,
        reviewsCount: response['reviews_count'] ?? listing.reviewsCount,
        teachingSkill: response['teaching_skill'] ?? listing.teachingSkill,
        wantingSkill: response['wanting_skill'] ?? listing.wantingSkill,
        estimatedHours: response['estimated_hours'] ?? listing.estimatedHours,
        skillLevel: response['skill_level'] ?? listing.skillLevel,
        description: response['description'] ?? listing.description,
        keyTopics: (response['key_topics'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? listing.keyTopics,
      );
    } catch (e) {
      debugPrint('[SupabaseService] createListing error: $e');
      return null;
    }
  }

  // 6. Database: Get Activities
  static Future<List<SwapActivity>> getActivities() async {
    final sb = client;
    if (sb == null) return [];

    try {
      final response = await sb.from('swap_activities').select().order('created_at', ascending: true);
      final List<dynamic> rows = response;

      return rows.map((r) => SwapActivity(
        id: r['id']?.toString() ?? '',
        partnerName: r['partner_name'] ?? 'Partner',
        partnerAvatar: r['partner_avatar'] ?? '',
        exchangeTitle: r['exchange_title'] ?? '',
        sessionTime: r['session_time'] ?? 'TBD',
        platform: r['platform'] ?? 'Google Meet',
        isCompleted: r['is_completed'] ?? false,
        status: r['status'] ?? 'Active',
        checklist: (r['checklist'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
        checklistDone: (r['checklist_done'] as List<dynamic>?)?.map((e) => e as bool).toList() ?? [],
      )).toList();
    } catch (e) {
      debugPrint('[SupabaseService] getActivities error: $e');
      return [];
    }
  }

  // 7. Database: Toggle Activity
  static Future<SwapActivity?> toggleActivity(String id, {int? milestoneIndex}) async {
    final sb = client;
    if (sb == null) return null;

    try {
      final current = await sb.from('swap_activities').select().eq('id', id).single();
      final checklist = (current['checklist'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
      final checklistDone = (current['checklist_done'] as List<dynamic>?)?.map((e) => e as bool).toList() ??
          List.filled(checklist.length, false);

      bool isCompleted = current['is_completed'] ?? false;
      String status = current['status'] ?? 'Active';

      if (milestoneIndex != null && milestoneIndex < checklistDone.length) {
        checklistDone[milestoneIndex] = !checklistDone[milestoneIndex];
        isCompleted = checklistDone.every((d) => d);
        status = isCompleted ? 'Completed' : 'Active';
      } else {
        isCompleted = !isCompleted;
        status = isCompleted ? 'Completed' : 'Active';
        for (int i = 0; i < checklistDone.length; i++) {
          checklistDone[i] = isCompleted;
        }
      }

      final updated = await sb.from('swap_activities').update({
        'is_completed': isCompleted,
        'status': status,
        'checklist_done': checklistDone,
      }).eq('id', id).select().single();

      return SwapActivity(
        id: updated['id']?.toString() ?? id,
        partnerName: updated['partner_name'] ?? '',
        partnerAvatar: updated['partner_avatar'] ?? '',
        exchangeTitle: updated['exchange_title'] ?? '',
        sessionTime: updated['session_time'] ?? '',
        platform: updated['platform'] ?? '',
        isCompleted: updated['is_completed'] ?? false,
        status: updated['status'] ?? 'Active',
        checklist: checklist,
        checklistDone: checklistDone,
      );
    } catch (e) {
      debugPrint('[SupabaseService] toggleActivity error: $e');
      return null;
    }
  }

  // 8. Database: Get Profile
  static Future<UserProfile?> getProfile() async {
    final sb = client;
    if (sb == null) return null;

    try {
      final currentUserId = sb.auth.currentUser?.id;
      final query = currentUserId != null
          ? sb.from('profiles').select().eq('id', currentUserId).maybeSingle()
          : sb.from('profiles').select().limit(1).maybeSingle();

      final data = await query;
      if (data != null) {
        return UserProfile(
          name: data['name'] ?? 'Alex Chen',
          handle: data['handle'] ?? '@alexchen',
          title: data['title'] ?? 'Full-Stack Developer & UI Enthusiast',
          bio: data['bio'] ?? '',
          location: data['location'] ?? 'San Francisco, CA',
          rating: (data['rating'] as num?)?.toDouble() ?? 4.95,
          totalReviews: data['total_reviews'] ?? 28,
          karmaCredits: data['karma_credits'] ?? 140,
          hoursSwapped: data['hours_swapped'] ?? 36,
          activePartners: data['active_partners'] ?? 4,
          skillsTeaching: (data['skills_teaching'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
          skillsLearning: (data['skills_learning'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
        );
      }
    } catch (e) {
      debugPrint('[SupabaseService] getProfile error: $e');
    }
    return null;
  }
}
