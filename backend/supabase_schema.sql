-- ==============================================================
-- SkillSwap Supabase Database Schema & Initial Seed Script
-- Run this in your Supabase SQL Editor (https://supabase.com/dashboard)
-- ==============================================================

-- 1. PROFILES TABLE (Stores user knowledge exchange stats & karma)
create table if not exists public.profiles (
  id uuid references auth.users on delete cascade primary key,
  name text not null,
  email text not null,
  handle text,
  title text,
  bio text,
  location text default 'San Francisco, CA',
  rating numeric default 4.95,
  total_reviews integer default 28,
  karma_credits integer default 140,
  hours_swapped integer default 36,
  active_partners integer default 4,
  skills_teaching text[] default array['Flutter', 'Dart', 'Node.js', 'PostgreSQL'],
  skills_learning text[] default array['Conversational French', 'Figma Tokens', 'Color Grading'],
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 2. SKILL LISTINGS TABLE (Explore tab barter catalog)
create table if not exists public.skill_listings (
  id uuid default gen_random_uuid() primary key,
  title text not null,
  category text not null,
  instructor_name text not null,
  instructor_avatar text default 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150',
  rating numeric default 5.0,
  reviews_count integer default 1,
  teaching_skill text not null,
  wanting_skill text not null,
  estimated_hours text default '2 hrs/wk',
  skill_level text default 'All Levels',
  description text not null,
  key_topics text[] default array[]::text[],
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 3. SWAP ACTIVITIES TABLE (Activity & schedule tracking)
create table if not exists public.swap_activities (
  id text primary key,
  partner_name text not null,
  partner_avatar text default '',
  exchange_title text not null,
  session_time text not null,
  platform text default 'Google Meet',
  is_completed boolean default false,
  status text default 'Active',
  checklist text[] default array[]::text[],
  checklist_done boolean[] default array[]::boolean[],
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 4. ROW LEVEL SECURITY (RLS) POLICIES
alter table public.profiles enable row level security;
alter table public.skill_listings enable row level security;
alter table public.swap_activities enable row level security;

-- Allow public read access (for anon or authenticated users)
create policy "Allow public read on profiles" on public.profiles for select using (true);
create policy "Allow public insert on profiles" on public.profiles for insert with check (true);
create policy "Allow public update on profiles" on public.profiles for update using (true);

create policy "Allow public read on skill_listings" on public.skill_listings for select using (true);
create policy "Allow public insert on skill_listings" on public.skill_listings for insert with check (true);

create policy "Allow public read on swap_activities" on public.swap_activities for select using (true);
create policy "Allow public update on swap_activities" on public.swap_activities for update using (true);
create policy "Allow public insert on swap_activities" on public.swap_activities for insert with check (true);

-- 5. INITIAL SEED DATA FOR SKILL LISTINGS
insert into public.skill_listings (title, category, instructor_name, instructor_avatar, rating, reviews_count, teaching_skill, wanting_skill, estimated_hours, skill_level, description, key_topics)
values
(
  'Full-Stack Flutter & State Management',
  'Tech',
  'Marcus Vance',
  'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150',
  4.9,
  38,
  'Flutter & Riverpod',
  'Figma UI/UX Systems',
  '3 hrs/wk',
  'Advanced',
  'Learn clean architecture in Flutter, custom painters, and reactive state management. In exchange, I need hands-on mentoring to build polished Figma component libraries.',
  array['Clean Architecture', 'Custom Render Objects', 'Riverpod 2.0', 'Repository Pattern']
),
(
  'Conversational French & Pronunciation',
  'Language',
  'Amélie Laurent',
  'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
  5.0,
  44,
  'Native French',
  'Python Automation',
  '2 hrs/wk',
  'All Levels',
  'Parisian native providing immersive conversational French, slang, and accent tuning. Seeking someone to guide me through basic Python scripting for web scraping.',
  array['Everyday Slang', 'Phonetics & Nasal Vowels', 'Business Etiquette', 'Cinema Dialogues']
),
(
  'Modern Brand Identity & Typography',
  'Design',
  'Elena Rostova',
  'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=150',
  4.8,
  29,
  'Brand Identity',
  'SQL & Data Analysis',
  '2.5 hrs/wk',
  'Intermediate',
  'Senior visual designer teaching modular design systems, typographic hierarchy, and vector branding. Wanting to exchange for intermediate PostgreSQL & metrics dashboards.',
  array['Grid Systems', 'Typographic Pairings', 'Style Guides', 'Packaging Aesthetics']
);

-- 6. INITIAL SEED DATA FOR SWAP ACTIVITIES
insert into public.swap_activities (id, partner_name, partner_avatar, exchange_title, session_time, platform, is_completed, status, checklist, checklist_done)
values
(
  'act-1',
  'Marcus Vance',
  'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150',
  'Flutter Architecture ⇄ Figma Design System',
  'Today at 6:30 PM (45 mins)',
  'Google Meet',
  false,
  'Active',
  array['Review StateNotifier implementation', 'Figma auto-layout & tokens audit', 'Set up repository interfaces'],
  array[true, false, false]
),
(
  'act-2',
  'Amélie Laurent',
  'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
  'French Pronunciation ⇄ Python Scraping',
  'Tomorrow at 4:00 PM (60 mins)',
  'Discord Voice',
  false,
  'Scheduled',
  array['Practice nasal vowels & linking syllables', 'Intro to BeautifulSoup and requests', 'Parse restaurant menu dataset'],
  array[false, false, false]
)
on conflict (id) do nothing;

