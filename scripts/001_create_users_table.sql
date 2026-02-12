-- Create profiles table for user information
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  user_type text not null check (user_type in ('patient', 'doctor')),
  first_name text not null,
  last_name text not null,
  email text not null,
  phone text,
  specialization text,
  bio text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

alter table public.profiles enable row level security;

-- RLS Policies: Users can view and update their own profile
create policy "profiles_select_own" on public.profiles for select using (auth.uid() = id);
create policy "profiles_update_own" on public.profiles for update using (auth.uid() = id);

-- Only allow inserts via trigger
create policy "profiles_insert_disabled" on public.profiles for insert with check (false);
