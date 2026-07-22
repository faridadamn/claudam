-- Nemenin Fokus — Supabase schema
-- Jalankan di Supabase SQL Editor (Project > SQL Editor > New query)

create extension if not exists "pgcrypto";

-- Ruang fokus (room)
create table if not exists rooms (
  id uuid primary key default gen_random_uuid(),
  code text unique not null,               -- kode 6 karakter buat join, mis. "AB12CD"
  name text not null default 'Ruang Fokus',
  session_minutes int not null default 25,
  break_minutes int not null default 5,
  created_at timestamptz not null default now()
);

-- Anggota ruang (guest identity disimpan di localStorage browser, bukan auth penuh)
create table if not exists room_members (
  id uuid primary key default gen_random_uuid(),
  room_id uuid not null references rooms(id) on delete cascade,
  guest_id text not null,                  -- id acak yang dibuat browser, disimpan di localStorage
  display_name text not null,
  is_focusing boolean not null default false,
  streak_days int not null default 0,
  last_seen timestamptz not null default now(),
  joined_at timestamptz not null default now(),
  unique (room_id, guest_id)
);

-- Task pribadi (boleh terkait room atau berdiri sendiri)
create table if not exists tasks (
  id uuid primary key default gen_random_uuid(),
  room_id uuid references rooms(id) on delete cascade,
  guest_id text not null,
  title text not null,
  done boolean not null default false,
  created_at timestamptz not null default now()
);

-- Riwayat sesi fokus (buat streak & leaderboard)
create table if not exists focus_sessions (
  id uuid primary key default gen_random_uuid(),
  room_id uuid references rooms(id) on delete cascade,
  guest_id text not null,
  display_name text not null,
  started_at timestamptz not null default now(),
  ended_at timestamptz,
  duration_min int
);

-- Row Level Security: dibuka publik dulu untuk MVP (guest mode, tanpa login)
-- Catatan: cukup aman untuk MVP karena tidak ada data sensitif,
-- tapi sebaiknya diperketat kalau sudah ada akun asli.
alter table rooms enable row level security;
alter table room_members enable row level security;
alter table tasks enable row level security;
alter table focus_sessions enable row level security;

create policy "public read rooms" on rooms for select using (true);
create policy "public insert rooms" on rooms for insert with check (true);

create policy "public all room_members" on room_members for all using (true) with check (true);
create policy "public all tasks" on tasks for all using (true) with check (true);
create policy "public all focus_sessions" on focus_sessions for all using (true) with check (true);

-- Aktifkan realtime buat tabel yang perlu sync live
alter publication supabase_realtime add table room_members;
alter publication supabase_realtime add table focus_sessions;
