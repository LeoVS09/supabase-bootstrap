
-- Additional profile data
create table if not exists public.profiles (
  id uuid references auth.users not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone,
  username text unique not null,
  avatar_url text,

  primary key (id),
  constraint username_length check (char_length(username) >= 5)
);

comment on table public.profiles is 'Profile data for each user.';

alter table public.profiles enable row level security;

drop policy if exists "Users can view their own profile." on profiles;

create policy "Users can view their own profile."
  on profiles for select
  using ( auth.uid() = id );

drop policy if exists "Users can insert their own profile." on profiles;

create policy "Users can insert their own profile."
  on profiles for insert
  with check ( auth.uid() = id );

drop policy if exists "Users can update own profile." on profiles;

create policy "Users can update own profile."
  on profiles for update
  using ( auth.uid() = id );

-- Insert profile on user creation
create or replace function public.add_new_profile() 
  returns trigger 
  language plpgsql 
  security definer set search_path = public as $$
  begin
    insert into public.profiles (id, username)
    values (new.id, new.email);
    return new;
  end; $$;

drop trigger if exists on_auth_user_created_add_profile on auth.users;

-- trigger the function every time a user is created
create trigger on_auth_user_created_add_profile
  after insert on auth.users
  for each row execute procedure public.add_new_profile();

-- Set up Storage!
insert into storage.buckets (id, name)
values ('avatars', 'avatars')
on conflict do nothing;

drop policy if exists "Avatar images are publicly accessible." on storage.objects;

create policy "Avatar images are publicly accessible."
  on storage.objects for select
  using ( bucket_id = 'avatars' );

drop policy if exists "Anyone can upload an avatar." on storage.objects;

create policy "Anyone can upload an avatar."
  on storage.objects for insert
  with check ( bucket_id = 'avatars' );

drop policy if exists "Anyone can update an avatar." on storage.objects;

create policy "Anyone can update an avatar."
  on storage.objects for update
  with check ( bucket_id = 'avatars' );