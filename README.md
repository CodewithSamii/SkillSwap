# SkillSwap — Peer-to-Peer Knowledge Exchange Mobile App

SkillSwap is a modern, community-driven mobile platform built for exchanging skills, crafts, and mentorship without monetary transactions. Trade your expertise in one domain for mentorship in another through a cashless barter economy.

---

## Features

### 1. Authentication & Security
- Modern EduTech interface with responsive form controls.
- Real-time client-side validation for names, RFC-compliant email formatting, and password strength.
- Multi-backend authentication support with persistent sessions.

### 2. Interactive Discovery & Barter Feed
- **Explore Catalog:** Search by keyword and filter listings across categories (Tech, Design, Language, Media, Music).
- **Interactive Detail Sheets:** Inspect instructor background, barter match (Offering vs Seeking), syllabus topics, and commitment estimates.
- **Community Feed:** Post barter inquiries, engage with peer requests, and track upvote discussions.

### 3. Session Scheduling & Milestone Tracking
- Track active, scheduled, and completed learning sessions.
- Interactive milestone checklists with real-time completion toggling.
- Integration options for remote sessions (Google Meet, Zoom, Discord).

### 4. Dual-Backend Architecture
- **Supabase Cloud:** PostgreSQL database, Gotrue authentication, and real-time synchronization.
- **Node.js REST API:** Built-in lightweight zero-dependency server (`backend/server.js`) on port 5000.
- **Hybrid Auto-Failover:** Automatically uses Supabase Cloud when configured and falls back to local REST or offline cache seamlessly.

---

## Tech Stack

- **Client:** Flutter 3 (Dart 3)
- **Design System:** Material 3 with custom tokens
- **Cloud Database & Auth:** Supabase Cloud (`supabase_flutter`)
- **Local Server:** Node.js HTTP Server (`backend/server.js`)
- **Networking:** `http: ^1.2.0` with JSON serialization & offline resilience

---

## Getting Started

### Prerequisites
- Flutter SDK (3.x or later)
- Android / iOS device or emulator
- Node.js (v18+)

### 1. Clone the Repository
```bash
git clone https://github.com/CodewithSamii/SkillSwap.git
cd SkillSwap
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Run with Local REST Backend
```bash
# Start local backend server
node backend/server.js

# If testing on physical Android device over USB:
adb reverse tcp:5000 tcp:5000

# Launch the app
flutter run
```

### 4. (Optional) Connect to Supabase Cloud
1. Create a project at [supabase.com](https://supabase.com).
2. Run `backend/supabase_schema.sql` in the Supabase SQL Editor.
3. Add your project URL and public key in `lib/core/supabase_config.dart`:
   ```dart
   static const String supabaseUrl = 'https://YOUR_PROJECT.supabase.co';
   static const String supabaseAnonKey = 'YOUR_ANON_KEY';
   ```

---

## Project Structure

```
├── backend/
│   ├── server.js               # Node.js REST API server
│   └── supabase_schema.sql     # Supabase PostgreSQL schema & seed script
├── lib/
│   ├── core/                   # Theme tokens & Supabase configuration
│   ├── models/                 # Data models (SkillListing, CommunityPost, etc.)
│   ├── screens/                # Auth & Home screens with modular tabs
│   ├── services/               # Dual-backend unified API & Supabase services
│   └── widgets/                # Reusable UI components
├── android/                    # Android native configuration
└── pubspec.yaml                # App dependencies & assets
```

---

## License
MIT License. Free for open-source exploration and educational development.
