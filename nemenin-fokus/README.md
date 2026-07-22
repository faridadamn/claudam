# Nemenin Fokus — MVP

Web app fokus bareng: buat/join "ruang fokus", timer Pomodoro tersinkron,
lihat siapa lagi yang lagi fokus (meja fokus + presence), task list pribadi
per ruang. Nggak pakai login — identitas disimpan sebagai guest ID di
localStorage browser.

## Cara jalanin (5 menit)

1. **Bikin project Supabase** di https://supabase.com (gratis).
2. Buka **SQL Editor** di dashboard project, paste isi `schema.sql`, run.
3. Buka **Project Settings > API**, salin `Project URL` dan `anon public key`.
4. Buka `index.html`, isi dua baris ini di bagian atas `<script>`:
   ```js
   const SUPABASE_URL = "https://xxxxx.supabase.co";
   const SUPABASE_ANON_KEY = "eyJhbGciOi...";
   ```
5. Buka `index.html` langsung di browser (double-click) — udah jalan,
   nggak perlu build step atau server.

## Struktur

- `index.html` — seluruh app (UI + logic + Supabase client), single file.
- `schema.sql` — tabel Supabase: `rooms`, `room_members`, `tasks`, `focus_sessions`.

## Yang sudah ada di MVP ini

- Buat ruang fokus / gabung pakai kode 6 karakter
- Timer Pomodoro (default 25/5 menit, bisa diubah lewat kolom `session_minutes`
  / `break_minutes` di tabel `rooms`)
- "Meja Fokus" — visual siapa aja yang lagi fokus real-time (Supabase Realtime)
- Task list pribadi per ruang

## Belum ada — kandidat iterasi berikutnya

- Leaderboard & streak harian (tabel `focus_sessions` & kolom `streak_days`
  sudah disiapkan di schema, tinggal dipakai)
- Share kode ruang otomatis ke WhatsApp
- Ubah durasi sesi dari UI (sekarang harus lewat Supabase dashboard)
- Auth asli (sekarang guest-only lewat localStorage — cukup buat validasi awal)

## Push ke GitHub

Kalau mau aku push langsung ke `faridadamn/claudam`, kirim Personal Access
Token yang **baru** (yang tadi kekirim di chat udah aku minta di-revoke).
Buat token fine-grained dengan scope `repo` → `contents: read & write`
khusus repo `claudam`.
