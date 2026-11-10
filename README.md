# SkillSwap — Peer-to-Peer Knowledge Exchange Mobile App

**Course:** CSE3212: Mobile Application Development  
**Student Name:** Talha Ibna Zaman  
**Student ID:** 0182420012101405 / 0182420012101368  
**Instructor:** Fahad Bin Mahbub  

---

## 1. Project Overview & Problem Statement
Traditional online learning and tutoring platforms require hefty recurring subscriptions or hourly tutor fees. **SkillSwap** solves this real-world barrier by enabling a cashless barter economy for skills:
- *“You teach someone Flutter & State Management, they guide you through Figma UI/UX Systems.”*
- *“You practice conversational French in exchange for Python web scraping scripts.”*

The application was developed across three sequential lab milestones using Flutter (Dart), a lightweight Node.js REST API backend, and **Supabase Cloud (PostgreSQL & Auth)**.

---

## 2. Lab Milestones Implemented

### Phase 1 (Lab Task 1): Auth Architecture & Strict Form Validation
- **Login & Registration Screens:** Clean, modern EduTech theme (`#1E1B4B` Deep Indigo, `#FF6B4A` Vibrant Coral accent, `#F8FAFC` canvas).
- **Form Validation Engine:**
  - **Full Name:** Required, minimum 3 characters, alphabetical characters only (`RegExp(r'^[a-zA-Z\s]+$')`).
  - **Email:** Required, RFC regex standard validation format.
  - **Password:** Required, minimum 6 characters, alphanumeric strong format requiring both letters and numbers.
  - **Confirm Password:** Strict equality check against password field.
  - **Terms of Service:** Mandatory agreement checkbox with visible inline validation state.
- **Hardware Deployment:** Built specifically with `--target-platform android-arm64` and deployed on physical test phone V2055.

### Phase 2 (Lab Task 2): Modular Architecture, Navigation & Interactive Tabs
- **Modular Directory Hierarchy:**
  - `lib/core/`: Centralized theme tokens (`AppColors`, `AppTheme`) and backend configuration (`SupabaseConfig`).
  - `lib/models/`: Type-safe data models (`SkillListing`, `CommunityPost`, `SwapActivity`, `UserProfile`).
  - `lib/widgets/`: Reusable atomic UI components (`CustomTextField`, `AppButton`, `SkillCard`, `CommunityCard`, `ActivityCard`).
  - `lib/screens/home/tabs/`:
    1. **Explore Tab:** Category filter chips (`All`, `Tech`, `Language`, `Design`, `Media`, `Music`), real-time search filtering, and rich barter cards.
    2. **Community Feed:** Peer discussion barter proposals with interactive heart/like counters and post creation modal.
    3. **Activity & Schedule:** Active swaps, session filter chips (`All`, `Active`, `Scheduled`, `Completed`), and interactive milestone checklists.
    4. **Profile Tab:** Karma Credits, Hours Swapped, ratings, teaching/learning tags, and account controls.
- **Interactive ModalBottomSheets:** Tapping any skill listing card opens `SkillDetailSheet` displaying instructor bio, barter matrix (Offering vs Seeking), syllabus topics, and "Propose Skill Swap" action button.
- **Side Navigation Drawer:** Features user identity header, karma badge, tab shortcuts, live **Backend Engine switcher** (Hybrid, Node.js REST, Supabase Cloud), and a working **Logout confirmation dialog** (`AlertDialog`) clearing navigation back to `/login`.

### Phase 3 (Lab Task 3): REST API Backend & Full-Stack Integration
- **Zero-Dependency Node.js Server (`backend/server.js`):** Built with native Node.js HTTP standard libraries (`http`, `url`) without external packages, listening on port 5000 with full CORS support.
- **API Endpoints:**
  | Method | Endpoint | Description |
  |---|---|---|
  | `POST` | `/api/auth/register` | User registration & initial karma allocation |
  | `POST` | `/api/auth/login` | Credential validation & token generation |
  | `GET` | `/api/items` | Fetch skill exchange listings with `category` & `q` filters |
  | `POST` | `/api/items` | Publish new barter exchange card |
  | `GET` | `/api/activity` | Retrieve active & scheduled swap sessions |
  | `PATCH` | `/api/activity/:id/toggle` | Toggle session milestone completion & status |
  | `GET` | `/api/profile` | Retrieve user profile stats, karma, and skills |
- **Device Networking & ADB Reverse:** Configured `adb reverse tcp:5000 tcp:5000` so the physical Android phone seamlessly accesses `http://localhost:5000`.

---

## 3. Supabase Integration (Dual-Backend Architecture)

The application now supports **Supabase Cloud (PostgreSQL + Gotrue Auth + Storage)** alongside the original Node.js REST API.

### Features Implemented:
1. **`supabase_flutter: ^2.18.3` SDK:**
   - Asynchronous safe initialization at startup in `lib/main.dart`.
2. **Unified Backend Gateway (`lib/services/api_service.dart`):**
   - Automatically orchestrates requests:
     - **Hybrid Mode (Default):** Prefers Supabase when credentials are configured; seamlessly falls back to Node.js REST API (`http://localhost:5000`) or local offline store if unconfigured or offline.
     - **Node.js REST Mode:** Direct communication with `backend/server.js`.
     - **Supabase Cloud Mode:** Direct communication with Supabase Auth and PostgreSQL tables.
3. **Database Schema & SQL Script (`backend/supabase_schema.sql`):**
   - Ready-to-run SQL script for Supabase SQL Editor:
     - `profiles` table (linked to `auth.users`).
     - `skill_listings` table (with full barter metadata).
     - `swap_activities` table (with milestone checklist arrays).
     - Row Level Security (RLS) policies and seed records.

### How to Configure Your Supabase Project:
1. Create a free project at [supabase.com](https://supabase.com).
2. Go to **SQL Editor** in your Supabase dashboard and run [`backend/supabase_schema.sql`](file:///D:/yy/backend/supabase_schema.sql).
3. Copy your **Project URL** and **anon public key** from Project Settings > API.
4. Paste them into [`lib/core/supabase_config.dart`](file:///D:/yy/lib/core/supabase_config.dart):
   ```dart
   static const String supabaseUrl = 'https://YOUR_PROJECT.supabase.co';
   static const String supabaseAnonKey = 'YOUR_ANON_KEY';
   ```

---

## 4. How to Run the Project

### Option A: Run with Local Node.js Server
```bash
# 1. Start the Node.js backend:
node backend/server.js

# 2. Forward port over USB (if testing on physical Android phone):
adb reverse tcp:5000 tcp:5000

# 3. Run Flutter app:
flutter run
```

### Option B: Run with Supabase Cloud
1. Configure credentials in `lib/core/supabase_config.dart`.
2. Run `flutter run`. The app will automatically connect to Supabase Cloud!

---

## 5. Submission Structure
```
CSE3212_FlutterLabTask3_0182420012101405/
├── backend/
│   ├── server.js               # Zero-dependency Node.js REST server
│   └── supabase_schema.sql     # Supabase PostgreSQL schema & seed script
├── lib/
│   ├── core/
│   │   ├── supabase_config.dart # Supabase & Backend Engine configuration
│   │   └── theme.dart
│   ├── models/
│   │   ├── community_post.dart
│   │   ├── skill_listing.dart
│   │   ├── swap_activity.dart
│   │   └── user_profile.dart
│   ├── screens/
│   │   ├── auth/
│   │   │   ├── login_screen.dart
│   │   │   └── register_screen.dart
│   │   └── home/
│   │       ├── home_screen.dart
│   │       ├── tabs/
│   │       │   ├── activity_tab.dart
│   │       │   ├── explore_tab.dart
│   │       │   ├── feed_tab.dart
│   │       │   └── profile_tab.dart
│   │       └── widgets/
│   │           ├── home_drawer.dart
│   │           └── skill_detail_sheet.dart
│   ├── services/
│   │   ├── api_service.dart     # Dual-backend unified orchestrator
│   │   └── supabase_service.dart# Supabase Auth & PostgreSQL client
│   ├── widgets/
│   │   ├── activity_card.dart
│   │   ├── app_button.dart
│   │   ├── community_card.dart
│   │   ├── custom_text_field.dart
│   │   └── skill_card.dart
│   └── main.dart
├── android/
├── pubspec.yaml
└── README.md
```
