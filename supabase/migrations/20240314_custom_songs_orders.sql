-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create custom_songs_orders table
CREATE TABLE IF NOT EXISTS public.custom_songs_orders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    recipient_name TEXT NOT NULL,
    occasion TEXT NOT NULL,
    music_style TEXT NOT NULL,
    mood TEXT NOT NULL,
    vocalist_gender TEXT NOT NULL,
    delivery_speed TEXT NOT NULL,
    lyric_details TEXT NOT NULL,
    email TEXT NOT NULL,
    selected_package TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
    status TEXT DEFAULT 'pending' NOT NULL,
    
    -- Add constraints
    CONSTRAINT chk_vocalist_gender CHECK (vocalist_gender IN ('male', 'female', 'any')),
    CONSTRAINT chk_delivery_speed CHECK (delivery_speed IN ('standard', 'express', 'rush')),
    CONSTRAINT chk_selected_package CHECK (selected_package IN ('basic', 'premium', 'deluxe')),
    CONSTRAINT chk_status CHECK (status IN ('pending', 'processing', 'completed', 'cancelled'))
);

-- Create index on email for faster lookups
CREATE INDEX IF NOT EXISTS idx_custom_songs_orders_email ON public.custom_songs_orders(email);

-- Create index on status for filtering
CREATE INDEX IF NOT EXISTS idx_custom_songs_orders_status ON public.custom_songs_orders(status);

-- Enable Row Level Security (RLS)
ALTER TABLE public.custom_songs_orders ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Enable read access for authenticated users" ON public.custom_songs_orders
    FOR SELECT
    TO authenticated
    USING (auth.uid() IS NOT NULL);

CREATE POLICY "Enable insert access for all users" ON public.custom_songs_orders
    FOR INSERT
    TO anon, authenticated
    WITH CHECK (true);

-- Create function to handle new orders
CREATE OR REPLACE FUNCTION handle_new_order()
RETURNS TRIGGER AS $$
BEGIN
    -- You can add any additional processing logic here
    -- For example, sending notifications, updating statistics, etc.
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger for new orders
CREATE TRIGGER on_order_created
    AFTER INSERT ON public.custom_songs_orders
    FOR EACH ROW
    EXECUTE FUNCTION handle_new_order();