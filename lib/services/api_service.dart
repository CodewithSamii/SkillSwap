import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../core/supabase_config.dart';
import '../models/skill_listing.dart';
import '../models/swap_activity.dart';
import '../models/user_profile.dart';
import 'supabase_service.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:5000/api';
  static const Duration timeoutDuration = Duration(seconds: 4);

  static bool get _shouldUseSupabase {
    if (SupabaseConfig.activeBackend == BackendType.supabase) {
      return SupabaseService.isInitialized;
    }
    if (SupabaseConfig.activeBackend == BackendType.hybrid) {
      return SupabaseConfig.isConfigured && SupabaseService.isInitialized;
    }
    return false;
  }

  // 1. POST /api/auth/login
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    // Try Supabase if enabled
    if (_shouldUseSupabase) {
      final sbResult = await SupabaseService.signIn(email: email, password: password);
      if (sbResult['success'] == true || SupabaseConfig.activeBackend == BackendType.supabase) {
        return sbResult;
      }
      debugPrint('[ApiService] Supabase sign-in fell back to Node.js REST');
    }

    // Node.js REST Backend
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        final err = jsonDecode(response.body);
        return {'success': false, 'error': err['error'] ?? 'Login failed'};
      }
    } catch (e) {
      debugPrint('ApiService.login offline fallback: $e');
      return {
        'success': true,
        'message': 'Logged in (Offline / Local Mode)',
        'token': 'offline-token-mock',
        'user': UserProfile.defaultProfile.toJson(),
      };
    }
  }

  // 2. POST /api/auth/register
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    // Try Supabase if enabled
    if (_shouldUseSupabase) {
      final sbResult = await SupabaseService.signUp(name: name, email: email, password: password);
      if (sbResult['success'] == true || SupabaseConfig.activeBackend == BackendType.supabase) {
        return sbResult;
      }
      debugPrint('[ApiService] Supabase registration fell back to Node.js REST');
    }

    // Node.js REST Backend
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/register'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'name': name, 'email': email, 'password': password}),
          )
          .timeout(timeoutDuration);

      if (response.statusCode == 201) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        final err = jsonDecode(response.body);
        return {'success': false, 'error': err['error'] ?? 'Registration failed'};
      }
    } catch (e) {
      debugPrint('ApiService.register offline fallback: $e');
      return {
        'success': true,
        'message': 'Account created (Offline Mode)',
        'token': 'offline-token-mock',
      };
    }
  }

  // 3. GET /api/items (with query filters)
  static Future<List<SkillListing>> getItems({
    String? category,
    String? query,
  }) async {
    // Try Supabase if enabled
    if (_shouldUseSupabase) {
      final sbItems = await SupabaseService.getListings(category: category, query: query);
      if (sbItems.isNotEmpty) {
        return sbItems;
      }
    }

    // Node.js REST Backend
    try {
      final queryParams = <String, String>{};
      if (category != null && category != 'All') queryParams['category'] = category;
      if (query != null && query.isNotEmpty) queryParams['q'] = query;

      final uri = Uri.parse('$baseUrl/items').replace(queryParameters: queryParams.isEmpty ? null : queryParams);
      final response = await http.get(uri).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final list = (body['data'] as List<dynamic>?) ?? [];
        return list.map((item) => SkillListing.fromJson(item as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      debugPrint('ApiService.getItems offline fallback: $e');
    }

    return SkillListing.sampleListings;
  }

  // 4. POST /api/items (create new listing)
  static Future<SkillListing?> createItem(SkillListing listing) async {
    // Try Supabase if enabled
    if (_shouldUseSupabase) {
      final sbCreated = await SupabaseService.createListing(listing);
      if (sbCreated != null) return sbCreated;
    }

    // Node.js REST Backend
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/items'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(listing.toJson()),
          )
          .timeout(timeoutDuration);

      if (response.statusCode == 201) {
        final body = jsonDecode(response.body);
        return SkillListing.fromJson(body['data']);
      }
    } catch (e) {
      debugPrint('ApiService.createItem offline fallback: $e');
    }

    return listing;
  }

  // 5. GET /api/activity
  static Future<List<SwapActivity>> getActivities() async {
    // Try Supabase if enabled
    if (_shouldUseSupabase) {
      final sbActivities = await SupabaseService.getActivities();
      if (sbActivities.isNotEmpty) return sbActivities;
    }

    // Node.js REST Backend
    try {
      final response = await http.get(Uri.parse('$baseUrl/activity')).timeout(timeoutDuration);
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final list = (body['data'] as List<dynamic>?) ?? [];
        return list.map((item) => SwapActivity.fromJson(item as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      debugPrint('ApiService.getActivities offline fallback: $e');
    }

    return SwapActivity.sampleActivities;
  }

  // 6. PATCH /api/activity/:id/toggle
  static Future<SwapActivity?> toggleActivity(String id, {int? milestoneIndex}) async {
    // Try Supabase if enabled
    if (_shouldUseSupabase) {
      final sbToggled = await SupabaseService.toggleActivity(id, milestoneIndex: milestoneIndex);
      if (sbToggled != null) return sbToggled;
    }

    // Node.js REST Backend
    try {
      final response = await http
          .patch(
            Uri.parse('$baseUrl/activity/$id/toggle'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'milestoneIndex': milestoneIndex}),
          )
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return SwapActivity.fromJson(body['data']);
      }
    } catch (e) {
      debugPrint('ApiService.toggleActivity offline fallback: $e');
    }

    return null;
  }

  // 7. GET /api/profile
  static Future<UserProfile> getProfile() async {
    // Try Supabase if enabled
    if (_shouldUseSupabase) {
      final sbProfile = await SupabaseService.getProfile();
      if (sbProfile != null) return sbProfile;
    }

    // Node.js REST Backend
    try {
      final response = await http.get(Uri.parse('$baseUrl/profile')).timeout(timeoutDuration);
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return UserProfile.fromJson(body['data']);
      }
    } catch (e) {
      debugPrint('ApiService.getProfile offline fallback: $e');
    }

    return UserProfile.defaultProfile;
  }

  // 8. Sign Out
  static Future<void> logout() async {
    if (SupabaseService.isInitialized) {
      await SupabaseService.signOut();
    }
  }
}
