# Minimal Pong

A clean, minimalist implementation of the classic Pong game inspired by BRAUN and Otl Aicher design principles, now with **Supabase-powered leaderboards**.

## Design Philosophy

This game embodies the principles of functional minimalism:
- **Monochrome Palette**: Clean blacks, whites, and grays
- **Geometric Precision**: Simple, exact shapes
- **Functional Typography**: Inter font for clarity and readability
- **No Decoration**: Every element serves a purpose

## Features

- 🎮 Two-player local gameplay
- 🎯 Physics-based ball collision
- 📊 Real-time score tracking
- 🏆 **Supabase-powered leaderboards**
- 💾 **Persistent score storage**
- ⏱️ **Game duration tracking**
- 🥇 **First to 11 points wins**
- 🎨 Minimalist aesthetic
- 📱 Responsive design

## How to Play

- **Player 1** (Left): Use `W` and `S` keys
- **Player 2** (Right): Use `↑` and `↓` arrow keys
- Press `Play` button or `Space` to start
- **First to 11 points wins**
- Enter winner's name to save to leaderboard
- View leaderboard to see top scores

## New Leaderboard Features

### Gameplay
- Games now end when a player reaches 11 points
- Winner's name is captured for the leaderboard
- Game duration is automatically tracked
- Scores are persistently stored in Supabase

### Leaderboard
- View top 10 scores of all time
- See player names, scores, and match results
- Real-time updates when new scores are added
- Clean, minimalist design matching the game aesthetic

## Setup

### Basic Setup (Game Only)
1. Open `index.html` in any modern web browser
2. Enjoy the game!

### Full Setup (With Leaderboards)
1. Follow the instructions in `SUPABASE_SETUP.md`
2. Configure your Supabase project
3. Update `supabase-config.js` with your credentials
4. Deploy or run locally

## Design Inspiration

Inspired by the design philosophies of:
- **Dieter Rams** and BRAUN's functional design
- **Otl Aicher's** systematic approach to visual communication
- **Swiss Design** principles of clarity and precision
- **Museum of Modern Art (MOMA)** aesthetic sensibilities

## Technical Details

- Pure HTML5 Canvas implementation
- Vanilla JavaScript (no framework dependencies)
- Supabase for backend storage and real-time features
- Responsive design with CSS Grid and Flexbox
- 60fps game loop with requestAnimationFrame
- Row Level Security (RLS) for secure data access

## Architecture

```
├── index.html              # Main game file with UI and game logic
├── supabase-config.js      # Supabase client configuration
├── supabase/
│   ├── config.toml         # Supabase project configuration
│   └── migrations/         # Database schema migrations
│       └── 20250120000000_create_leaderboard.sql
├── .env.example            # Environment variables template
└── SUPABASE_SETUP.md       # Setup instructions
```

## Database Schema

The leaderboard uses a simple, efficient schema:
- **player_name**: Winner's name (text, max 20 chars)
- **player_score**: Winner's final score (integer)
- **opponent_score**: Loser's final score (integer)
- **game_duration**: Game length tracking (interval)
- **created_at**: Timestamp for sorting and history

## Development

### Local Development
```bash
# Start Supabase locally (requires Docker)
supabase start

# Apply database migrations
supabase db reset

# Open index.html in browser
```

### Production Deployment
1. Create a Supabase project at [supabase.com](https://supabase.com)
2. Run the migration in SQL Editor
3. Update configuration with your project credentials
4. Deploy to your hosting platform (Vercel, Netlify, etc.)

## Contributing

This project maintains the principle of functional minimalism. When contributing:
- Preserve the clean aesthetic
- Follow the established color palette
- Ensure features serve a clear purpose
- Maintain the single-file structure where possible

## License

MIT License - Feel free to use and modify as needed.

---

*Created with attention to functional design and clean aesthetics.*
