/**
 * SkillSwap REST API Backend
 * Pure Node.js (Zero external dependencies)
 * Runs on http://localhost:5000
 */

const http = require('http');
const url = require('url');

const PORT = 5000;

// In-Memory Database Store
const db = {
  users: [
    {
      id: 'usr-1',
      name: 'Alex Chen',
      email: 'alex.chen@example.com',
      password: 'swapPass123',
      handle: '@alexchen',
      title: 'Full-Stack Developer & UI Enthusiast',
      bio: 'Passionate about building performant mobile apps and microservices. Eager to exchange programming mentorship for language and digital design skills.',
      location: 'San Francisco, CA',
      rating: 4.95,
      totalReviews: 28,
      karmaCredits: 140,
      hoursSwapped: 36,
      activePartners: 4,
      skillsTeaching: ['Flutter', 'Dart', 'Node.js', 'PostgreSQL'],
      skillsLearning: ['Conversational French', 'Figma Tokens', 'Color Grading'],
    },
  ],
  items: [
    {
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
      description: 'Learn clean architecture in Flutter, custom painters, and reactive state management. In exchange, I need hands-on mentoring to build polished Figma component libraries.',
      keyTopics: ['Clean Architecture', 'Custom Render Objects', 'Riverpod 2.0', 'Repository Pattern'],
    },
    {
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
      description: 'Parisian native providing immersive conversational French, slang, and accent tuning. Seeking someone to guide me through basic Python scripting for web scraping.',
      keyTopics: ['Everyday Slang', 'Phonetics & Nasal Vowels', 'Business Etiquette', 'Cinema Dialogues'],
    },
    {
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
      description: 'Senior visual designer teaching modular design systems, typographic hierarchy, and vector branding. Wanting to exchange for intermediate PostgreSQL & metrics dashboards.',
      keyTopics: ['Grid Systems', 'Typographic Pairings', 'Style Guides', 'Packaging Aesthetics'],
    },
    {
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
      description: 'Hands-on color science, LUT creation, and pacing in DaVinci Resolve. In return, looking for conversion copywriting and technical SEO strategies for YouTube creator channels.',
      keyTopics: ['Node-based Grading', 'Audio Ducking & EQ', 'Pacing & Transitions', 'Export Optimization'],
    },
    {
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
      description: 'Berklee-trained guitarist teaching chord substitutions, modal soloing, and Travis picking. Looking to learn conversational Spanish for South American travel.',
      keyTopics: ['Drop 2 Chords', 'Walking Basslines', 'Modal Soloing', 'Ear Training'],
    },
  ],
  activities: [
    {
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
    },
    {
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
    },
    {
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
    },
  ],
};

// Helper: Parse incoming JSON request body
function parseJsonBody(req) {
  return new Promise((resolve) => {
    let body = '';
    req.on('data', (chunk) => {
      body += chunk.toString();
    });
    req.on('end', () => {
      try {
        resolve(body ? JSON.parse(body) : {});
      } catch (err) {
        resolve({});
      }
    });
  });
}

// Helper: Send JSON response with CORS headers
function sendJson(res, statusCode, data) {
  res.writeHead(statusCode, {
    'Content-Type': 'application/json',
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, PATCH, PUT, DELETE, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type, Authorization',
  });
  res.end(JSON.stringify(data));
}

// HTTP Server
const server = http.createServer(async (req, res) => {
  const parsedUrl = url.parse(req.url, true);
  const pathname = parsedUrl.pathname;
  const method = req.method;

  console.log(`[${new Date().toISOString()}] ${method} ${pathname}`);

  // Handle CORS pre-flight
  if (method === 'OPTIONS') {
    res.writeHead(204, {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, PATCH, PUT, DELETE, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type, Authorization',
    });
    res.end();
    return;
  }

  // 1. POST /api/auth/register
  if (method === 'POST' && pathname === '/api/auth/register') {
    const body = await parseJsonBody(req);
    const { name, email, password } = body;

    if (!name || !email || !password) {
      return sendJson(res, 400, {
        success: false,
        error: 'Name, email, and password are required',
      });
    }

    const existingUser = db.users.find((u) => u.email.toLowerCase() === email.toLowerCase());
    if (existingUser) {
      return sendJson(res, 409, {
        success: false,
        error: 'An account with this email already exists',
      });
    }

    const newUser = {
      id: `usr-${Date.now()}`,
      name,
      email,
      password,
      handle: `@${name.toLowerCase().replace(/\s+/g, '')}`,
      title: 'SkillSwap Pioneer',
      bio: 'New member ready to share knowledge and learn new skills.',
      location: 'Community Hub',
      rating: 5.0,
      totalReviews: 0,
      karmaCredits: 100, // Sign-up bonus karma
      hoursSwapped: 0,
      activePartners: 0,
      skillsTeaching: ['General Knowledge'],
      skillsLearning: ['Exploration'],
    };

    db.users.push(newUser);

    return sendJson(res, 201, {
      success: true,
      message: 'Account created successfully',
      token: `jwt-${Date.now()}`,
      user: newUser,
    });
  }

  // 2. POST /api/auth/login
  if (method === 'POST' && pathname === '/api/auth/login') {
    const body = await parseJsonBody(req);
    const { email, password } = body;

    if (!email || !password) {
      return sendJson(res, 400, {
        success: false,
        error: 'Email and password are required',
      });
    }

    let user = db.users.find((u) => u.email.toLowerCase() === email.toLowerCase());
    // Auto-create or allow demo login if password matches min length
    if (!user) {
      user = {
        id: `usr-${Date.now()}`,
        name: email.split('@')[0],
        email,
        password,
        handle: `@${email.split('@')[0]}`,
        title: 'Full-Stack Developer & UI Enthusiast',
        bio: 'Passionate about peer knowledge exchange and collaboration.',
        location: 'San Francisco, CA',
        rating: 4.95,
        totalReviews: 28,
        karmaCredits: 140,
        hoursSwapped: 36,
        activePartners: 4,
        skillsTeaching: ['Flutter', 'Dart', 'Node.js', 'PostgreSQL'],
        skillsLearning: ['Conversational French', 'Figma Tokens', 'Color Grading'],
      };
      db.users.push(user);
    }

    return sendJson(res, 200, {
      success: true,
      message: 'Authentication successful',
      token: `jwt-${Date.now()}`,
      user,
    });
  }

  // 3. GET /api/items (with query filters)
  if (method === 'GET' && pathname === '/api/items') {
    const category = parsedUrl.query.category;
    const query = (parsedUrl.query.q || '').toLowerCase();

    let results = db.items;
    if (category && category !== 'All') {
      results = results.filter((item) => item.category.toLowerCase() === category.toLowerCase());
    }
    if (query) {
      results = results.filter(
        (item) =>
          item.title.toLowerCase().includes(query) ||
          item.teachingSkill.toLowerCase().includes(query) ||
          item.wantingSkill.toLowerCase().includes(query) ||
          item.instructorName.toLowerCase().includes(query)
      );
    }

    return sendJson(res, 200, {
      success: true,
      count: results.length,
      data: results,
    });
  }

  // 4. POST /api/items (create new listing)
  if (method === 'POST' && pathname === '/api/items') {
    const body = await parseJsonBody(req);
    const { title, category, teachingSkill, wantingSkill, description, instructorName } = body;

    if (!title || !teachingSkill || !wantingSkill) {
      return sendJson(res, 400, {
        success: false,
        error: 'Title, teaching skill, and wanting skill are required',
      });
    }

    const newItem = {
      id: `item-${Date.now()}`,
      title,
      category: category || 'Tech',
      instructorName: instructorName || 'Alex Chen',
      instructorAvatar: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150',
      rating: 5.0,
      reviewsCount: 1,
      teachingSkill,
      wantingSkill,
      estimatedHours: body.estimatedHours || '2 hrs/wk',
      skillLevel: body.skillLevel || 'All Levels',
      description: description || 'Collaborative peer-to-peer exchange session.',
      keyTopics: body.keyTopics || ['Core Fundamentals', 'Live Coding Practice', 'Q&A Review'],
    };

    db.items.unshift(newItem);

    return sendJson(res, 201, {
      success: true,
      message: 'Skill listing created successfully',
      data: newItem,
    });
  }

  // 5. GET /api/activity
  if (method === 'GET' && pathname === '/api/activity') {
    return sendJson(res, 200, {
      success: true,
      data: db.activities,
    });
  }

  // 6. PATCH /api/activity/:id/toggle (toggle task or completion)
  if (method === 'PATCH' && pathname.startsWith('/api/activity/')) {
    const parts = pathname.split('/');
    const id = parts[3]; // /api/activity/:id/toggle
    const isToggleAction = parts[4] === 'toggle';

    const activity = db.activities.find((a) => a.id === id);
    if (!activity) {
      return sendJson(res, 404, {
        success: false,
        error: `Activity with id ${id} not found`,
      });
    }

    const body = await parseJsonBody(req);
    if (body.milestoneIndex !== undefined && activity.checklistDone[body.milestoneIndex] !== undefined) {
      activity.checklistDone[body.milestoneIndex] = !activity.checklistDone[body.milestoneIndex];
      activity.isCompleted = activity.checklistDone.every((d) => d);
      activity.status = activity.isCompleted ? 'Completed' : 'Active';
    } else {
      activity.isCompleted = !activity.isCompleted;
      activity.status = activity.isCompleted ? 'Completed' : 'Active';
      activity.checklistDone = activity.checklistDone.map(() => activity.isCompleted);
    }

    return sendJson(res, 200, {
      success: true,
      message: `Activity ${id} updated`,
      data: activity,
    });
  }

  // 7. GET /api/profile
  if (method === 'GET' && pathname === '/api/profile') {
    const user = db.users[0];
    return sendJson(res, 200, {
      success: true,
      data: user,
    });
  }

  // 8. Health check / Root
  if (pathname === '/' || pathname === '/api') {
    return sendJson(res, 200, {
      name: 'SkillSwap REST API',
      status: 'online',
      version: '1.0.0',
      port: PORT,
      endpoints: [
        'POST /api/auth/register',
        'POST /api/auth/login',
        'GET /api/items',
        'POST /api/items',
        'GET /api/activity',
        'PATCH /api/activity/:id/toggle',
        'GET /api/profile',
      ],
    });
  }

  // 404 Not Found
  return sendJson(res, 404, {
    success: false,
    error: `Endpoint ${method} ${pathname} not found`,
  });
});

server.listen(PORT, '0.0.0.0', () => {
  console.log(`===============================================`);
  console.log(` SkillSwap REST API Server Running!`);
  console.log(` Port: ${PORT}`);
  console.log(` Local URL: http://localhost:${PORT}`);
  console.log(` Physical Device: adb reverse tcp:5000 tcp:5000`);
  console.log(`===============================================`);
});

