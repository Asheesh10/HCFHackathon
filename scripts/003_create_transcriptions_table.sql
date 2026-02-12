-- Create transcriptions table
create table if not exists public.transcriptions (
  id uuid primary key default gen_random_uuid(),
  appointment_id uuid not null references public.appointments(id) on delete cascade,
  audio_file_path text not null,
  transcription_text text,
  status text default 'pending' check (status in ('pending', 'processing', 'completed', 'failed')),
  error_message text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

create index if not exists transcriptions_appointment_id_idx on public.transcriptions(appointment_id);
create index if not exists transcriptions_status_idx on public.transcriptions(status);

alter table public.transcriptions enable row level security;

-- Users can view transcriptions for their own appointments
create policy "transcriptions_select" on public.transcriptions for select using (
  exists (
    select 1 from public.appointments
    where appointments.id = appointment_id and (appointments.patient_id = auth.uid() or appointments.doctor_id = auth.uid())
  )
);

create policy "transcriptions_insert" on public.transcriptions for insert with check (
  exists (
    select 1 from public.appointments
    where appointments.id = appointment_id and appointments.patient_id = auth.uid()
  )
);
