# MY PORTFOLIO MOBILE — Fatma Widya Rachma

Aplikasi portofolio pribadi berbasis Flutter untuk Pemrograman Berbasis Platform. Tugas 7 membangun halaman profil dan menu aksi. Tutorial 9 menambahkan navigasi dan formulir proyek. Tugas 8 menerapkan pola yang sama pada formulir Edukasi.

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

Empat kartu aksi disusun dalam grid dua kolom pada layar sempit dan tiga kolom pada layar yang lebih lebar. Kartu **Tambah Edukasi** langsung membuka formulir. Kartu lain menampilkan `SnackBar` dengan nama aksi.

| Menu | Perilaku |
| --- | --- |
| Lihat Proyek | Menampilkan umpan balik melalui `SnackBar`. |
| Tambah Proyek | Membuka formulir proyek dari Tutorial 9. |
| Tambah Edukasi | Membuka formulir Edukasi dari Tugas 8. |
| Logout | Menampilkan umpan balik melalui `SnackBar`. |

Drawer yang sama digunakan di halaman utama dan kedua formulir. Drawer menyediakan pilihan **Home**, **Add Project**, dan **Add Education**.

### 3. Formulir Tambah Edukasi

Formulir mengikuti model Edukasi di portofolio Django. Pengguna dapat mengisi nama institusi, jenjang, jurusan, tahun masuk, tahun selesai, URL logo, dan deskripsi. Tahun selesai dan URL logo bersifat opsional. Jika diisi, tahun selesai harus sama dengan atau setelah tahun masuk, dan URL logo harus memakai HTTP atau HTTPS.

Tombol **Simpan** memvalidasi isian lalu menampilkan **Ringkasan Edukasi** dalam dialog. Tombol **OK** menutup dialog dan mengembalikan pengguna ke formulir dengan isian yang sama.

Kartu **Pratinjau Edukasi** diperbarui saat pengguna mengubah institusi, jenjang, jurusan, atau tahun. Setelah tahun masuk diisi, kartu menampilkan status **Sedang menempuh pendidikan** selama tahun selesai masih kosong.

---

## 📂 Struktur Repositori

```text
myportofolio_mobile/
├── lib/
│   ├── main.dart                  # Titik masuk, MaterialApp, dan tema
│   ├── screens/
│   │   ├── menu.dart              # Halaman utama, kartu profil, dan data menu
│   │   ├── project_form.dart      # Formulir Tambah Proyek
│   │   └── education_form.dart    # Formulir Tambah Edukasi
│   ├── validators/
│   │   └── education_validators.dart # Validasi tahun dan URL logo
│   └── widgets/
│       ├── education_preview_card.dart # Tampilan pratinjau Edukasi
│       ├── left_drawer.dart       # Drawer yang dipakai bersama
│       └── project_card.dart      # Kartu aksi dan navigasi dari halaman utama
├── test/
│   └── widget_test.dart           # Tes navigasi dan formulir Tambah Proyek
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

Pastikan Flutter tersedia di `PATH` dan versi Dart bawaan Flutter memenuhi batas `sdk: ^3.13.7` di `pubspec.yaml`. Gunakan Google Chrome sebagai target web.

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

### 3. Pasang dependensi

```bash
flutter pub get
```

Aplikasi memakai data profil lokal di `lib/screens/menu.dart`. Formulir menampilkan ringkasan isian di aplikasi, sehingga penyiapan Flutter dan Chrome sudah cukup untuk mencobanya.

### 4. Jalankan aplikasi di Chrome

```bash
flutter devices
flutter run -d chrome
```

Pastikan Chrome muncul dalam daftar perangkat. Setelah aplikasi terbuka, gunakan langkah pengujian di bawah untuk mencoba formulir Edukasi. Tekan `q` di terminal untuk menghentikan aplikasi.

Untuk menjalankan di Android, siapkan Android SDK dan nyalakan emulator atau sambungkan perangkat fisik dengan USB debugging. Ambil ID perangkat dari `flutter devices`, lalu jalankan `flutter run -d ID_PERANGKAT` dengan mengganti `ID_PERANGKAT` sesuai daftar.

### 5. Jalankan analisis kode

```bash
flutter analyze
```

Hasil yang diharapkan adalah `No issues found!`.

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
