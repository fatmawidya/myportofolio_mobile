# MY PORTFOLIO MOBILE — Fatma Widya Rachma

[![CI](https://github.com/fatmawidya/myportofolio_mobile/actions/workflows/main.yaml/badge.svg?branch=main)](https://github.com/fatmawidya/myportofolio_mobile/actions/workflows/main.yaml)

Aplikasi portofolio pribadi berbasis Flutter untuk Pemrograman Berbasis Platform. Tutorial 10 menghubungkan fitur Proyek ke Django REST Framework, menambahkan autentikasi token, dan menyiapkan CI/CD melalui GitHub Actions. Tugas 9 menerapkan integrasi yang sama pada Edukasi: daftar dan detail bersifat publik, sedangkan penambahan memerlukan token.

---

## 👤 Identitas

- **Nama** — Fatma Widya Rachma
- **NPM** — 2506533614
- **Program Studi** — S1 Sistem Informasi
- **Kelas** — PBP A

---

## 🛠️ Ringkasan Fitur & Halaman

### 1. Halaman Utama & Informasi Profil

Halaman `MyPortfolio` menampilkan tiga `InfoCard` berlabel **NPM**, **Name**, dan **Class**, diikuti pesan sambutan. `MyHomePage` dibangun sebagai `StatelessWidget` dengan tema Material 3.

### 2. Menu Aksi dan Drawer

Lima kartu aksi disusun dalam grid dua kolom pada layar sempit dan tiga kolom pada layar yang lebih lebar.

| Menu | Perilaku |
| --- | --- |
| Lihat Proyek | Mengambil daftar proyek dari Django tanpa perlu login; setiap proyek dapat dibuka untuk melihat detailnya. |
| Tambah Proyek | Meminta login jika belum terautentikasi, lalu membuka formulir yang mengirim proyek ke Django. |
| Lihat Edukasi | Mengambil daftar Edukasi dari Django tanpa login dan membuka detail setiap entri. |
| Tambah Edukasi | Meminta login, membuka formulir, lalu menyimpan Edukasi ke Django dengan token. |
| Logout | Memanggil endpoint logout, menghapus token lokal, dan menampilkan status melalui `SnackBar`. Jika belum login, menampilkan pemberitahuan. |

Drawer yang sama digunakan di halaman utama, daftar proyek dan Edukasi, serta kedua formulir. Pilihannya adalah **Home**, **Add Project**, **Add Education**, **Projects**, **Education**, serta **Login** atau **Logout** sesuai status autentikasi. Akses **Add Project** dan **Add Education** dari drawer juga dilindungi pemeriksaan login.

### 3. Integrasi Backend dan Autentikasi

`Project` menggunakan `@JsonSerializable(fieldRename: FieldRename.snake)` untuk memetakan data Dart ke JSON API. Atribut `id` berasal dari server dan tidak dikirim pada POST. `project_image_url` boleh kosong atau bernilai `null` pada respons dan dibaca sebagai string kosong.

`Education` juga menggunakan serialisasi snake_case sesuai `EducationSerializer`. Tahun selesai kosong dikirim sebagai `null`, URL logo kosong/null dibaca sebagai string kosong, dan field milik server (`id`, `degree_display`, `is_current`, `star_count`, `is_starred`) tidak disertakan pada POST.

`ApiClient` menangani permintaan HTTP, sedangkan `AuthState` menyimpan token di memori dan memberi tahu UI ketika status login berubah. Keduanya disediakan melalui `MultiProvider`. Token tidak disimpan permanen, sehingga aplikasi yang dimulai ulang perlu login kembali.

| Metode | Endpoint | Akses dan fungsi |
| --- | --- | --- |
| GET | `/api/v1/education/` | Publik; mengambil daftar Edukasi. |
| POST | `/api/v1/education/` | Token milik superuser; membuat Edukasi. |
| GET | `/api/v1/projects/` | Publik; mengambil daftar proyek. |
| POST | `/api/v1/projects/` | Token milik superuser; membuat proyek. |
| POST | `/api/v1/auth/token/` | Menukar username dan password dengan token. |
| POST | `/api/v1/auth/logout/` | Mencabut token aktif; respons berhasil berupa HTTP 204. |

Daftar proyek dan Edukasi menggunakan `FutureBuilder`, indikator loading, pesan daftar kosong, tombol **Retry** ketika gagal, dan pull-to-refresh. Detail proyek menampilkan judul, deskripsi, teknologi, URL proyek, serta gambar jika tersedia. Detail Edukasi menampilkan seluruh field respons: ID, institusi, jenjang, jurusan, tahun, deskripsi, URL logo, status pendidikan, jumlah bintang, dan status penandaan. Logo hanya dimuat jika URL tersedia.

Form proyek menyediakan **Title**, **Description**, **Tech Stack**, **Project URL**, dan **Project Image URL (Optional)**. Isian wajib dan format URL diperiksa sebelum POST dengan header `Authorization: Token <key>`. Respons berhasil ditampilkan dalam dialog, kemudian form dikosongkan setelah dialog ditutup. Jika server mengembalikan HTTP 401, sesi lokal dihapus dan pengguna diminta login ulang; isian dipertahankan agar dapat dikirim lagi dengan tombol **Save**.

### 4. Formulir Tambah Edukasi — Tugas 9

Formulir mengikuti model Edukasi di portofolio Django. Pengguna dapat mengisi nama institusi, jenjang, jurusan, tahun masuk, tahun selesai, URL logo, dan deskripsi. Tahun selesai dan URL logo bersifat opsional. Jika diisi, tahun selesai harus sama dengan atau setelah tahun masuk, dan URL logo harus memakai HTTP atau HTTPS.

Tombol **Simpan** memvalidasi isian lalu mengirim POST dengan token. Setelah HTTP 201, dialog menampilkan data yang tersimpan dari server. Tombol **Lihat Daftar** membawa pengguna ke daftar terbaru; jika form dibuka dari daftar, daftar tersebut dimuat ulang. HTTP 400/403 atau kegagalan jaringan mempertahankan isian dan menampilkan pesan. HTTP 401 menghapus sesi dan meminta login ulang; setelah login, tekan **Simpan** lagi.

Kartu **Pratinjau Edukasi** diperbarui saat pengguna mengubah institusi, jenjang, jurusan, atau tahun. Setelah tahun masuk diisi, kartu menampilkan status **Sedang menempuh pendidikan** selama tahun selesai masih kosong.

---

## 📂 Struktur Repositori

```text
myportofolio_mobile/
├── .github/workflows/main.yaml # CI dan build APK release
├── lib/
│   ├── main.dart                  # MultiProvider, MaterialApp, dan tema
│   ├── config.dart                # API_BASE_URL melalui --dart-define
│   ├── models/
│   │   ├── project.dart           # Model JSON Proyek
│   │   └── education.dart         # Model JSON Edukasi; *.g.dart dihasilkan otomatis
│   ├── screens/
│   │   ├── menu.dart              # Halaman utama, kartu profil, dan data menu
│   │   ├── login_screen.dart      # Login username dan password
│   │   ├── project_list_screen.dart   # GET proyek, refresh, dan status pemuatan
│   │   ├── project_detail_screen.dart # Detail proyek dan gambar opsional
│   │   ├── project_form.dart      # Validasi dan POST proyek dengan token
│   │   ├── education_list_screen.dart   # GET Edukasi publik dan refresh
│   │   ├── education_detail_screen.dart # Seluruh field Edukasi
│   │   └── education_form.dart    # Validasi dan POST Edukasi dengan token
│   ├── services/
│   │   ├── api_client.dart        # Permintaan HTTP ke Django
│   │   └── auth_state.dart        # Token di memori dan perubahan status login
│   ├── validators/
│   │   └── education_validators.dart # Validasi tahun dan URL logo
│   └── widgets/
│       ├── auth_guard.dart        # Meminta login sebelum membuka fitur terlindungi
│       ├── education_preview_card.dart # Tampilan pratinjau Edukasi
│       ├── left_drawer.dart       # Drawer yang dipakai bersama
│       └── project_card.dart      # Kartu aksi dan navigasi dari halaman utama
├── test/
│   ├── widget_test.dart           # Model JSON, autentikasi, dan alur Proyek
│   ├── education_form_test.dart   # Login, validasi, POST, refresh daftar, dan 401
│   ├── education_api_test.dart    # Serialisasi, header token, dan error API
│   ├── education_list_test.dart   # Daftar/detail publik, retry, dan refresh
│   ├── support/
│   │   └── education_server.dart  # HTTP tiruan untuk tes widget
│   └── education_validators_test.dart # Validasi tahun dan URL Edukasi
├── android/                   # Konfigurasi target Android
├── ios/                       # Konfigurasi target iOS
├── web/                       # Konfigurasi target web
├── linux/                     # Konfigurasi target Linux
├── macos/                     # Konfigurasi target macOS
├── windows/                   # Konfigurasi target Windows
├── analysis_options.yaml      # Aturan analisis Dart
├── pubspec.yaml               # Metadata, batas versi SDK, dan dependensi
├── pubspec.lock               # Versi dependensi yang dipakai
└── README.md
```

---

## 🛠️ Langkah Menjalankan Proyek Lokal

### 1. Siapkan Flutter SDK dan Chrome

Gunakan Flutter **3.47.9** dengan Dart **3.13.7**, sesuai versi yang dipakai pada CI, dan pastikan Flutter tersedia di `PATH`. Gunakan Google Chrome sebagai target web.

```bash
flutter --version
flutter doctor
```

### 2. Clone repositori

```bash
git clone https://github.com/fatmawidya/myportofolio_mobile.git
cd myportofolio_mobile
```

Kalau repositori sudah ada di komputer, buka terminal di folder yang berisi `pubspec.yaml`.

### 3. Pasang dependensi dan hasilkan model JSON

```bash
flutter pub get
dart run build_runner build
```

Jalankan kembali `build_runner` setelah mengubah model di `lib/models/`. Versi build_runner saat ini cukup memakai `dart run build_runner build`; opsi `--delete-conflicting-outputs` pada PDF sudah tidak digunakan. Berkas `*.g.dart` diabaikan oleh Git dan dihasilkan ulang pada CI.

### 4. Siapkan backend Django

Gunakan repositori Django portofolio yang terpisah. Di direktori yang berisi `manage.py`, aktifkan virtual environment, lalu jalankan:

```bash
python -m pip install -r requirements.txt
python manage.py migrate
python manage.py runserver
```

Backend harus memiliki konfigurasi berikut:

- `corsheaders` dan `rest_framework.authtoken` terdaftar di `INSTALLED_APPS`, serta dependensi `django-cors-headers` terpasang.
- `CorsMiddleware` berada sebelum `CommonMiddleware`.
- `TokenAuthentication` berada sebelum `SessionAuthentication`; endpoint proyek menggunakan konfigurasi tersebut.
- `ALLOWED_HOSTS` mencakup `localhost`, `127.0.0.1`, `10.0.2.2`, dan domain deploy jika digunakan.
- Untuk Chrome lokal, jalankan backend dengan `PRODUCTION=False` agar konfigurasi CORS lokal berlaku. Untuk Flutter Web yang di-deploy, isi `CORS_ALLOWED_ORIGINS` dengan origin web yang diizinkan.
- Endpoint pada tabel API di atas tersedia, migrasi `authtoken` sudah dijalankan, dan view Edukasi menerima `TokenAuthentication` sebelum `SessionAuthentication`.

Gunakan akun **superuser Django** untuk menambah proyek atau Edukasi. Jika belum memiliki akun tersebut, jalankan `python manage.py createsuperuser` di repositori Django.

### 5. Jalankan aplikasi sesuai perangkat

Biarkan backend berjalan di terminal pertama. Gunakan terminal kedua di direktori Flutter.

**Chrome dengan backend lokal:**

```bash
flutter devices
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8000
```

**Emulator Android dengan backend lokal:**

```bash
flutter run -d ID_EMULATOR
```

Ganti `ID_EMULATOR` dengan ID dari `flutter devices`. Nilai bawaan `API_BASE_URL` adalah `http://10.0.2.2:8000`, yaitu alamat komputer host dari emulator Android.

**Android fisik melalui USB debugging:**

```bash
adb reverse tcp:8000 tcp:8000
flutter run -d ID_PERANGKAT --dart-define=API_BASE_URL=http://localhost:8000
```

Ganti `ID_PERANGKAT` dengan ID perangkat dari `flutter devices`.

**Menggunakan backend deploy:**

```bash
flutter run --dart-define=API_BASE_URL=https://fatma-widya-myportofolio.pws.cs.ui.ac.id
```

Backend deploy perlu memuat perubahan autentikasi token untuk Proyek dan Edukasi. Untuk Chrome dengan backend produksi, origin Flutter Web juga harus diizinkan pada konfigurasi CORS; gunakan backend lokal untuk pengembangan Chrome dengan port yang berubah-ubah. Isi URL dasar tanpa garis miring `/` di akhir. Tekan `q` di terminal untuk menghentikan aplikasi.

### 6. Jalankan pemeriksaan lokal

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

Pastikan format tidak perlu diubah, analisis menampilkan `No issues found!`, dan seluruh tes lulus. Tes HTTP memakai `MockClient`, sehingga tidak memerlukan backend aktif; koneksi ke Django diuji melalui langkah manual berikut.

### Pengujian Proyek dan Login — Tutorial 10

1. Jalankan Django dan Flutter dengan URL yang sesuai. Buka **Lihat Proyek** saat belum login; cocokkan daftar dengan data Django, buka detail, lalu coba refresh. Gambar hanya ditampilkan jika URL-nya tersedia.
2. Saat belum login, buka **Tambah Proyek** melalui kartu maupun **Add Project** di drawer. Pastikan layar login muncul. Coba isian kosong dan kredensial salah; form proyek hanya terbuka setelah login berhasil.
3. Isi form proyek dengan akun superuser. Coba URL yang tidak valid, lalu lengkapi isian dengan benar. Tekan **Save**, cocokkan ringkasan, tutup dialog, dan pastikan form dikosongkan. Buka daftar proyek lagi untuk memeriksa data yang tersimpan di Django.
4. Tekan **Logout**. Pastikan opsi drawer kembali menjadi **Login**, daftar proyek tetap dapat dibuka, dan menambah proyek kembali meminta login.
5. Untuk menguji token kedaluwarsa, login lalu cabut token tersebut melalui Django admin di lingkungan lokal. Kirim form; pastikan aplikasi meminta login ulang dan mempertahankan isian. Setelah login, tekan **Save** lagi.

### CI/CD dan APK — Tutorial 10

Workflow `.github/workflows/main.yaml` memakai Flutter **3.47.9** pada kedua job dan berjalan saat push ke `main` dan pada pull request:

- Job `build` memakai `very_good_workflows` untuk menghasilkan model JSON, memeriksa format dan analisis, serta menjalankan tes dengan batas cakupan minimum `0` sesuai tutorial.
- Job `build_apk` berjalan setelah `build` berhasil, menghasilkan APK release, dan mengunggah artefak **app-release-apk**.

Untuk APK yang terhubung ke backend deploy, buka **Settings → Secrets and variables → Actions → Variables** pada repositori GitHub. Tambahkan repository variable **API_BASE_URL** dengan URL backend tanpa `/` di akhir, misalnya `https://fatma-widya-myportofolio.pws.cs.ui.ac.id`. Workflow memakai nilai tersebut saat build. Jika variabel kosong atau belum diatur, APK memakai `https://fatma-widya-myportofolio.pws.cs.ui.ac.id`.

Build APK secara lokal dengan backend deploy:

```bash
flutter build apk --release --dart-define=API_BASE_URL=https://fatma-widya-myportofolio.pws.cs.ui.ac.id
```

Hasil lokal berada di `build/app/outputs/flutter-apk/app-release.apk`.

Setelah pemeriksaan lokal selesai, commit dan push perubahan Tugas 9. Di tab **Actions**, pastikan kedua job hijau dan artefak APK tersedia. Kumpulkan tautan commit GitHub melalui slot Tugas 9 di SCELE.

### Pengujian Formulir Edukasi

1. Buka **Lihat Edukasi** sebelum login. Cocokkan data dengan Django, buka detail, dan coba pull-to-refresh. Coba juga **Education** di drawer.
2. Buka form lewat kartu **Tambah Edukasi**, **Add Education** di drawer, atau tombol tambah pada daftar. Pastikan login diminta. Gunakan akun superuser.
3. Coba institusi kosong, tahun selesai sebelum tahun masuk, dan URL logo yang tidak valid. Pastikan pesan kesalahan muncul dan data tidak tersimpan.
4. Lengkapi isian dan tekan **Simpan**. Cocokkan dialog dengan isian, pilih **Lihat Daftar**, lalu pastikan entri muncul juga di halaman Edukasi Django setelah refresh. Ulangi pada layar 360 piksel.
5. Untuk menguji 401 secara lokal, login lalu hapus token melalui Django admin. Kirim form; aplikasi harus meminta login ulang dan mempertahankan isian. Setelah login, tekan **Simpan** lagi. Logout lalu pastikan daftar publik tetap dapat dibuka.

---

## 🌐 Portofolio Versi Web

Versi Django tersedia sebagai proyek terpisah. [Fatma's Portfolio Web](https://fatma-widya-myportofolio.pws.cs.ui.ac.id/) · [Repositori Django](https://github.com/fatmawidya/myportofolio) · [API Edukasi publik](https://fatma-widya-myportofolio.pws.cs.ui.ac.id/api/v1/education/)

---

### Assignment 9

1. **Mengapa memakai `@JsonSerializable(fieldRename: FieldRename.snake)` dan `@JsonKey(includeToJson: false)` daripada menyusun Map mentah di widget?**

   Model membuat kontrak data API terpusat dan bertipe jelas. `fieldRename` memetakan atribut Dart `fieldOfStudy`, `startYear`, dan `endYear` menjadi kunci DRF `field_of_study`, `start_year`, dan `end_year`. Widget cukup membentuk `Education`, sementara generator mengurus serialisasi. `includeToJson: false` mengecualikan UUID dan informasi hasil perhitungan server dari POST. Dengan demikian, form tidak bisa tanpa sengaja mengirim ulang ID entri lain ketika membuat entri baru. Pendekatan ini juga mencegah kesalahan nama `fieldOfStudy` pada body JSON yang akan membuat DRF menganggap `field_of_study` tidak diisi. Tahun bertipe `int`/`int?`, dan tahun selesai kosong dikirim sebagai `null` alih-alih string kosong.

2. **Mengapa Future dibuat di `initState()` dan respons HTTP non-2xx melempar `ApiException`?**

   `build()` dapat dipanggil berulang ketika tema, ukuran layar, atau state berubah. Membuat request di sana akan menghasilkan Future baru pada setiap build, memicu GET berulang dan mereset keadaan loading. `EducationListScreen` menyimpan Future dari `initState()` dan hanya menggantinya ketika pengguna meminta refresh/retry atau berhasil membuat entri. `ApiException` mempertahankan perbedaan antara kegagalan dan hasil kosong yang sah. Mengembalikan `null` pada HTTP 500 dapat membuat UI salah menampilkan "Belum ada edukasi"; melempar exception memungkinkan `FutureBuilder` menampilkan error dan Retry. Pada POST, status 401 dapat diarahkan ke pemulihan sesi, sedangkan 403 menunjukkan bahwa akun tidak memiliki izin menulis.

3. **Apa perbedaan SessionAuthentication dan TokenAuthentication, dan mengapa keduanya tetap digunakan?**

   SessionAuthentication mengenali pengguna melalui cookie sesi Django. Browser mengirim cookie tersebut dan operasi tulis dengan sesi memerlukan token CSRF. TokenAuthentication memeriksa header `Authorization: Token <key>` pada setiap request, sehingga Flutter tidak perlu mengelola cookie sesi dan mekanisme CSRF browser. Aplikasi menyimpan token di `AuthState`, menambahkannya pada POST, lalu menghapus sesi lokal saat logout atau 401. Backend tetap mengaktifkan sesi untuk situs Django dan browsable API. Token ditempatkan lebih dulu sehingga token tidak sah atau autentikasi yang diperlukan dapat menghasilkan HTTP 401. Autentikasi mengenali identitas; permission backend tetap menentukan apakah pengguna boleh membuat entri, sehingga token pengguna biasa tidak setara dengan izin superuser.

4. **Apa peran `build` dan `build_apk`, dan mengapa `*.g.dart` diabaikan Git?**

   `build` menjalankan workflow bersama yang memasang dependensi, menjalankan setup generator, memeriksa pemformatan dan static analysis, lalu menjalankan tes serta coverage. `build_apk` memiliki `needs: build`, sehingga APK hanya dibangun setelah pemeriksaan tersebut lulus. Job kedua menghasilkan kembali model, mengompilasi release dengan URL backend yang dipilih, dan mengunggah `app-release-apk`. Berkas `.g.dart` adalah turunan dari model beranotasi dan versi dependensi pada lockfile; menyimpannya di Git menambah perubahan hasil generator serta potensi konflik. CI tidak membutuhkan salinan yang di-commit karena `build_runner` dijalankan sebelum analisis, tes, dan kompilasi. Karena itu clone baru juga harus menjalankan generator sebelum menjalankan aplikasi.

---

## 🤖 AI Disclosure

Pada pengerjaan Tutorial 09 dan Tugas 8, saya menggunakan ChatGPT sebagai alat bantu untuk memahami instruksi, mencocokkan kode dengan checklist tugas, dan meninjau masalah tampilan pada aplikasi Flutter. Saya juga menggunakannya untuk mendapat contoh kode dan bantuan menyusun README serta draf jawaban reflektif. Saya menerapkan perubahan pada aplikasi, mengecek hasilnya di Chrome, serta melakukan commit dan push sendiri.

### Strategi prompting dan ringkasan interaksi

Saya memberi ChatGPT konteks berupa PDF tugas, kode Flutter yang sedang saya kerjakan, dan tangkapan layar saat ada masalah tampilan. Saya memulai dengan meminta pemeriksaan berdasarkan checklist. Setelah itu, saya mempersempit pertanyaan ke bagian yang perlu dikerjakan dan meminta petunjuk yang menyebutkan file, blok kode, serta langkah pengecekannya.

Saya memakai jawaban ChatGPT sebagai panduan saat mengerjakan perubahan. Setelah menerapkannya, saya kembali dengan hasil pengecekan atau tangkapan layar untuk memastikan perbaikannya sesuai sebelum melanjutkan ke tahap berikutnya.

### Evaluasi bantuan AI dan keterbatasan

ChatGPT saya gunakan sebagai alat bantu ketika ada konsep atau langkah pengerjaan yang belum saya pahami. Saya meminta penjelasan, arahan untuk memeriksa kesalahan, serta bantuan meninjau dan memperbaiki kode. Saran yang diberikan tetap perlu dicocokkan dengan materi tutorial dan kebutuhan proyek karena tidak selalu langsung sesuai.

Dalam pengujian, ChatGPT membantu memberikan arahan mengenai bagian yang perlu diperiksa dan membantu meninjau hasilnya. Hasil pengujian di Chrome membantu saya mengecek tampilan dan interaksi pada ukuran jendela yang saya gunakan. Tampilan pada ukuran layar atau perangkat lain perlu diperiksa secara terpisah.

Melalui proses ini, saya belajar untuk lebih jelas menyampaikan pertanyaan dan menilai kesesuaian jawaban AI. Saya tetap perlu memahami kode dan memeriksa kembali saran sebelum menggunakannya. Keputusan penggunaan saran dan tanggung jawab atas hasil akhir tetap berada pada saya.
