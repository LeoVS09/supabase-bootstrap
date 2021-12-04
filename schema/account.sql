
-- Accounts
create table if not exists accounts  (
  id uuid default uuid_generate_v4() primary key,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone,

  name text,
  constraint name_length check (char_length(name) >= 5 and char_length(name) <= 255)
);

comment on table accounts is 'Multi-tenant company or organisation account';

alter table accounts enable row level security;

create table if not exists account_users (
  user_id uuid references auth.users not null,
  account_id uuid references accounts not null,

  primary key (user_id, account_id)
);

comment on table account_users is 'User and account linking';

alter table account_users enable row level security;

-- Insert account on user creation if not exists
-- And assign it to user
create or replace function add_new_account_or_assign_existing() 
  returns trigger 
  language plpgsql 
  security definer set search_path = public as $$
  DECLARE
   new_account_id uuid := null;
  begin

    if new.raw_user_meta_data ->> 'account_id' = null then
      insert into accounts (name) values (new.email) returning id into new_account_id;
      insert into account_users (user_id, account_id) values (new.id, new_account_id);
      return new;

    else 
      insert into account_users (user_id, account_id) values (new.id, new.raw_user_meta_data ->> 'account_id');
      return new;

    end if;
  end; $$;

drop trigger if exists on_auth_user_created_add_account on auth.users;

-- trigger the function every time a user is created
create trigger on_auth_user_created_add_account
  after insert on auth.users
  for each row execute procedure add_new_account_or_assign_existing();

-- Polices

drop policy if exists "Users can view their own account." on accounts;

create policy "Users can view their own account." 
on accounts for select using (
    (
        select au.account_id = id
        from account_users au
        where au.user_id = auth.uid()
    )
);

drop policy if exists "Users can insert their own account." on accounts;
create policy "Users can insert their own account."
  on accounts for insert with check ( 
    (
        select au.account_id = id
        from account_users au
        where au.user_id = auth.uid()
    )
);

drop policy if exists "Users can update own account." on accounts;
create policy "Users can update own account."
  on accounts for update using ( 
    (
        select au.account_id = id
        from account_users au
        where au.user_id = auth.uid()
    )
);

create policy "Users can view their own account users."
  on account_users for select
  using ( auth.uid() = user_id );

create policy "Users can insert their own account users."
  on account_users for insert
  with check ( auth.uid() = user_id );

create policy "Users can update own account users."
  on account_users for update
  using ( auth.uid() = user_id );