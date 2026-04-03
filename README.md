# Minimal Pong

A clean implementation of the classic Pong game in the **Nothing design language** — monochrome, typographic, industrial.

## Design Philosophy

This game follows the Nothing design system:

- **OLED Black Canvas**: `#000000` background with white typographic foreground
- **Doto + Space Mono** font stack from Google Fonts
- **Three-Layer Hierarchy**: display (Doto), body (Space Grotesk), metadata (Space Mono caps)
- **Dot-Matrix Motif**: subtle background grid inspired by the N brand
- **No shadows, no blur, no gradients** — flat surfaces, border separation

## Features

### Core
- Two-player local gameplay & AI opponent
- Physics-based ball collision with hit-position angle
- Real-time score, rally count, and speed display
- Supabase leaderboard integration

### Gameplay
- **Curve/Spin** — move your paddle at contact to curve the ball path
- **Power Shots** — hold `Q` (P1) or `O` (P2) to charge a 1.8× speed burst, 2s cooldown
- **Power-Ups** — spawn during rallies: **BIG** paddle, **SMALL** opponent, **SHIELD** wall, **SPLIT** ball, **SLOW** motion
- **Ball Trail** — fading afterimage dots
- **Screen Shake** — subtle jolt on goals
- **Rising Pitch Sounds** — each paddle hit is a higher note, making long rallies musical
- **Score Flash** — red number on scored side

### Modes
- **Match** — first to X points (5 / 10 / 15)
- **Endless** — no score limit, see how long the rally lasts
- **AI Difficulty** — Easy, Medium, Hard (changes speed, reaction time, ball prediction)
- **Win Streak** — tracked locally across sessions

## How to Play

| Control | Action |
|---|---|
| `W` / `S` | Player 1 move |
| `↑` / `↓` | Player 2 move |
| `Q` | Player 1 charge power shot |
| `O` | Player 2 charge power shot |
| `P` | Pause / Resume |
| `Space` | Quick start from menu |

## Technical Details

- Single HTML file, zero dependencies (except Supabase JS SDK)
- Canvas rendering with dot-matrix background
- Web Audio API for procedural sound effects
- LocalStorage for win streak persistence
- Supabase for cloud leaderboard

## Supabase Setup

Create a Supabase project and add a `leaderboard` table:

```sql
create table leaderboard (
  id bigint generated always as identity primary key,
  player_name text not null,
  player_score int not null,
  opponent_score int not null,
  duration text,
  created_at timestamptz default now()
);

alter table leaderboard enable row level security;

create policy "Allow public read access"
  on leaderboard for select
  to anon
  using (true);

create policy "Allow public insert access"
  on leaderboard for insert
  to anon
  with check (true);
```

Then update `supabase-config.js` with your project URL and anon key.

## Development

### Structure

| File | Purpose |
|---|---|
| `index.html` | Game + UI + styles (single-file app) |
| `supabase-config.js` | Supabase client + manager class |
| `vercel.json` | Deployment config |
| `.github/workflows/` | CI/CD |

### Running Locally

```bash
open index.html
```

Requires an HTTP server if using Supabase (open file protocol blocks fetch in some browsers):

```bash
python3 -m http.server 8080
# or
npx serve .
```

### Deploying

The `vercel.json` config is set for deployment to Vercel.

## License

MIT
