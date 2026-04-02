# Updated User Stories - Trajectoria

> **Last Updated:** 2 April 2026
> **Status Legend:**
> - IMPLEMENTED = Sudah diimplementasi di Flutter app
> - PARTIAL = Sebagian diimplementasi
> - PLANNED = Belum diimplementasi, direncanakan untuk phase berikutnya

---

## Role: Peserta (Jobseeker)

### User Stories Asli (Diperbarui)

| # | User Story | Status | Catatan Implementasi |
|---|-----------|--------|----------------------|
| P-1 | Sebagai peserta, saya ingin membuat akun dan login agar saya bisa mengakses kompetisi, course, dan profil saya. | **IMPLEMENTED** | Email/password + Google OAuth via Firebase Auth. Role selection (Jobseeker/Company) setelah signup. Email verification tersedia. |
| P-2 | Sebagai peserta, saya ingin melihat daftar kompetisi yang aktif agar saya bisa memilih mana yang ingin saya ikuti. | **IMPLEMENTED** | Filter by status "Dirilis", search by title, filter by category & deadline. Carousel featured competitions. |
| P-3 | Sebagai peserta, saya ingin mendaftar/join kompetisi tertentu agar nama saya tercatat sebagai peserta. | **IMPLEMENTED** | Membuat record di Competition_participants, update array competitions_onprogres di Jobseeker doc. |
| P-4 | Sebagai peserta, saya ingin mengirim jawaban untuk kompetisi (teks atau file) agar saya bisa dinilai. | **IMPLEMENTED** | Submit teks + upload file via Cloudinary. Validasi: hanya bisa submit sekali per kompetisi. Otomatis pindah ke competitions_done. |
| P-5 | Sebagai peserta, saya ingin melihat skor saya agar saya tahu performa saya dibanding peserta lain. | **PARTIAL** | Skor tersedia di Submissions. Ranking via orderBy score. Namun **auto-ranking display belum optimal** — company harus manual menilai dulu. |
| P-6 | Sebagai peserta, saya ingin melihat feedback AI atas jawaban saya agar saya tahu kelemahan saya dan apa yang perlu diperbaiki. | **PARTIAL** | AI analysis ada (summary & common_pattern via Gemini). Tapi **belum selengkap desain awal** (strengths, weaknesses, improvement_suggestion, career_match belum ada). Feedback dikirim via Announcement notification. |
| P-7 | Sebagai peserta, saya ingin mengunduh sertifikat jika saya masuk 10 besar agar saya punya bukti prestasi. | **PLANNED** | Collection Certificates belum diimplementasi. Perlu: generate PDF sertifikat, auto-assign ke Top 10. |
| P-8 | Sebagai peserta, saya ingin mencari dan mempersiapkan diri untuk bekerja jika saya masuk 10 besar dalam kompetisi yang saya ikuti. | **PLANNED** | Career match recommendation dari AI belum ada. Profil peserta (CV, skill, experience) sudah bisa diisi. |
| P-9 | Sebagai peserta, saya ingin mengakses modul course dan quiz agar saya bisa belajar/memperbaiki skill saya. | **IMPLEMENTED** | Learning system lengkap: Courses → Chapters → Subchapters → Modules → Quizzes. Progress tracking per module/chapter. Score accumulation. |

### User Stories Baru (Dari Implementasi)

| # | User Story | Status | Catatan |
|---|-----------|--------|--------|
| P-10 | Sebagai peserta, saya ingin login via Google agar proses masuk lebih cepat tanpa harus membuat password. | **IMPLEMENTED** | Google Sign-In SDK, otomatis buat record Jobseeker jika belum ada. |
| P-11 | Sebagai peserta, saya ingin mem-bookmark kompetisi agar bisa melihatnya nanti. | **IMPLEMENTED** | Array `bookmarks` di Jobseeker document, arrayUnion/arrayRemove. |
| P-12 | Sebagai peserta, saya ingin melihat riwayat kompetisi yang pernah saya ikuti beserta statusnya. | **IMPLEMENTED** | Melalui Competition_participants query by user_id + HydratedHistoryCubit untuk persistence. |
| P-13 | Sebagai peserta, saya ingin menerima notifikasi push saat submission saya sudah dinilai oleh perusahaan. | **IMPLEMENTED** | FCM push notification + Announcements collection. Deep link ke halaman result. |
| P-14 | Sebagai peserta, saya ingin melihat leaderboard global berdasarkan skor course agar saya termotivasi belajar. | **IMPLEMENTED** | Leaderboard page sorted by courses_score descending. Liga/tier system (Liga Emas). |
| P-15 | Sebagai peserta, saya ingin mengedit profil saya (bio, CV, skill, pengalaman) agar perusahaan bisa melihat kualifikasi saya. | **IMPLEMENTED** | Edit profile page dengan upload CV via Cloudinary. |
| P-16 | Sebagai peserta, saya ingin mengubah password akun saya untuk keamanan. | **IMPLEMENTED** | Firebase Auth reauthenticate + updatePassword. |

---

## Role: Perusahaan (Company)

### User Stories Asli (Diperbarui)

| # | User Story | Status | Catatan Implementasi |
|---|-----------|--------|----------------------|
| C-1 | Sebagai perusahaan, saya ingin membuat kompetisi baru (judul, deskripsi, problem statement, deadline) agar saya bisa mencari talenta yang bisa menyelesaikan masalah saya. | **IMPLEMENTED** | Multi-step form: Detail → Rubrik → Schedule. Bisa save draft atau langsung publish. Upload gambar kompetisi via Cloudinary. |
| C-2 | Sebagai perusahaan, saya ingin menentukan format submission (teks/file) agar peserta mengirim jawaban dalam format yang sesuai kebutuhan saya. | **IMPLEMENTED** | Field `submission_type` di Competitions. |
| C-3 | Sebagai perusahaan, saya ingin melihat daftar peserta yang ikut kompetisi saya agar saya tahu siapa saja yang tertarik. | **IMPLEMENTED** | Query Competition_participants + Submissions by competition_id. Tampilan tabel dengan skor & ranking. |
| C-4 | Sebagai perusahaan, saya ingin melihat skor dan ranking peserta agar saya bisa menemukan kandidat terbaik. | **IMPLEMENTED** | Submissions ordered by score descending. Company bisa memberikan skor manual + feedback. |
| C-5 | Sebagai perusahaan, saya ingin melihat profil kandidat (CV, skill, pengalaman) agar saya bisa memutuskan siapa yang layak direkrut. | **PARTIAL** | Bisa lihat profil Jobseeker (bio, skill_summary, experience_summary, cv_file_path). Tapi **career_match_recommendation dari AI belum ada.** |
| C-6 | Sebagai perusahaan, saya ingin mengunduh data kandidat top-performer agar saya bisa mengecek profile mereka. | **PLANNED** | Export CSV/PDF belum diimplementasi. Data tersedia di Firestore tapi belum ada fitur export. |

### User Stories Baru (Dari Implementasi)

| # | User Story | Status | Catatan |
|---|-----------|--------|--------|
| C-7 | Sebagai perusahaan, saya ingin menyimpan kompetisi sebagai draft sebelum mempublikasikan agar saya bisa menyempurnakan detailnya. | **IMPLEMENTED** | Draft_competitions collection. Konfirmasi dialog saat back navigation. |
| C-8 | Sebagai perusahaan, saya ingin menambahkan rubrik penilaian (kriteria + bobot) pada kompetisi agar peserta tahu apa yang dinilai. | **IMPLEMENTED** | Embedded array `rubrik` [{kriteria, bobot}] di Competitions. |
| C-9 | Sebagai perusahaan, saya ingin upload guidebook (PDF/dokumen) untuk kompetisi agar peserta punya referensi. | **IMPLEMENTED** | Upload via Cloudinary, embedded array `guidebook` [{fileName, extension, url}]. |
| C-10 | Sebagai perusahaan, saya ingin memilih finalis dari peserta kompetisi saya. | **IMPLEMENTED** | Field `is_finalist` di Submissions. Toggle add/remove finalist. |
| C-11 | Sebagai perusahaan, saya ingin mengirim notifikasi ke peserta saat penilaian submission selesai. | **IMPLEMENTED** | Announcements record + FCM push notification dengan deep link. |
| C-12 | Sebagai perusahaan, saya ingin melakukan analisis AI pada submission peserta untuk mendapatkan insight otomatis. | **IMPLEMENTED** | Gemini AI analysis → common_pattern[] + summary[]. Tapi scope analisis masih terbatas. |
| C-13 | Sebagai perusahaan, saya ingin mengedit informasi profil perusahaan (nama, deskripsi, website, logo). | **IMPLEMENTED** | Update Company document + upload logo via Cloudinary. |
| C-14 | Sebagai perusahaan, saya ingin mengubah password akun saya. | **IMPLEMENTED** | Firebase Auth reauthenticate + updatePassword. |
| C-15 | Sebagai perusahaan, saya ingin melihat semua submission dari seluruh kompetisi saya dalam satu dashboard. | **IMPLEMENTED** | Aggregate query across all company's competitions dengan chunking (Firestore whereIn limit). |

---

## Role: Sistem AI

| # | User Story | Status | Catatan Implementasi |
|---|-----------|--------|----------------------|
| AI-1 | Sebagai sistem AI, saya ingin menganalisis submission peserta agar saya bisa menilai kelebihan dan kekurangan teknis peserta. | **PARTIAL** | Gemini AI menghasilkan summary (5 poin) dan common_pattern (5 poin). Tapi **belum menghasilkan strengths/weaknesses terpisah** seperti desain awal. |
| AI-2 | Sebagai sistem AI, saya ingin memberikan rekomendasi pengembangan skill agar peserta tahu harus belajar apa. | **PLANNED** | Belum diimplementasi. Perlu prompt engineering tambahan ke Gemini. |
| AI-3 | Sebagai sistem AI, saya ingin memetakan peserta ke potensi role kerja agar perusahaan bisa langsung melihat relevansi kandidat. | **PLANNED** | Field career_match_recommendation belum ada. Perlu: AI mapping berdasarkan submission + profil peserta. |

---

## Role: Admin

| # | User Story | Status | Catatan Implementasi |
|---|-----------|--------|----------------------|
| A-1 | Sebagai admin, saya ingin memastikan hanya perusahaan terverifikasi yang bisa membuat kompetisi agar tidak ada kompetisi palsu. | **PLANNED** | Field `is_verified` ada di Companies, tapi validasi saat publish belum enforced. Rekomendasi: Firestore Security Rules. Sementara via Firebase Console. |
| A-2 | Sebagai admin, saya ingin melihat kompetisi aktif agar saya bisa memantau aktivitas platform. | **PLANNED** | Data tersedia via query Competitions where status='Dirilis'. Admin UI belum ada. |
| A-3 | Sebagai admin, saya ingin membuat course baru agar peserta bisa belajar dari materi yang sudah dikurasi. | **PLANNED** | Courses di-seed manual via Firebase Console. Admin CRUD UI belum ada. |
| A-4 | Sebagai admin, saya ingin menambahkan module ke dalam course agar materi dapat dibagi menjadi beberapa bagian pembelajaran. | **PLANNED** | Nested subcollection structure sudah ada. Admin UI belum ada. |
| A-5 | Sebagai admin, saya ingin membuat quiz di dalam module agar peserta bisa mengukur pemahamannya. | **PLANNED** | Quiz subcollection sudah ada. Admin UI belum ada. |
| A-6 | Sebagai admin, saya ingin menentukan keberhasilan skor quiz dengan nilai tertentu agar bisa mengukur pemahaman. | **PLANNED** | Field `maximum_score` ada di Chapters dan Modules. Tapi threshold pass/fail belum diimplementasi. |
| A-7 | Sebagai admin, saya ingin mengedit atau menghapus course/module/quiz agar konten bisa selalu diperbarui. | **PLANNED** | CRUD operations tersedia di Firestore. Admin UI belum ada. |
| A-8 | Sebagai admin, saya ingin mengelola data pengguna (peserta & perusahaan) agar sistem tetap aman dan teratur. | **PLANNED** | Bisa via Firebase Console. Admin user management UI belum ada. |

---

## Ringkasan Status

| Role | Total Stories | Implemented | Partial | Planned |
|------|-------------|-------------|---------|---------|
| Peserta | 16 | 12 | 2 | 2 |
| Perusahaan | 15 | 11 | 1 | 3 |
| Sistem AI | 3 | 0 | 1 | 2 |
| Admin | 8 | 0 | 0 | 8 |
| **Total** | **42** | **23 (55%)** | **4 (10%)** | **15 (36%)** |

---

## Prioritas Implementasi Selanjutnya

### Phase 2 (High Priority):
1. **AI-1 (lengkapi):** Perkaya AI feedback → strengths, weaknesses, improvement_suggestion
2. **AI-3:** Career match recommendation
3. **P-7:** Sertifikat Top 10
4. **C-6:** Export data kandidat

### Phase 3 (Medium Priority):
5. **A-1:** Admin verifikasi perusahaan (atau enforce via Security Rules)
6. **A-3 s/d A-7:** Admin CRUD course/module/quiz
7. **AI-2:** Rekomendasi skill development
8. **P-8:** Persiapan kerja / career readiness

### Phase 4 (Low Priority):
9. **A-2:** Admin monitoring dashboard
10. **A-8:** Admin user management
