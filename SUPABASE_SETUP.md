# Supabase Setup Guide for Minimal Pong

This guide will help you set up Supabase storage for the leaderboards in your Minimal Pong game.

## Prerequisites

- Supabase CLI installed (done ✅)
- A Supabase account (create one at [supabase.com](https://supabase.com))

## Setup Options

### Option 1: Local Development with Supabase CLI

1. **Start local Supabase** (requires Docker):
   ```bash
   supabase start
   ```

2. **Apply migrations**:
   ```bash
   supabase db reset
   ```

3. **Get local credentials**:
   ```bash
   supabase status
   ```
   Copy the `API URL` and `anon key` values.

4. **Configure the game**:
   - Open `supabase-config.js`
   - Update the URL and key variables with your local values

### Option 2: Production Setup

1. **Create a new Supabase project**:
   - Go to [supabase.com](https://supabase.com)
   - Click "New Project"
   - Fill in project details

2. **Run the migration**:
   - Go to your project dashboard
   - Navigate to SQL Editor
   - Copy and paste the contents of `supabase/migrations/20250120000000_create_leaderboard.sql`
   - Run the query

3. **Get your project credentials**:
   - Go to Project Settings → API
   - Copy your `Project URL` and `Project API Key (anon public)`

4. **Configure the game**:
   - Option A: Update `supabase-config.js` directly with your credentials
   - Option B: Set environment variables in your hosting platform:
     ```bash
     SUPABASE_URL=your-project-url
     SUPABASE_ANON_KEY=your-anon-key
     ```

## Database Schema

The leaderboard table includes:
- `id`: Unique identifier
- `player_name`: Winner's name (max 20 characters)
- `player_score`: Winner's score
- `opponent_score`: Loser's score  
- `game_duration`: Game length in seconds
- `created_at`: Timestamp
- `updated_at`: Last modified timestamp

## Security

- Row Level Security (RLS) is enabled
- Anyone can read the leaderboard
- Anyone can insert new scores
- No update/delete permissions for better data integrity

## Features

✅ **Save winning scores** with player names
✅ **View leaderboard** with top 10 scores  
✅ **Game duration tracking**
✅ **Minimalist UI** matching the game's design
✅ **Real-time leaderboard** updates
✅ **First to 11 points wins** game mode

## Testing

1. Play a game to completion (first to 11 points)
2. Enter a player name when prompted
3. Click "Save Score"
4. View the leaderboard to see your entry

## Troubleshooting

**Issue**: "Supabase not connected" in console
- **Solution**: Check your URL and API key in `supabase-config.js`

**Issue**: "Failed to save score"
- **Solution**: Verify your database permissions and RLS policies

**Issue**: Empty leaderboard
- **Solution**: Play a few games and save scores first

**Issue**: Local development not working
- **Solution**: Ensure Docker is running and `supabase start` completed successfully

## Next Steps

- Customize the winning score (currently 11 points)
- Add player statistics and win/loss records
- Implement tournaments or seasonal leaderboards
- Add social features like sharing scores