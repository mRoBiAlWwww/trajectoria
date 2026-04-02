# Updated ERD - Trajectoria (Firestore Collections)

> **Arsitektur:** Flutter Mobile App + Firebase (Firestore NoSQL)
> **Last Updated:** 2 April 2026
> **Status Legend:** IMPLEMENTED = sudah ada di kode | PLANNED = belum diimplementasi

---

## Overview Relasi Antar Collection

```
AUTHENTICATION
  Unrole (temporary) ──delete──> Jobseekers / Companies

JOBSEEKERS ─────────────────────────────────────────────────────┐
  ├── competitions_onprogres[] ──ref──> Competitions             │
  ├── competitions_done[] ──ref──> Competitions                  │
  ├── bookmarks[] ──ref──> Competitions                          │
  ├── finished_module[] ──ref──> Modules                         │
  ├── finished_subchapter[] ──ref──> Subchapters                 │
  ├── finished_chapter[] ──ref──> Chapters                       │
  └── progres[].course_id ──ref──> Courses                       │
                                                                 │
COMPANIES ──────────────────────────────────────────────┐        │
  └── is_verified (diverifikasi admin)                  │        │
                                                        │        │
COMPETITIONS ◄──────────────────────────────────────────┘        │
  ├── company_id ──ref──> Companies                              │
  ├── category_id ──ref──> Categories                            │
  ├── guidebook[] (embedded FileItem)                            │
  └── rubrik[] (embedded RubrikItem)                             │
                                                                 │
COMPETITION_PARTICIPANTS ◄───────────────────────────────────────┘
  ├── competition_id ──ref──> Competitions
  └── user_id ──ref──> Jobseekers

SUBMISSIONS
  ├── competition_participants_id ──ref──> Competition_participants
  ├── competition_id ──ref──> Competitions
  ├── answer_file_url[] (embedded FileItem)
  └── ai_analyzed (embedded InsightAI)

ANNOUNCEMENTS
  ├── submissions_id ──ref──> Submissions
  ├── competition_id ──ref──> Competitions
  └── user_id ──ref──> Jobseekers

LEARNING HIERARCHY (Nested Subcollections):
  Courses
    └── Chapters (subcollection)
          └── Subchapters (subcollection)
                └── Modules (subcollection)
                      └── Quizzes (subcollection)

PLANNED (belum diimplementasi):
  Certificates
    ├── submission_id ──ref──> Submissions
    ├── competition_id ──ref──> Competitions
    └── user_id ──ref──> Jobseekers
```

---

## Collection Details

### 1. Jobseekers [IMPLEMENTED]

> Menyimpan data user dengan role Jobseeker/Peserta

| Field | Type | Required | Keterangan |
|-------|------|----------|------------|
| `user_id` | string | PK | Firebase UID, juga sebagai document ID |
| `email` | string | Ya | Email login |
| `name` | string | Ya | Nama lengkap |
| `role` | string | Ya | Selalu "Jobseeker" |
| `profileImage` | string | Ya | URL foto profil (Cloudinary) |
| `created_at` | timestamp | Ya | Waktu registrasi |
| `bio` | string | Tidak | Biodata singkat |
| `cv_file_path` | string | Tidak | URL file CV (Cloudinary) |
| `skill_summary` | string | Tidak | Ringkasan skill peserta |
| `experience_summary` | string | Tidak | Ringkasan pengalaman |
| `status_employment` | string | Tidak | "student" / "fresh_graduate" / "open_to_work" |
| `courses_score` | int | Ya | Akumulasi skor dari quiz, default 0 |
| `finished_module` | list\<string\> | Ya | Array module_id yang telah diselesaikan |
| `finished_subchapter` | list\<string\> | Ya | Array subchapter_id yang telah diselesaikan |
| `finished_chapter` | list\<string\> | Ya | Array chapter_id yang telah diselesaikan |
| `onprogres_chapter` | string | Tidak | chapter_id yang sedang dikerjakan |
| `competitions_onprogres` | list\<string\> | Ya | Array competition_id yang sedang diikuti |
| `competitions_done` | list\<string\> | Ya | Array competition_id yang sudah selesai |
| `bookmarks` | list\<string\> | Ya | Array competition_id yang di-bookmark |
| `progres` | list\<embedded\> | Ya | Tracking progress per course (lihat embedded object) |
| `token_notification` | string | Tidak | FCM token untuk push notification |
| `lastTokenUpdate` | timestamp | Tidak | Waktu terakhir update FCM token |

**Embedded Object: `progres[]`**
| Field | Type | Keterangan |
|-------|------|------------|
| `course_id` | string | Ref → Courses.course_id |
| `value_progres` | int | Persentase progress (0-100) |

**Catatan implementasi:** Field `skill_sumarry` dan `experience_sumarry` di kode mengandung typo (seharusnya `skill_summary` dan `experience_summary`). Perlu diperbaiki di kode.

---

### 2. Companies [IMPLEMENTED]

> Menyimpan data user dengan role Company/Perusahaan

| Field | Type | Required | Keterangan |
|-------|------|----------|------------|
| `user_id` | string | PK | Firebase UID, juga sebagai document ID |
| `email` | string | Ya | Email login perusahaan |
| `name` | string | Ya | Nama perusahaan |
| `role` | string | Ya | Selalu "Company" |
| `profileImage` | string | Ya | URL logo perusahaan (Cloudinary) |
| `created_at` | timestamp | Ya | Waktu registrasi |
| `company_description` | string | Tidak | Deskripsi perusahaan |
| `website_url` | string | Tidak | URL website perusahaan |
| `is_verified` | bool | Ya | Status verifikasi oleh admin, default false |

---

### 3. Unrole [IMPLEMENTED]

> Collection sementara untuk user yang sudah signup tapi belum memilih role. Dihapus setelah role dipilih.

| Field | Type | Required | Keterangan |
|-------|------|----------|------------|
| `user_id` | string | PK | Firebase UID |
| `email` | string | Ya | |
| `name` | string | Ya | |
| `role` | string | Ya | Selalu "Unrole" |
| `profileImage` | string | Tidak | |
| `created_at` | timestamp | Ya | |

---

### 4. Categories [IMPLEMENTED]

> Kategori kompetisi (misal: Data Science, UI/UX, Backend, dll)

| Field | Type | Required | Keterangan |
|-------|------|----------|------------|
| `category_id` | string | PK | Auto-generated |
| `category` | string | Ya | Nama kategori |
| `imageUrl` | string | Tidak | URL gambar kategori |

---

### 5. Competitions [IMPLEMENTED]

> Kompetisi yang dipublikasikan oleh perusahaan

| Field | Type | Required | Keterangan |
|-------|------|----------|------------|
| `competition_id` | string | PK | Auto-generated |
| `company_id` | string | FK | Ref → Companies.user_id |
| `company_name` | string | Ya | Denormalized dari Companies.name |
| `company_email` | string | Ya | Denormalized dari Companies.email |
| `company_profile_image` | string | Ya | Denormalized dari Companies.profileImage |
| `title` | string | Ya | Judul kompetisi |
| `description` | string | Ya | Deskripsi kompetisi |
| `problem_statement` | string | Ya | Pernyataan masalah yang harus diselesaikan |
| `deadline` | timestamp | Ya | Batas waktu pengumpulan |
| `reward_description` | string | Tidak | Deskripsi hadiah |
| `submission_type` | string | Ya | Tipe submission yang diterima |
| `status` | string | Ya | "Draft" / "Dirilis" / "Closed" |
| `category_id` | string | FK | Ref → Categories.category_id |
| `created_at` | timestamp | Ya | |
| `competition_image` | string | Tidak | URL gambar kompetisi (Cloudinary) |
| `guidebook` | list\<embedded\> | Tidak | Daftar file guidebook (lihat embedded) |
| `rubrik` | list\<embedded\> | Tidak | Kriteria penilaian (lihat embedded) |

**Embedded Object: `guidebook[]` (FileItem)**
| Field | Type | Keterangan |
|-------|------|------------|
| `fileName` | string | Nama file |
| `extension` | string | Ekstensi file (pdf, docx, dll) |
| `url` | string | URL file (Cloudinary) |

**Embedded Object: `rubrik[]` (RubrikItem)**
| Field | Type | Keterangan |
|-------|------|------------|
| `kriteria` | string | Nama kriteria penilaian |
| `bobot` | int | Bobot/weight penilaian |

**Catatan denormalisasi:** `company_name`, `company_email`, `company_profile_image` di-denormalisasi dari collection Companies. Ini by-design untuk Firestore agar mengurangi jumlah read operations. Tradeoff: jika company mengubah nama/email, data di Competitions tidak otomatis terupdate.

---

### 6. Draft_competitions [IMPLEMENTED]

> Kompetisi yang belum dipublikasikan (draft). Struktur identik dengan Competitions.

Struktur field sama persis dengan Competitions (lihat tabel di atas).

---

### 7. Competition_participants [IMPLEMENTED]

> Mencatat peserta yang mendaftar/join ke kompetisi

| Field | Type | Required | Keterangan |
|-------|------|----------|------------|
| `competition_participants_id` | string | PK | Auto-generated |
| `competition_id` | string | FK | Ref → Competitions.competition_id |
| `user_id` | string | FK | Ref → Jobseekers.user_id |
| `created_at` | timestamp | Ya | Waktu join |

---

### 8. Submissions [IMPLEMENTED]

> Jawaban/submission peserta untuk kompetisi

| Field | Type | Required | Keterangan |
|-------|------|----------|------------|
| `submissions_id` | string | PK | Auto-generated |
| `competition_participants_id` | string | FK | Ref → Competition_participants |
| `competition_id` | string | FK | Ref → Competitions.competition_id |
| `problem_statement` | string | Ya | Denormalized dari Competitions |
| `submitted_at` | timestamp | Ya | Waktu submit |
| `answer_text` | string | Tidak | Jawaban dalam bentuk teks |
| `answer_file_url` | list\<embedded\> | Tidak | Daftar file jawaban (FileItem) |
| `ai_analyzed` | embedded | Tidak | Hasil analisis AI (lihat embedded) |
| `feedback` | string | Tidak | Feedback manual dari company |
| `score` | double | Ya | Skor penilaian, default 0 |
| `rank` | int | Tidak | Peringkat peserta |
| `is_checked` | bool | Ya | Sudah dinilai oleh company? Default false |
| `is_finalist` | bool | Ya | Terpilih sebagai finalis? Default false |

**Embedded Object: `ai_analyzed` (InsightAI)**
| Field | Type | Keterangan |
|-------|------|------------|
| `common_pattern` | list\<string\> | Pola umum yang ditemukan dari analisis AI |
| `summary` | list\<string\> | Ringkasan analisis AI (5 poin) |

**Catatan:** Di desain awal, AI feedback adalah tabel terpisah (`ai_feedback`) dengan fields: strengths, weaknesses, improvement_suggestion, career_match_recommendation. Di implementasi, AI analysis di-embed sebagai object di dalam Submissions dengan scope yang lebih kecil (hanya summary & pattern). **Perkaya AI feedback = PLANNED untuk Phase 2.**

---

### 9. Announcements [IMPLEMENTED]

> Notifikasi dari company ke peserta (misal: submission sudah dinilai)

| Field | Type | Required | Keterangan |
|-------|------|----------|------------|
| `announcement_id` | string | PK | Auto-generated |
| `company_name` | string | Ya | Nama company pengirim |
| `competition_name` | string | Ya | Nama kompetisi terkait |
| `submissions_id` | string | FK | Ref → Submissions.submissions_id |
| `competition_id` | string | FK | Ref → Competitions.competition_id |
| `user_id` | string | FK | Ref → Jobseekers.user_id (penerima) |
| `created_announcement_at` | timestamp | Ya | Waktu dibuat |
| `is_read` | bool | Ya | Sudah dibaca? Default false |

---

### 10. Courses [IMPLEMENTED]

> Learning path / kursus untuk peserta

| Field | Type | Required | Keterangan |
|-------|------|----------|------------|
| `course_id` | string | PK | Auto-generated |
| `title` | string | Ya | Judul course |
| `description` | string | Ya | Deskripsi course |
| `level` | string | Ya | "beginner" / "intermediate" / "advance" |
| `created_at` | timestamp | Ya | |
| `has_collection` | bool | Ya | Apakah punya subcollection chapters |
| `order_index` | int | Ya | Urutan tampilan |

---

### 11. Chapters [IMPLEMENTED] (Subcollection dari Courses)

> Bab-bab di dalam course

**Firestore Path:** `Courses/{course_id}/course_chapters/{chapter_id}`

| Field | Type | Required | Keterangan |
|-------|------|----------|------------|
| `chapter_id` | string | PK | Auto-generated |
| `course_id` | string | FK | Ref → parent Course |
| `title` | string | Ya | Judul chapter |
| `description` | string | Ya | Deskripsi chapter |
| `duration` | string | Tidak | Estimasi durasi (misal: "2 jam") |
| `order_index` | int | Ya | Urutan tampilan |
| `maximum_score` | int | Ya | Skor maksimal chapter |
| `badge` | string | Tidak | Badge/achievement yang didapat |

---

### 12. Subchapters [IMPLEMENTED] (Subcollection dari Chapters)

> Sub-bab di dalam chapter

**Firestore Path:** `Courses/{course_id}/course_chapters/{chapter_id}/sub_chapters/{subchapter_id}`

| Field | Type | Required | Keterangan |
|-------|------|----------|------------|
| `subchapter_id` | string | PK | Auto-generated |
| `chapter_id` | string | FK | Ref → parent Chapter |
| `title` | string | Ya | |
| `description` | string | Ya | |
| `has_collection` | bool | Ya | Apakah punya subcollection modules |
| `order_index` | int | Ya | Urutan tampilan |

---

### 13. Modules [IMPLEMENTED] (Subcollection dari Subchapters)

> Modul pembelajaran berisi konten

**Firestore Path:** `Courses/{course_id}/course_chapters/{chapter_id}/sub_chapters/{subchapter_id}/modules/{module_id}`

| Field | Type | Required | Keterangan |
|-------|------|----------|------------|
| `module_id` | string | PK | Auto-generated |
| `subchapter_id` | string | FK | Ref → parent Subchapter |
| `course_id` | string | FK | Ref → root Course |
| `chapter_id` | string | FK | Ref → parent Chapter |
| `title` | string | Ya | |
| `content` | string | Ya | Konten HTML/rich text |
| `order_index` | int | Ya | Urutan tampilan |
| `maximum_score` | int | Ya | Skor maksimal modul |

---

### 14. Quizzes [IMPLEMENTED] (Subcollection dari Modules)

> Soal quiz per modul (pilihan ganda, 4 opsi)

**Firestore Path:** `Courses/.../modules/{module_id}/quizzes/{quiz_id}`

| Field | Type | Required | Keterangan |
|-------|------|----------|------------|
| `quiz_id` | string | PK | Auto-generated |
| `module_id` | string | FK | Ref → parent Module |
| `question_text` | string | Ya | Pertanyaan |
| `option_0` | string | Ya | Opsi A |
| `option_1` | string | Ya | Opsi B |
| `option_2` | string | Ya | Opsi C |
| `option_3` | string | Ya | Opsi D |
| `correct_answer` | int | Ya | Index jawaban benar (0-3) |

**Catatan:** Di desain awal field opsi bernama `option_a` s/d `option_d` dan `correct_answer` bertipe varchar ("A"/"B"/"C"/"D"). Di implementasi menggunakan index numerik (0-3) yang lebih efisien.

---

### 15. Certificates [PLANNED - Belum Diimplementasi]

> Sertifikat untuk peserta Top 10 dalam kompetisi

| Field | Type | Required | Keterangan |
|-------|------|----------|------------|
| `certificate_id` | string | PK | Auto-generated |
| `submission_id` | string | FK | Ref → Submissions |
| `competition_id` | string | FK | Ref → Competitions |
| `user_id` | string | FK | Ref → Jobseekers |
| `position` | int | Ya | Peringkat (1-10) |
| `certificate_url` | string | Ya | URL file sertifikat (PDF/Image) |
| `issued_at` | timestamp | Ya | Tanggal diterbitkan |

---

## Perbedaan Kunci: Desain Lama vs Desain Baru

| Aspek | Desain Lama (SQL) | Desain Baru (Firestore) |
|-------|-------------------|-------------------------|
| Users | 1 tabel `users` dengan kolom role | 3 collection terpisah: Jobseekers, Companies, Unrole |
| AI Feedback | Tabel terpisah `ai_feedback` | Embedded object `ai_analyzed` di Submissions |
| Quiz Attempts | Tabel terpisah `quiz_attempts` | Progress tracking via array fields di Jobseekers |
| Learning | 3-level: courses → modules → quizzes | 5-level: courses → chapters → subchapters → modules → quizzes |
| Competition | Tidak ada draft, kategori, rubrik | Ada Draft_competitions, Categories, embedded rubrik & guidebook |
| Notifications | Tidak ada | Collection Announcements + FCM push notification |
| Bookmarks | Tidak ada | Array field `bookmarks` di Jobseekers |
| File Storage | Dedicated storage | Cloudinary (external service) |
| Denormalisasi | Minimal (relational) | Extensive (company info di Competitions, problem_statement di Submissions) |

---

## External Services (bukan Firestore)

| Service | Fungsi | Collection Terkait |
|---------|--------|--------------------|
| Firebase Auth | Autentikasi (email/password + Google OAuth) | Jobseekers, Companies, Unrole |
| Cloudinary | Upload & hosting file (gambar, CV, PDF) | Semua field bertipe URL |
| Google Gemini AI | Analisis submission peserta | Submissions.ai_analyzed |
| Firebase Cloud Messaging | Push notification ke device | Jobseekers.token_notification |
