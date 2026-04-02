# Updated Sequence Diagrams - Trajectoria

> **Arsitektur:** Flutter App ↔ Firebase SDK ↔ Firestore / Firebase Auth / Cloudinary / Gemini AI / FCM
> **Last Updated:** 2 April 2026
> **Catatan:** Semua interaksi menggunakan Firebase SDK dari Flutter client, BUKAN REST API.

---

## Daftar Aktor

| Aktor | Keterangan |
|-------|------------|
| **Peserta** | User dengan role Jobseeker |
| **Perusahaan** | User dengan role Company |
| **Admin** | [PLANNED] Belum diimplementasi di app |
| **Flutter App** | Aplikasi mobile Flutter (client) |
| **Firebase Auth** | Firebase Authentication service |
| **Firestore** | Cloud Firestore database |
| **Cloudinary** | File upload & hosting service |
| **Gemini AI** | Google Generative AI (analisis submission) |
| **FCM** | Firebase Cloud Messaging (push notification) |

---

## SD-1: Peserta Login, Lihat Kompetisi, Join & Submit [IMPLEMENTED]

```
Peserta              Flutter App              Firebase Auth         Firestore              Cloudinary         Gemini AI
  │                      │                        │                    │                      │                 │
  │── Login (email+pw) ─>│                        │                    │                      │                 │
  │                      │── signInWithEmail() ──>│                    │                      │                 │
  │                      │<── UserCredential ─────│                    │                      │                 │
  │                      │                        │                    │                      │                 │
  │                      │── get('Jobseeker/{uid}') ─────────────────>│                      │                 │
  │                      │   [jika tidak ada, cek 'Company/{uid}']    │                      │                 │
  │                      │<── user data + role ──────────────────────│                      │                 │
  │<── Dashboard tampil ─│                        │                    │                      │                 │
  │                      │                        │                    │                      │                 │
  │── Lihat Kompetisi ──>│                        │                    │                      │                 │
  │                      │── collection('Competitions')               │                      │                 │
  │                      │   .where('status','==','Dirilis') ───────>│                      │                 │
  │                      │<── list kompetisi ───────────────────────│                      │                 │
  │<── tampilkan list ───│                        │                    │                      │                 │
  │                      │                        │                    │                      │                 │
  │── Join Competition ─>│                        │                    │                      │                 │
  │                      │── add('Competition_participants',          │                      │                 │
  │                      │   {competition_id, user_id, created_at}) ─>│                      │                 │
  │                      │<── participant_id ────────────────────────│                      │                 │
  │                      │── update('Jobseeker/{uid}',                │                      │                 │
  │                      │   competitions_onprogres: arrayUnion) ───>│                      │                 │
  │<── join success ─────│                        │                    │                      │                 │
  │                      │                        │                    │                      │                 │
  │── Submit (teks/file)>│                        │                    │                      │                 │
  │                      │                        │                    │                      │                 │
  │                      │── upload files ────────────────────────────────────────────────>│                 │
  │                      │<── file URLs ─────────────────────────────────────────────────│                 │
  │                      │                        │                    │                      │                 │
  │                      │── [CHECK: sudah submit?]                   │                      │                 │
  │                      │   get participants where user_id ────────>│                      │                 │
  │                      │                        │                    │                      │                 │
  │                      │   [Jika belum submit:]                     │                      │                 │
  │                      │── add('Submissions', {                     │                      │                 │
  │                      │   submissions_id, participant_id,          │                      │                 │
  │                      │   competition_id, answer_text,             │                      │                 │
  │                      │   answer_file_url, submitted_at,           │                      │                 │
  │                      │   score:0, is_checked:false,               │                      │                 │
  │                      │   is_finalist:false}) ───────────────────>│                      │                 │
  │                      │                        │                    │                      │                 │
  │                      │── update('Jobseeker/{uid}', {              │                      │                 │
  │                      │   competitions_done: arrayUnion,           │                      │                 │
  │                      │   competitions_onprogres: arrayRemove}) ─>│                      │                 │
  │                      │                        │                    │                      │                 │
  │<── submission success│                        │                    │                      │                 │
```

---

## SD-2: Peserta Lihat Result + Download Sertifikat [PLANNED]

> **Status:** Belum diimplementasi. Ranking bisa dilihat via Firestore orderBy('score', descending). Certificates collection belum ada.

```
Peserta              Flutter App                     Firestore
  │                      │                               │
  │── Buka Competition   │                               │
  │   Detail (selesai) ─>│                               │
  │                      │── get participant where        │
  │                      │   competition_id & user_id ──>│
  │                      │<── participant_id ────────────│
  │                      │                               │
  │                      │── get('Submissions')           │
  │                      │   .where('competition_id')     │
  │                      │   .orderBy('score', desc) ───>│
  │                      │<── submissions + rank ────────│
  │                      │                               │
  │                      │── [Cek rank user]              │
  │                      │                               │
  │                      │   [PLANNED: Jika Top 10]       │
  │                      │── get('Certificates')          │
  │                      │   .where('user_id & comp_id')─>│
  │                      │<── certificate data ──────────│
  │<── Tampilkan:        │                               │
  │    - Score & Rank    │                               │
  │    - [Top 10: banner │                               │
  │      + download btn] │                               │
  │    - [Not Top 10:    │                               │
  │      score only]     │                               │
  │                      │                               │
  │── [PLANNED]          │                               │
  │   Download Sertifikat│                               │
  │                      │── get certificate_url ───────>│
  │                      │<── URL file ─────────────────│
  │<── download PDF ─────│                               │
```

---

## SD-3: Perusahaan Buat & Publish Kompetisi [IMPLEMENTED]

```
Perusahaan           Flutter App                     Firestore              Cloudinary
  │                      │                               │                      │
  │── Login (company) ──>│                               │                      │
  │   [sama seperti SD-1 tapi cek 'Company/{uid}']       │                      │
  │<── Company Dashboard─│                               │                      │
  │                      │                               │                      │
  │── Buka Create        │                               │                      │
  │   Competition ──────>│                               │                      │
  │                      │                               │                      │
  │── Isi Form:          │                               │                      │
  │   Step 1: Detail     │                               │                      │
  │   (title, desc,      │                               │                      │
  │    category)         │                               │                      │
  │   Step 2: Rubrik     │                               │                      │
  │   (kriteria, bobot)  │                               │                      │
  │   Step 3: Schedule   │                               │                      │
  │   (deadline, reward) │                               │                      │
  │                      │                               │                      │
  │── Upload gambar ────>│                               │                      │
  │                      │── upload image ──────────────────────────────────────>│
  │                      │<── image URL ───────────────────────────────────────│
  │                      │                               │                      │
  │── Upload guidebook ─>│                               │                      │
  │                      │── upload PDF files ─────────────────────────────────>│
  │                      │<── file URLs ───────────────────────────────────────│
  │                      │                               │                      │
  │── Save as Draft ────>│                               │                      │
  │                      │── add('Draft_competitions', { │                      │
  │                      │   ..., status: 'Draft'}) ────>│                      │
  │                      │<── draft_id ─────────────────│                      │
  │<── "Saved as draft" ─│                               │                      │
  │                      │                               │                      │
  │── Publish ──────────>│                               │                      │
  │                      │── add('Competitions', {       │                      │
  │                      │   ..., status: 'Dirilis',     │                      │
  │                      │   company_id, company_name,   │                      │
  │                      │   company_email}) ───────────>│                      │
  │                      │<── competition_id ───────────│                      │
  │                      │                               │                      │
  │                      │── delete('Draft_competitions/ │                      │
  │                      │   {draft_id}') ──────────────>│                      │
  │<── "Published" ──────│                               │                      │
```

**Catatan:** Desain lama memiliki verifikasi `is_verified` saat publish. Di implementasi, pengecekan ini tidak dilakukan secara eksplisit. **Rekomendasi:** Tambahkan validasi `is_verified == true` di Firestore Security Rules untuk operasi write ke collection Competitions.

---

## SD-4: Perusahaan Lihat Kandidat & AI Analysis [IMPLEMENTED]

```
Perusahaan           Flutter App                     Firestore              Gemini AI         FCM
  │                      │                               │                      │               │
  │── Buka View          │                               │                      │               │
  │   Participants ─────>│                               │                      │               │
  │                      │── collection('Submissions')   │                      │               │
  │                      │   .where('competition_id')    │                      │               │
  │                      │   .orderBy('score', desc) ──>│                      │               │
  │                      │<── list submissions ─────────│                      │               │
  │<── tabel peserta ────│                               │                      │               │
  │   (nama, skor, rank) │                               │                      │               │
  │                      │                               │                      │               │
  │── Lihat Detail ─────>│                               │                      │               │
  │                      │── get('Submissions/{id}') ──>│                      │               │
  │                      │── get('Jobseeker/{user_id}')>│                      │               │
  │                      │<── submission + profil ──────│                      │               │
  │<── detail peserta ───│                               │                      │               │
  │                      │                               │                      │               │
  │── Analyze with AI ──>│                               │                      │               │
  │                      │── download submission files   │                      │               │
  │                      │── send to Gemini:             │                      │               │
  │                      │   (problem_statement +        │                      │               │
  │                      │    file content) ─────────────────────────────────>│               │
  │                      │<── {common_pattern[],         │                      │               │
  │                      │     summary[]} ──────────────────────────────────│               │
  │                      │                               │                      │               │
  │                      │── update('Submissions/{id}',  │                      │               │
  │                      │   ai_analyzed: {...}) ───────>│                      │               │
  │<── AI insights ──────│                               │                      │               │
  │                      │                               │                      │               │
  │── Beri Skor & ──────>│                               │                      │               │
  │   Feedback            │                               │                      │               │
  │                      │── update('Submissions/{id}',  │                      │               │
  │                      │   {score, feedback,            │                      │               │
  │                      │    is_checked: true}) ───────>│                      │               │
  │                      │                               │                      │               │
  │                      │── add('Announcements', {      │                      │               │
  │                      │   announcement_id, user_id,   │                      │               │
  │                      │   competition_id, ...}) ────>│                      │               │
  │                      │                               │                      │               │
  │                      │── get Jobseeker FCM token ──>│                      │               │
  │                      │<── token_notification ───────│                      │               │
  │                      │── sendNotification(token,     │                      │               │
  │                      │   title, body, data) ─────────────────────────────────────────────>│
  │<── "Assessment done" │                               │                      │               │
  │                      │                               │                      │               │
  │── Pilih Finalis ────>│                               │                      │               │
  │                      │── update('Submissions/{id}',  │                      │               │
  │                      │   is_finalist: true) ────────>│                      │               │
  │<── "Added to finalist"│                              │                      │               │
```

**PLANNED:** Export data Top 10 ke CSV/PDF belum diimplementasi.

---

## SD-5: Admin Verifikasi Perusahaan [PLANNED]

> **Status:** Admin role belum diimplementasi di Flutter app. Field `is_verified` sudah ada di Companies collection. Untuk MVP, verifikasi dilakukan via Firebase Console.

```
[PLANNED - Phase 2]

Admin                Admin Dashboard              Firestore
  │                      │                            │
  │── Buka Verify ──────>│                            │
  │   Companies          │                            │
  │                      │── collection('Companies')  │
  │                      │   .where('is_verified',    │
  │                      │    '==', false) ──────────>│
  │                      │<── list unverified ────────│
  │<── list companies ───│                            │
  │                      │                            │
  │── Review company ───>│                            │
  │                      │── get('Companies/{id}') ──>│
  │                      │<── company profile ────────│
  │<── detail profil ────│                            │
  │                      │                            │
  │── [Approve] ────────>│                            │
  │                      │── update('Companies/{id}', │
  │                      │   is_verified: true) ─────>│
  │<── "Approved" ───────│                            │
  │                      │                            │
  │── [Reject] ─────────>│                            │
  │                      │── update('Companies/{id}', │
  │                      │   is_verified: false) ────>│
  │<── "Rejected" ───────│                            │
```

---

## SD-6: Admin Manage Course/Module/Quiz [PLANNED]

> **Status:** Course data sudah ada di Firestore (di-seed manual atau via Firebase Console). Admin UI untuk CRUD belum diimplementasi.

```
[PLANNED - Phase 2]

Admin                Admin Dashboard              Firestore
  │                      │                            │
  │── Manage Courses ───>│                            │
  │                      │── collection('Courses')    │
  │                      │   .orderBy('order_index')─>│
  │                      │<── list courses ──────────│
  │<── tampilkan list ───│                            │
  │                      │                            │
  │── Create Course ────>│                            │
  │   (title, desc,      │                            │
  │    level) ───────────│── add('Courses', {...}) ──>│
  │                      │<── course_id ─────────────│
  │<── "Course created" ─│                            │
  │                      │                            │
  │── Add Chapter ──────>│                            │
  │   (title, desc,      │                            │
  │    duration) ────────│── add('Courses/{id}/       │
  │                      │   course_chapters',{...})─>│
  │                      │<── chapter_id ────────────│
  │<── "Chapter added" ──│                            │
  │                      │                            │
  │── Add Subchapter ───>│                            │
  │                      │── add('Courses/{id}/       │
  │                      │   course_chapters/{id}/    │
  │                      │   sub_chapters', {...}) ──>│
  │<── "Subchapter added"│                            │
  │                      │                            │
  │── Add Module ───────>│                            │
  │   (title, content)   │── add('Courses/.../        │
  │                      │   modules', {...}) ───────>│
  │<── "Module added" ───│                            │
  │                      │                            │
  │── Add Quiz ─────────>│                            │
  │   (question, options,│── add('Courses/.../        │
  │    correct_answer)   │   quizzes', {...}) ───────>│
  │<── "Quiz added" ─────│                            │
```

---

## SD-7: Peserta Profile/Account [IMPLEMENTED]

```
Peserta              Flutter App                     Firestore              Cloudinary
  │                      │                               │                      │
  │── Buka Profile ─────>│                               │                      │
  │                      │── get('Jobseeker/{uid}') ───>│                      │
  │                      │<── data profil ──────────────│                      │
  │<── tampilkan profil ─│                               │                      │
  │   (Edit, Password,   │                               │                      │
  │    Certificates,     │                               │                      │
  │    Logout)           │                               │                      │
  │                      │                               │                      │
  │── [Edit Profile] ───>│                               │                      │
  │   Ubah bio, skill,   │                               │                      │
  │   CV, dll            │                               │                      │
  │                      │── upload CV (optional) ──────────────────────────────>│
  │                      │<── file_url ────────────────────────────────────────│
  │                      │── update('Jobseeker/{uid}',   │                      │
  │                      │   {...updated fields}) ──────>│                      │
  │<── "Profile updated" │                               │                      │
  │                      │                               │                      │
  │── [Change Password] ─>│                               │                      │
  │   (old pw + new pw)  │                               │                      │
  │                      │── Firebase Auth:               │                      │
  │                      │   reauthenticate() then        │                      │
  │                      │   updatePassword() ──────────>│ (Firebase Auth)      │
  │<── "Password changed"│                               │                      │
  │                      │                               │                      │
  │── [View Certificates]>│                              │                      │
  │   [PLANNED]          │── get('Certificates')         │                      │
  │                      │   .where('user_id') ─────────>│                      │
  │                      │<── list certificates ────────│                      │
  │<── daftar sertifikat │                               │                      │
  │                      │                               │                      │
  │── [Riwayat Kompetisi]>│                              │                      │
  │                      │── collection('Competition_    │                      │
  │                      │   participants')               │                      │
  │                      │   .where('user_id') ─────────>│                      │
  │                      │<── list participations ──────│                      │
  │<── riwayat ──────────│                               │                      │
  │                      │                               │                      │
  │── [Bookmarks] ──────>│                               │                      │
  │                      │── get('Jobseeker/{uid}')      │                      │
  │                      │   → bookmarks array ─────────>│                      │
  │                      │── get competitions by IDs ───>│                      │
  │<── list bookmarks ───│                               │                      │
  │                      │                               │                      │
  │── [Notifications] ──>│                               │                      │
  │                      │── collection('Announcements') │                      │
  │                      │   .where('user_id')           │                      │
  │                      │   .orderBy('created_at',desc)>│                      │
  │                      │<── list announcements ───────│                      │
  │<── notifikasi ───────│                               │                      │
  │                      │                               │                      │
  │── [Logout] ─────────>│                               │                      │
  │                      │── FCM: unsubscribe topics     │                      │
  │                      │── delete token_notification   │                      │
  │                      │── Firebase Auth: signOut()     │                      │
  │                      │── Google SignIn: signOut()     │                      │
  │<── redirect Login ───│                               │                      │
```

---

## SD-8: Peserta Belajar Course & Quiz [IMPLEMENTED]

```
Peserta              Flutter App                     Firestore              Gemini AI
  │                      │                               │                      │
  │── Buka Course List ─>│                               │                      │
  │                      │── collection('Courses')       │                      │
  │                      │   .orderBy('order_index') ──>│                      │
  │                      │<── list courses ─────────────│                      │
  │<── tampilkan courses │                               │                      │
  │                      │                               │                      │
  │── Pilih Course ─────>│                               │                      │
  │                      │── get('Courses/{id}/          │                      │
  │                      │   course_chapters')            │                      │
  │                      │   .orderBy('order_index') ──>│                      │
  │                      │<── list chapters ────────────│                      │
  │<── tampilkan chapters│                               │                      │
  │                      │                               │                      │
  │── Pilih Chapter ────>│                               │                      │
  │                      │── get sub_chapters            │                      │
  │                      │   .orderBy('order_index') ──>│                      │
  │                      │<── list subchapters ─────────│                      │
  │                      │                               │                      │
  │── Buka Module ──────>│                               │                      │
  │                      │── get modules                 │                      │
  │                      │   .orderBy('order_index') ──>│                      │
  │                      │<── module content (HTML) ────│                      │
  │<── tampilkan konten ─│                               │                      │
  │                      │                               │                      │
  │── Selesai Module ───>│                               │                      │
  │                      │── update('Jobseeker/{uid}',   │                      │
  │                      │   finished_module:             │                      │
  │                      │   arrayUnion([module_id])) ──>│                      │
  │                      │                               │                      │
  │── Mulai Quiz ───────>│                               │                      │
  │                      │── get quizzes                 │                      │
  │                      │   .where('module_id') ───────>│                      │
  │                      │<── list questions ───────────│                      │
  │<── tampilkan soal ───│                               │                      │
  │                      │                               │                      │
  │── Submit Jawaban ───>│                               │                      │
  │                      │── [Hitung skor lokal:         │                      │
  │                      │    compare answers vs          │                      │
  │                      │    correct_answer]             │                      │
  │                      │                               │                      │
  │                      │── update('Jobseeker/{uid}',   │                      │
  │                      │   courses_score: increment,   │                      │
  │                      │   finished_module: arrayUnion, │                      │
  │                      │   progres: update value) ────>│                      │
  │                      │                               │                      │
  │<── tampilkan hasil   │                               │                      │
  │    score quiz ───────│                               │                      │
```

**Catatan:** Di desain lama ada `quiz_attempts` sebagai tabel terpisah dan AI feedback untuk quiz. Di implementasi, skor quiz langsung ditambahkan ke `courses_score` di Jobseeker document. AI feedback untuk quiz **belum diimplementasi** (PLANNED).

---

## SD-9: Company Profile [IMPLEMENTED]

```
Perusahaan           Flutter App                     Firestore              Cloudinary
  │                      │                               │                      │
  │── Buka Company       │                               │                      │
  │   Profile ──────────>│                               │                      │
  │                      │── get('Company/{uid}') ─────>│                      │
  │                      │<── data profil ──────────────│                      │
  │<── tampilkan profil ─│                               │                      │
  │   (Edit Info,        │                               │                      │
  │    Change Password,  │                               │                      │
  │    Logout)           │                               │                      │
  │                      │                               │                      │
  │── [Edit Company Info]>│                              │                      │
  │   (name, description,│                               │                      │
  │    website_url)      │                               │                      │
  │                      │                               │                      │
  │── [opt] Upload logo ─>│                              │                      │
  │                      │── upload image ──────────────────────────────────────>│
  │                      │<── logo URL ────────────────────────────────────────│
  │                      │                               │                      │
  │                      │── update('Company/{uid}', {   │                      │
  │                      │   name, company_description,  │                      │
  │                      │   website_url,                │                      │
  │                      │   profileImage}) ────────────>│                      │
  │<── "Info updated" ───│                               │                      │
  │                      │                               │                      │
  │── [Change Password] ─>│                              │                      │
  │   (old + new pw)     │── Firebase Auth:              │                      │
  │                      │   reauthenticate() then       │                      │
  │                      │   updatePassword() ─────────> (Firebase Auth)       │
  │<── "Password changed"│                               │                      │
  │                      │                               │                      │
  │── [Logout] ─────────>│                               │                      │
  │                      │── Firebase Auth: signOut()     │                      │
  │                      │── Google SignIn: signOut()     │                      │
  │<── redirect Login ───│                               │                      │
```

---

## SD-10: Admin Monitoring Kompetisi [PLANNED]

> **Status:** Belum diimplementasi. Data yang dibutuhkan sudah tersedia di Firestore.

```
[PLANNED - Phase 2]

Admin                Admin Dashboard              Firestore
  │                      │                            │
  │── Monitor            │                            │
  │   Competitions ─────>│                            │
  │                      │── collection('Competitions')│
  │                      │   .where('status','==',    │
  │                      │    'Dirilis') ────────────>│
  │                      │<── list kompetisi aktif ──│
  │<── tampilkan list ───│                            │
  │                      │                            │
  │── View Activity ────>│                            │
  │   (satu kompetisi)   │                            │
  │                      │── [Hitung metrik:]         │
  │                      │   count('Competition_      │
  │                      │   participants')            │
  │                      │   .where('competition_id')─>│
  │                      │<── total peserta ─────────│
  │                      │                            │
  │                      │   count('Submissions')     │
  │                      │   .where('competition_id')─>│
  │                      │<── total submissions ─────│
  │                      │                            │
  │<── ringkasan:        │                            │
  │    - total peserta   │                            │
  │    - total submissions│                           │
  │    - deadline status │                            │
```

---

## SD-11: Admin Logout [PLANNED]

> **Status:** Admin role belum ada. Jika diimplementasi, flow sama dengan logout peserta/company.

```
[PLANNED - Phase 2]

Admin                Admin Dashboard
  │                      │
  │── Klik Logout ──────>│
  │                      │── Firebase Auth: signOut()
  │                      │── clear local state
  │<── redirect Login ───│
```

---

## Ringkasan Status Sequence Diagrams

| # | Diagram | Status | Catatan |
|---|---------|--------|---------|
| SD-1 | Peserta Login → Submit → AI Feedback | IMPLEMENTED | AI feedback scope lebih kecil dari desain awal |
| SD-2 | Peserta Result + Sertifikat | PLANNED | Ranking ada, sertifikat belum |
| SD-3 | Perusahaan Buat Kompetisi | IMPLEMENTED | + draft & rubrik (bonus) |
| SD-4 | Perusahaan Lihat Kandidat | IMPLEMENTED | Export belum ada |
| SD-5 | Admin Verifikasi | PLANNED | Bisa via Firebase Console |
| SD-6 | Admin Manage Course | PLANNED | Data di-seed manual |
| SD-7 | Peserta Profile | IMPLEMENTED | View Certificates belum |
| SD-8 | Peserta Course & Quiz | IMPLEMENTED | Quiz attempts tracking minimal |
| SD-9 | Company Profile | IMPLEMENTED | |
| SD-10 | Admin Monitoring | PLANNED | |
| SD-11 | Admin Logout | PLANNED | |
