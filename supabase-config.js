// Supabase configuration for the Nordic-inspired Pong game
// This file contains the Supabase client setup and database operations

class SupabaseManager {
    constructor() {
        // Get configuration from environment variables or window globals
        // Remove fallback credentials for security
        this.supabaseUrl = window.SUPABASE_URL;
        this.supabaseKey = window.SUPABASE_ANON_KEY;
        this.supabase = null;
        this.isConnected = false;
        
        this.initSupabase();
    }

    async initSupabase() {
        try {
            // Validate configuration
            if (!this.supabaseUrl || !this.supabaseKey) {
                console.warn('Supabase configuration missing. Leaderboard features disabled.');
                return;
            }
            
            // Load Supabase client from CDN
            if (typeof window.supabase === 'undefined') {
                console.log('Loading Supabase client...');
                return;
            }
            
            this.supabase = window.supabase.createClient(this.supabaseUrl, this.supabaseKey);
            this.isConnected = true;
            console.log('Supabase client initialized successfully');
        } catch (error) {
            console.warn('Failed to initialize Supabase:', error);
            this.isConnected = false;
        }
    }

    async saveScore(playerName, playerScore, opponentScore, gameDuration) {
        if (!this.isConnected || !this.supabase) {
            console.warn('Supabase not connected. Score not saved.');
            return false;
        }

        try {
            const { data, error } = await this.supabase
                .from('leaderboard')
                .insert([
                    {
                        player_name: playerName,
                        player_score: playerScore,
                        opponent_score: opponentScore,
                        game_duration: gameDuration
                    }
                ]);

            if (error) {
                console.error('Error saving score:', error);
                return false;
            }

            console.log('Score saved successfully:', data);
            return true;
        } catch (error) {
            console.error('Error saving score:', error);
            return false;
        }
    }

    async getLeaderboard(limit = 10) {
        if (!this.isConnected || !this.supabase) {
            console.warn('Supabase not connected. Returning empty leaderboard.');
            return [];
        }

        try {
            const { data, error } = await this.supabase
                .from('leaderboard')
                .select('*')
                .order('player_score', { ascending: false })
                .order('created_at', { ascending: false })
                .limit(limit);

            if (error) {
                console.error('Error fetching leaderboard:', error);
                return [];
            }

            return data || [];
        } catch (error) {
            console.error('Error fetching leaderboard:', error);
            return [];
        }
    }

    async getTopScores(limit = 5) {
        if (!this.isConnected || !this.supabase) {
            return [];
        }

        try {
            const { data, error } = await this.supabase
                .from('leaderboard')
                .select('player_name, player_score, opponent_score, created_at')
                .order('player_score', { ascending: false })
                .limit(limit);

            if (error) {
                console.error('Error fetching top scores:', error);
                return [];
            }

            return data || [];
        } catch (error) {
            console.error('Error fetching top scores:', error);
            return [];
        }
    }
}