enum BackendType {
  supabase,
  nodeRest,
  hybrid, // Uses Supabase if configured & reachable, otherwise Node.js REST
}

class SupabaseConfig {
  /// Paste your Supabase Project URL here
  /// Example: 'https://xyzcompany.supabase.co'
  static const String supabaseUrl = 'https://your-project.supabase.co';

  /// Paste your Supabase Public Anon Key here
  /// Example: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...'
  static const String supabaseAnonKey = 'your-anon-key-here';

  /// Active backend selection (can be toggled at runtime)
  static BackendType activeBackend = BackendType.hybrid;

  /// Returns true if valid custom Supabase credentials have been configured
  static bool get isConfigured {
    final isUrlValid = supabaseUrl.isNotEmpty &&
        supabaseUrl.startsWith('https://') &&
        !supabaseUrl.contains('your-project.supabase.co');

    final isKeyValid = supabaseAnonKey.isNotEmpty &&
        !supabaseAnonKey.contains('your-anon-key-here') &&
        supabaseAnonKey.length > 20;

    return isUrlValid && isKeyValid;
  }

  /// Helper to get current backend name
  static String get backendDisplayName {
    switch (activeBackend) {
      case BackendType.supabase:
        return 'Supabase Cloud (PostgreSQL)';
      case BackendType.nodeRest:
        return 'Node.js REST (Port 5000)';
      case BackendType.hybrid:
        return isConfigured ? 'Hybrid (Supabase Active)' : 'Hybrid (Node.js REST Active)';
    }
  }
}

