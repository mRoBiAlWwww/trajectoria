# Gap Resolution Summary - Trajectoria

> **Last Updated:** 2 April 2026
> Dokumen ini merangkum semua gap yang ditemukan antara desain sistem awal dan implementasi aktual, beserta resolusinya.

---

## 1. Gap Arsitektur

### Deskripsi
Desain awal mengasumsikan arsitektur web (REST API backend + web frontend + SQL database). Implementasi aktual menggunakan Flutter mobile app + Firebase (Firestore NoSQL).

### Resolusi
| Aspek | Desain Lama | Desain Baru (Actual) |
|-------|-------------|----------------------|
| Frontend | Web App (HTML/JS) | Flutter Mobile App (Dart) |
| Backend | REST API terpisah (Node.js/Express-style) | Firebase SDK langsung dari client |
| Database | SQL relational (PostgreSQL-style) | Cloud Firestore (NoSQL document) |
| Authentication | JWT token via POST /login | Firebase Auth (email/password + Google OAuth) |
| File Storage | Dedicated file server | Cloudinary (external CDN) |
| AI Engine | Microservice terpisah | Google Gemini API langsung dari client |
| Push Notification | Tidak ada di desain | Firebase Cloud Messaging (FCM) |
| State Management | Tidak ada di desain | BLoC/Cubit pattern (Flutter) |

**Status:** Semua dokumen desain sudah diupdate ke arsitektur Flutter + Firebase.

---

## 2. Gap Database Schema

### 2.1 Users Table → Split Collections

| Desain Lama | Desain Baru | Alasan |
|-------------|-------------|--------|
| 1 tabel `users` dengan kolom `role` | 3 collection: `Jobseekers`, `Companies`, `Unrole` | Firestore tidak punya relational joins. Memisahkan per-role mengurangi document size dan memudahkan query per-role. |

**Implikasi:**
- Field yang di desain lama ada di 1 tabel (bio, cv, skill_summary, company_description, website_url, is_verified) sekarang terdistribusi di collection masing-masing
- Tidak perlu kolom `role` untuk filter — sudah terpisah secara collection
- Kolom khusus peserta (courses_score, finished_module, bookmarks, dll) hanya ada di Jobseekers
- Kolom khusus company (company_description, website_url, is_verified) hanya ada di Companies

### 2.2 AI Feedback: Tabel Terpisah → Embedded Object

| Desain Lama | Desain Baru | Alasan |
|-------------|-------------|--------|
| Tabel `ai_feedback` terpisah dengan FK ke `submissions` | Embedded object `ai_analyzed` di dalam Submissions | Mengurangi jumlah read operations di Firestore. AI analysis selalu diakses bersamaan dengan submission-nya. |

**Gap yang belum teratasi:**
| Field di Desain Lama | Ada di Implementasi? | Status |
|---------------------|---------------------|--------|
| strengths_notes | Tidak → hanya `summary[]` | PLANNED |
| weaknesses_notes | Tidak → hanya `common_pattern[]` | PLANNED |
| improvement_suggestion | Tidak | PLANNED |
| career_match_recommendation | Tidak | PLANNED |

**Rekomendasi Phase 2:** Perkaya embedded `ai_analyzed` menjadi:
```
ai_analyzed: {
  common_pattern: string[],    // existing
  summary: string[],           // existing
  strengths: string[],         // baru
  weaknesses: string[],        // baru
  improvement_suggestion: string, // baru
  career_match_recommendation: string  // baru
}
```

### 2.3 Learning Structure: 3-level → 5-level

| Desain Lama | Desain Baru |
|-------------|-------------|
| courses → courses_modules → quizzes | courses → chapters → subchapters → modules → quizzes |

**Alasan:** Implementasi lebih granular untuk pengalaman belajar yang lebih terstruktur. Hierarchy 5-level memungkinkan:
- Course = learning path keseluruhan
- Chapter = topik besar (ada badge & skor)
- Subchapter = sub-topik
- Module = unit konten (HTML content)
- Quiz = assessment per module

### 2.4 Quiz Attempts: Tabel Terpisah → Array Fields

| Desain Lama | Desain Baru | Alasan |
|-------------|-------------|--------|
| Tabel `quiz_attempts` (attempt_id, user_id, module_id, score, ai_feedback_text, completed_at) | Array fields di Jobseekers: `finished_module`, `courses_score` (aggregate) | Simplifikasi. Tidak perlu track per-attempt karena quiz bisa diulang dan yang disimpan hanya progress akhir. |

**Tradeoff:** Tidak bisa melihat history attempt quiz. Untuk MVP ini cukup, tapi jika butuh analytics per-attempt, perlu tambah collection `Quiz_attempts` di Phase 2.

### 2.5 Collection Baru (Tidak Ada di Desain Lama)

| Collection | Fungsi | Status |
|-----------|--------|--------|
| `Draft_competitions` | Simpan kompetisi draft sebelum publish | IMPLEMENTED |
| `Categories` | Kategori kompetisi (Data Science, UI/UX, dll) | IMPLEMENTED |
| `Announcements` | Notifikasi dari company ke peserta | IMPLEMENTED |
| `Unrole` | Temporary collection untuk user yang belum pilih role | IMPLEMENTED |

### 2.6 Collection yang Ada di Desain Lama Tapi Belum Diimplementasi

| Collection | Status | Catatan |
|-----------|--------|---------|
| `certificates` | PLANNED | Perlu generate PDF, auto-assign ke Top 10 |

### 2.7 Field-Level Differences

| Collection | Field | Desain Lama | Implementasi |
|-----------|-------|-------------|--------------|
| Competitions | category_id | Tidak ada | Ada — referensi ke Categories |
| Competitions | competition_image | Tidak ada | Ada — URL gambar kompetisi |
| Competitions | guidebook[] | Tidak ada | Ada — embedded file list |
| Competitions | rubrik[] | Tidak ada | Ada — embedded kriteria penilaian |
| Competitions | company_name, email, image | Tidak ada (hanya company_id FK) | Ada — denormalized untuk Firestore |
| Submissions | is_checked | Tidak ada | Ada — flag sudah dinilai |
| Submissions | is_finalist | Tidak ada | Ada — flag finalis |
| Submissions | answer_file_url | varchar (single) | list\<embedded\> (multiple files) |
| Quizzes | correct_answer | varchar "A"/"B"/"C"/"D" | int 0-3 |
| Quizzes | option fields | option_a s/d option_d | option_0 s/d option_3 |

---

## 3. Gap Sequence Diagrams

### Perubahan Prinsip
| Aspek | Desain Lama | Desain Baru |
|-------|-------------|-------------|
| Aktor Backend | "Backend API" | Tidak ada — Firebase SDK langsung |
| Database Queries | SQL (SELECT, INSERT, UPDATE) | Firestore (get, add, update, where, orderBy) |
| Auth Flow | POST /login → JWT token | Firebase Auth SDK → UserCredential |
| File Upload | POST ke backend | Cloudinary SDK langsung |
| AI Analysis | Backend → AI Engine | Flutter App → Gemini AI API |
| Notifications | Tidak ada | FCM push + Announcements collection |

### Status Per Diagram
| SD | Deskripsi | Perubahan |
|----|-----------|-----------|
| SD-1 | Peserta Login/Submit/AI | REST calls → Firebase SDK + Cloudinary + Gemini |
| SD-2 | Result + Sertifikat | PLANNED — tetap sebagai future design |
| SD-3 | Company Buat Kompetisi | REST calls → Firestore + Cloudinary. Tambah draft flow |
| SD-4 | Company Lihat Kandidat | REST calls → Firestore. Tambah finalis flow + FCM notification |
| SD-5 | Admin Verifikasi | PLANNED — field is_verified ada, UI belum |
| SD-6 | Admin Manage Course | PLANNED — subcollection structure ada, CRUD UI belum |
| SD-7 | Peserta Profile | REST calls → Firebase Auth + Firestore + Cloudinary. Tambah bookmarks, notifications, riwayat |
| SD-8 | Peserta Course/Quiz | REST calls → Firestore nested subcollections. Quiz scoring langsung ke Jobseeker doc |
| SD-9 | Company Profile | REST calls → Firebase Auth + Firestore + Cloudinary |
| SD-10 | Admin Monitoring | PLANNED |
| SD-11 | Admin Logout | PLANNED |

---

## 4. Gap User Stories

### Stories Baru yang Ditambahkan
Total **11 user stories baru** dari implementasi yang tidak ada di desain awal:

**Peserta (7 baru):**
- P-10: Login via Google
- P-11: Bookmark kompetisi
- P-12: Riwayat kompetisi
- P-13: Push notification saat dinilai
- P-14: Leaderboard global
- P-15: Edit profil (bio, CV, skill)
- P-16: Change password

**Perusahaan (9 baru):**
- C-7: Draft kompetisi
- C-8: Rubrik penilaian
- C-9: Upload guidebook
- C-10: Pilih finalis
- C-11: Kirim notifikasi ke peserta
- C-12: AI analysis submission
- C-13: Edit profil company
- C-14: Change password
- C-15: Dashboard semua submissions

### Stories yang Di-downgrade ke PLANNED
- P-7: Download sertifikat Top 10
- P-8: Persiapan kerja
- C-6: Export data kandidat
- AI-2: Rekomendasi skill
- AI-3: Career match
- A-1 s/d A-8: Semua fitur admin

---

## 5. Issues & Rekomendasi

### 5.1 Security Concerns (Harus Diperbaiki)

| Issue | Severity | Rekomendasi |
|-------|----------|-------------|
| Firebase Service Account private key di client `.env` | **CRITICAL** | Pindahkan ke Cloud Functions. SA key TIDAK BOLEH ada di mobile app. |
| Gemini API key di client `.env` | **HIGH** | Buat Cloud Function sebagai proxy untuk Gemini API calls. |
| Firestore Security Rules tidak teraudit | **HIGH** | Buat rules yang ketat: user hanya bisa read/write data miliknya sendiri. Company hanya bisa manage kompetisi miliknya. |
| Verifikasi is_verified tidak di-enforce | **MEDIUM** | Tambahkan Firestore Security Rule: hanya company dengan is_verified=true yang bisa write ke Competitions. |

### 5.2 Data Consistency Issues

| Issue | Severity | Rekomendasi |
|-------|----------|-------------|
| Typo field: `skill_sumarry`, `experience_sumarry` | **LOW** | Fix di kode + migrasi data existing. ERD baru sudah menggunakan nama yang benar. |
| Denormalized company data di Competitions | **MEDIUM** | Dokumentasikan bahwa jika company update nama/email, Competitions lama tidak terupdate. Pertimbangkan Cloud Function trigger untuk sync. |
| Denormalized problem_statement di Submissions | **LOW** | Acceptable untuk Firestore. Mengurangi read operations. |

### 5.3 Feature Completeness Roadmap

```
PHASE 1 (CURRENT - Implemented):
  [x] Authentication (email + Google)
  [x] Kompetisi CRUD (create, draft, publish, browse, join, submit)
  [x] AI Analysis (summary + pattern)
  [x] Learning System (courses → chapters → modules → quizzes)
  [x] Push Notifications
  [x] Leaderboard
  [x] Profile Management (peserta + company)
  [x] Bookmark & Riwayat

PHASE 2 (Next Priority):
  [ ] Perkaya AI Feedback (strengths, weaknesses, career match)
  [ ] Sertifikat Top 10 (generate + download)
  [ ] Export data kandidat (CSV/PDF)
  [ ] Pindahkan secrets ke Cloud Functions
  [ ] Firestore Security Rules audit

PHASE 3 (Medium Priority):
  [ ] Admin Dashboard (verifikasi company)
  [ ] Admin CRUD Course/Module/Quiz
  [ ] AI Rekomendasi Skill
  [ ] Career Readiness Feature

PHASE 4 (Low Priority):
  [ ] Admin Monitoring Dashboard
  [ ] Admin User Management
  [ ] Quiz Attempts History
  [ ] Analytics & Reporting
```

---

## Daftar Dokumen Terkait

| Dokumen | File | Keterangan |
|---------|------|------------|
| Updated ERD | `docs/01_updated_erd.md` | Schema Firestore collections lengkap |
| Updated Sequence Diagrams | `docs/02_updated_sequence_diagrams.md` | 11 sequence diagrams (Firebase SDK pattern) |
| Updated User Stories | `docs/03_updated_user_stories.md` | 42 user stories dengan status |
| Gap Resolution Summary | `docs/04_gap_resolution_summary.md` | Dokumen ini |
