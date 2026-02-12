# Planned Features (Frontend-First)

This file describes the main features to build. For now, only the **frontend** will be deployed; the backend/Supabase wiring can be enabled later.

## 1. Authentication (Email + Password)

- User sign up with email and password.
- User sign in with email and password.
- Sign out button and basic error handling.
- Support for two roles via metadata: `patient` and `doctor`.

## 2. User Profiles

- Profile view showing:
  - First name, last name.
  - Email and user type (`patient` / `doctor`).
- Editable profile form (name, phone, specialization, bio) with client-side validation.

## 3. Appointments

- List of upcoming and past appointments.
- Create appointment form (title, description, date/time, duration, doctor/patient selection).
- Appointment detail page with notes.
- Status badges (`scheduled`, `completed`, `cancelled`) and filters.

## 4. Transcriptions

- For each appointment, a section for:
  - Audio upload placeholder (frontend-only for now).
  - Transcription text viewer.
- Loading/empty states for when no transcription is available yet.

## 5. Extracted Entities

- Under each transcription:
  - List of extracted entities (frontend mock data initially).
  - Show entity text, type, confidence score.
  - Optional highlighting of entities inside the transcription text.

## 6. Dashboards & UX

- Patient dashboard:
  - Next appointments, recent transcriptions and entities.
- Doctor dashboard:
  - Today’s schedule, recent patient interactions.
- Consistent, responsive UI using existing shadcn/ui components (tables, tabs, cards, skeletons).

## 7. Frontend-Only Deployment Notes

- All data-driven screens can initially use:
  - Mock JSON data, or
  - Static props/client-side state.
- When ready, replace mocks with live Supabase queries using the existing schema and auth.

