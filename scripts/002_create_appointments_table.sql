-- Create appointments table
create table if not exists public.appointments (
  id uuid primary key default gen_random_uuid(),
  patient_id uuid not null references public.profiles(id) on delete cascade,
  doctor_id uuid not null references public.profiles(id) on delete cascade,
  title text not null,
  description text,
  scheduled_at timestamp with time zone not null,
  duration_minutes integer default 30,
  status text default 'scheduled' check (status in ('scheduled', 'completed', 'cancelled')),
  notes text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

create index if not exists appointments_patient_id_idx on public.appointments(patient_id);
create index if not exists appointments_doctor_id_idx on public.appointments(doctor_id);
create index if not exists appointments_scheduled_at_idx on public.appointments(scheduled_at);

alter table public.appointments enable row level security;

-- Patients can view and manage their own appointments
create policy "appointments_select_own" on public.appointments for select using (
  auth.uid() = patient_id
);
create policy "appointments_insert_own" on public.appointments for insert with check (
  auth.uid() = patient_id
);
create policy "appointments_update_own" on public.appointments for update using (
  auth.uid() = patient_id
);

-- Doctors can view and update their own appointments
create policy "appointments_select_for_doctor" on public.appointments for select using (
  auth.uid() = doctor_id
);
create policy "appointments_update_for_doctor" on public.appointments for update using (
  auth.uid() = doctor_id
);
