-- Create leaderboard table for storing pong game scores
CREATE TABLE IF NOT EXISTS public.leaderboard (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    player_name text NOT NULL,
    player_score integer NOT NULL CHECK (player_score >= 0),
    opponent_score integer NOT NULL CHECK (opponent_score >= 0),
    game_duration interval,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);

-- Enable Row Level Security (RLS)
ALTER TABLE public.leaderboard ENABLE ROW LEVEL SECURITY;

-- Create policy to allow anyone to read leaderboard
CREATE POLICY "Anyone can view leaderboard" ON public.leaderboard
    FOR SELECT USING (true);

-- Create policy to allow anyone to insert new scores
CREATE POLICY "Anyone can insert scores" ON public.leaderboard
    FOR INSERT WITH CHECK (true);

-- Create index for faster queries on scores
CREATE INDEX IF NOT EXISTS idx_leaderboard_scores ON public.leaderboard (player_score DESC, created_at DESC);

-- Create index for faster queries on creation time
CREATE INDEX IF NOT EXISTS idx_leaderboard_created_at ON public.leaderboard (created_at DESC);