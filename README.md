# Sonic Gifts Database

This repository contains the database schema and migrations for the Sonic Gifts project.

## Table Structure

The main table `custom_songs_orders` has the following structure:

- `id`: UUID (Primary Key)
- `recipient_name`: Text (Required)
- `occasion`: Text (Required)
- `music_style`: Text (Required)
- `mood`: Text (Required)
- `vocalist_gender`: Text (Required) - Options: male, female, any
- `delivery_speed`: Text (Required) - Options: standard, express, rush
- `lyric_details`: Text (Required)
- `email`: Text (Required)
- `selected_package`: Text (Required) - Options: basic, premium, deluxe
- `created_at`: Timestamp with timezone (Default: UTC NOW)
- `status`: Text (Default: 'pending') - Options: pending, processing, completed, cancelled

## Features

- Row Level Security (RLS) enabled
- Indexes on email and status fields
- Trigger for handling new orders
- Constraints on vocalist_gender, delivery_speed, selected_package, and status

## Setup

1. Clone this repository
2. Install Supabase CLI
3. Link to your Supabase project:
   ```bash
   supabase link --project-ref mcp-helper-db
   ```
4. Apply migrations:
   ```bash
   supabase db push
   ```

## Development

To make changes to the schema:

1. Create a new migration file in `supabase/migrations/`
2. Test locally using `supabase start`
3. Apply changes using `supabase db push`

## Security

- RLS policies are in place to control access
- Only authenticated users can read their own orders
- Anyone can insert new orders
- Trigger functions run with SECURITY DEFINER