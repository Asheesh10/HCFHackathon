-- Create extracted entities table
create table if not exists public.extracted_entities (
  id uuid primary key default gen_random_uuid(),
  transcription_id uuid not null references public.transcriptions(id) on delete cascade,
  entity_text text not null,
  entity_type text not null,
  start_position integer,
  end_position integer,
  confidence float,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

create index if not exists entities_transcription_id_idx on public.extracted_entities(transcription_id);
create index if not exists entities_type_idx on public.extracted_entities(entity_type);

alter table public.extracted_entities enable row level security;

-- Users can view entities for their own appointments
create policy "entities_select" on public.extracted_entities for select using (
  exists (
    select 1 from public.transcriptions t
    join public.appointments a on a.id = t.appointment_id
    where t.id = transcription_id and (a.patient_id = auth.uid() or a.doctor_id = auth.uid())
  )
);
