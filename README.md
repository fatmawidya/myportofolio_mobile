# MY PORTFOLIO MOBILE — Fatma Widya Rachma

Aplikasi portofolio pribadi berbasis Flutter untuk Pemrograman Berbasis Platform. Tutorial 10 menghubungkan fitur Proyek ke Django REST Framework, menambahkan autentikasi token, dan menyiapkan CI/CD melalui GitHub Actions. Halaman profil serta formulir Edukasi dari tugas sebelumnya tetap tersedia.

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

Empat kartu aksi disusun dalam grid dua kolom pada layar sempit dan tiga kolom pada layar yang lebih lebar.

| Menu | Perilaku |
| --- | --- |
| Lihat Proyek | Mengambil daftar proyek dari Django tanpa perlu login; setiap proyek dapat dibuka untuk melihat detailnya. |
| Tambah Proyek | Meminta login jika belum terautentikasi, lalu membuka formulir yang mengirim proyek ke Django. |
| Tambah Edukasi | Membuka formulir Edukasi dari Tugas 8. |
| Logout | Memanggil endpoint logout, menghapus token lokal, dan menampilkan status melalui `SnackBar`. Jika belum login, menampilkan pemberitahuan. |

Drawer yang sama digunakan di halaman utama, daftar proyek, dan kedua formulir. Pilihannya adalah **Home**, **Add Project**, **Add Education**, **Projects**, serta **Login** atau **Logout** sesuai status autentikasi. Akses **Add Project** dari drawer juga dilindungi pemeriksaan login.

### 3. Integrasi Proyek dan Autentikasi — Tutorial 10

`Project` menggunakan `@JsonSerializable(fieldRename: FieldRename.snake)` untuk memetakan data Dart ke JSON API. Atribut `id` berasal dari server dan tidak dikirim pada POST. `project_image_url` boleh kosong atau bernilai `null` pada respons dan dibaca sebagai string kosong.

`ApiClient` menangani permintaan HTTP, sedangkan `AuthState` menyimpan token di memori dan memberi tahu UI ketika status login berubah. Keduanya disediakan melalui `MultiProvider`. Token tidak disimpan permanen, sehingga aplikasi yang dimulai ulang perlu login kembali.

| Metode | Endpoint | Akses dan fungsi |
| --- | --- | --- |
| GET | `/api/v1/projects/` | Publik; mengambil daftar proyek. |
| POST | `/api/v1/projects/` | Token milik superuser; membuat proyek. |
| POST | `/api/v1/auth/token/` | Menukar username dan password dengan token. |
| POST | `/api/v1/auth/logout/` | Mencabut token aktif; respons berhasil berupa HTTP 204. |

Daftar proyek menggunakan `FutureBuilder`, indikator loading, pesan daftar kosong, tombol **Retry** ketika gagal, dan pull-to-refresh. Halaman detail menampilkan judul, deskripsi, teknologi, URL proyek, serta gambar jika URL gambarnya tersedia.

Form proyek menyediakan **Title**, **Description**, **Tech Stack**, **Project URL**, dan **Project Image URL (Optional)**. Isian wajib dan format URL diperiksa sebelum POST dengan header `Authorization: Token <key>`. Respons berhasil ditampilkan dalam dialog, kemudian form dikosongkan setelah dialog ditutup. Jika server mengembalikan HTTP 401, sesi lokal dihapus dan pengguna diminta login ulang; isian dipertahankan agar dapat dikirim lagi dengan tombol **Save**.

### 4. Formulir Tambah Edukasi — Tugas 8

Formulir mengikuti model Edukasi di portofolio Django. Pengguna dapat mengisi nama institusi, jenjang, jurusan, tahun masuk, tahun selesai, URL logo, dan deskripsi. Tahun selesai dan URL logo bersifat opsional. Jika diisi, tahun selesai harus sama dengan atau setelah tahun masuk, dan URL logo harus memakai HTTP atau HTTPS.

Tombol **Simpan** memvalidasi isian lalu menampilkan **Ringkasan Edukasi** dalam dialog. Tombol **OK** menutup dialog dan mengembalikan pengguna ke formulir dengan isian yang sama.

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
│   │   └── project.dart           # Model JSON; project.g.dart dihasilkan otomatis
│   ├── screens/
│   │   ├── menu.dart              # Halaman utama, kartu profil, dan data menu
│   │   ├── login_screen.dart      # Login username dan password
│   │   ├── project_list_screen.dart   # GET proyek, refresh, dan status pemuatan
│   │   ├── project_detail_screen.dart # Detail proyek dan gambar opsional
│   │   ├── project_form.dart      # Validasi dan POST proyek dengan token
│   │   └── education_form.dart    # Formulir Tambah Edukasi
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
│   ├── education_form_test.dart   # Formulir, pratinjau, dan navigasi Edukasi
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

Gunakan Flutter **3.47.9** dengan Dart **3.13.7**, sesuai versi CI, dan pastikan Flutter tersedia di `PATH`. Gunakan Google Chrome sebagai target web.

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

Jalankan kembali `build_runner` setelah mengubah `lib/models/project.dart`. Berkas `*.g.dart` diabaikan oleh Git dan dihasilkan ulang pada CI.

### 4. Siapkan backend Django

Gunakan repositori Django portofolio yang terpisah. Di direktori yang berisi `manage.py`, aktifkan virtual environment, lalu jalankan:

```bash
python -m pip install -r requirements.txt
python manage.py migrate
python manage.py runserver
```

Backend Tutorial 10 harus memiliki konfigurasi berikut:

- `corsheaders` dan `rest_framework.authtoken` terdaftar di `INSTALLED_APPS`, serta dependensi `django-cors-headers` terpasang.
- `CorsMiddleware` berada sebelum `CommonMiddleware`.
- `TokenAuthentication` berada sebelum `SessionAuthentication`; endpoint proyek menggunakan konfigurasi tersebut.
- `ALLOWED_HOSTS` mencakup `localhost`, `127.0.0.1`, `10.0.2.2`, dan domain deploy jika digunakan.
- Untuk Chrome lokal, jalankan backend dengan `PRODUCTION=False` agar konfigurasi CORS lokal berlaku. Untuk Flutter Web yang di-deploy, isi `CORS_ALLOWED_ORIGINS` dengan origin web yang diizinkan.
- Endpoint pada tabel API di atas tersedia, dan migrasi `authtoken` sudah dijalankan.

Gunakan akun **superuser Django** untuk menambah proyek. Jika belum memiliki akun tersebut, jalankan `python manage.py createsuperuser` di repositori Django.

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

Backend deploy perlu memuat perubahan Tutorial 10. Isi URL dasar tanpa garis miring `/` di akhir. Tekan `q` di terminal untuk menghentikan aplikasi.

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

Setelah pemeriksaan lokal selesai, commit dan push perubahan Tutorial 10. Di tab **Actions**, pastikan kedua job hijau dan artefak APK tersedia. Kumpulkan tautan commit GitHub melalui slot Tutorial 10 di SCELE.

### Pengujian Formulir Edukasi

1. Buka formulir lewat kartu **Tambah Edukasi**. Coba kembali dengan tombol kembali perangkat jika tersedia. Buka lagi lewat **Add Education** di drawer, lalu gunakan **Home** untuk kembali ke halaman utama di Chrome.
2. Tekan **Simpan** saat nama institusi kosong. Pastikan pesan muncul pada kolom tersebut. Coba juga tahun masuk `2024` dan tahun selesai `2023`, atau URL logo `ftp://example.com/logo.png`. Pesan harus muncul pada kolom yang salah.
3. Isi seluruh kolom yang wajib dan pilih jenjang. Coba tahun masuk `2024`, tahun selesai `2027`, dan URL logo `https://example.com/logo.png`. Tekan **Simpan**, cocokkan ketujuh isian di dialog, lalu tekan **OK** untuk kembali ke formulir.
4. Ulangi pada Chrome dengan lebar layar sekitar 360 piksel. Gulir formulir dan pastikan semua kolom serta tombol **Simpan** bisa dijangkau.

---

## 🌐 Portofolio Versi Web

Versi Django tersedia sebagai proyek terpisah. [Fatma's Portfolio Web](https://fatma-widya-myportofolio.pws.cs.ui.ac.id/) · [Repositori Django](https://github.com/fatmawidya/myportofolio)

---

### Tugas 8

1. **Jelaskan perbedaan antara `Navigator.push()`, `Navigator.pushReplacement()`, dan `Navigator.pop()`. Metode apa yang digunakan untuk membuka formulir dari kartu aksi? Jelaskan juga bagaimana opsi Home di drawer membawa pengguna kembali ke halaman utama.**

   `push()` menaruh halaman baru di atas halaman yang sedang aktif. Kartu **Tambah Edukasi** memakainya supaya halaman utama masih ada di bawah form dan tombol kembali perangkat bisa membukanya lagi. `pushReplacement()` mengganti halaman aktif dengan halaman baru. Opsi **Home** di drawer memakainya untuk mengganti halaman form dengan `MyHomePage`. `pop()` mengeluarkan rute teratas. Di form Edukasi, tombol **OK** memanggilnya untuk menutup dialog dan kembali ke form dengan isian yang sama.

2. **Bagaimana susunan `Scaffold`, `AppBar`, dan `Drawer` membantu menjaga struktur halaman tetap konsisten? Berikan satu contoh penggunaan warna tema portofolio di lebih dari satu halaman.**

   `Scaffold` mengatur tempat untuk bilah atas, isi halaman, dan drawer. `AppBar` memberi judul sesuai halaman, sedangkan `LeftDrawer` menyediakan menu yang sama dari halaman utama dan kedua formulir. Contohnya, `AppBar` di halaman utama dan form Edukasi sama-sama mengambil warna latar dari `Theme.of(context).colorScheme.primary`, dengan judul dan ikon berwarna putih.

3. **Mengapa tata letak tersebut dipilih untuk formulir? Jelaskan peran widget pengatur jarak dan widget penggulir ketika ruang layar terbatas.**

   Ketujuh input disusun vertikal dengan `Column` supaya pengguna bisa mengisi form dari atas ke bawah. `EdgeInsets.all(16)` memberi jarak antara isi form dan tepi layar, sedangkan `SizedBox` memberi jarak antarinput. `SingleChildScrollView` membuat kolom di bagian bawah dan tombol **Simpan** tetap bisa dijangkau saat layar sempit atau ruang berkurang karena keyboard.

4. **Apa peran `GlobalKey<FormState>`, `validator`, dan `validate()` saat tombol Simpan ditekan? Berikan satu contoh nilai yang ditolak oleh validasi dan jelaskan mengapa memilih jenis input atau papan ketik saja belum cukup.**

   `GlobalKey<FormState>` memberi tombol **Simpan** akses ke status form. Saat tombol ditekan, `validate()` menjalankan `validator` pada kolom yang memilikinya. Jika ada nilai yang tidak valid, pesan muncul di kolom terkait dan dialog baru dapat dibuka setelah semua isian lolos. Misalnya, tahun selesai `2023` ditolak jika tahun masuk `2024`. Papan ketik numerik memudahkan mengetik angka, tetapi pemeriksaan urutan tahun dan nilai yang ditempel tetap memerlukan validasi.

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
