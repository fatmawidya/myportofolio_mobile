# MY PORTFOLIO MOBILE — Fatma Widya Rachma

Aplikasi portofolio pribadi berbasis Flutter yang menampilkan identitas pemilik dan menu aksi. Proyek ini melanjutkan Tutorial 08 untuk Individual Assignment 7 Pemrograman Berbasis Platform.

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

### 2. Menu Aksi Portofolio

Tiga `ItemCard` berikon disusun dalam grid tiga kolom.

| Menu | Ikon |
| --- | --- |
| Lihat Proyek | Folder |
| Tambah Proyek | Tambah dalam lingkaran |
| Logout | Keluar |

### 3. Umpan Balik Interaktif

Saat kartu ditekan, aplikasi menampilkan `SnackBar` dengan format “Kamu telah menekan tombol [Nama Tombol]!”. Pesan sebelumnya ditutup saat pengguna menekan kartu lagi.

---

## 📂 Struktur Repositori

```text
myportofolio_mobile/
├── lib/
│   ├── main.dart              # Titik masuk, MaterialApp, dan tema
│   └── menu.dart              # MyHomePage, InfoCard, ItemHomepage, dan ItemCard
├── test/
│   └── widget_test.dart       # Tes penghitung bawaan template Flutter
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

Aplikasi saat ini memakai data profil lokal di `lib/menu.dart`. Setup Flutter sudah cukup untuk menjalankan halaman utama.

### 4. Jalankan aplikasi di Chrome

```bash
flutter devices
flutter run -d chrome
```

Pastikan Chrome muncul dalam daftar perangkat. Setelah aplikasi terbuka, periksa tiga kartu profil dan tekan ketiga kartu aksi untuk melihat pesan `SnackBar` masing-masing. Tekan `q` di terminal untuk menghentikan aplikasi.

Untuk menjalankan di Android, siapkan Android SDK dan nyalakan emulator atau sambungkan perangkat fisik dengan USB debugging. Ambil ID perangkat dari `flutter devices`, lalu jalankan `flutter run -d ID_PERANGKAT` dengan mengganti `ID_PERANGKAT` sesuai daftar.

### 5. Jalankan analisis kode

```bash
flutter analyze
```

Hasil yang diharapkan untuk Tugas 7 adalah `No issues found!`.

---

## 🌐 Portofolio Versi Web

Versi Django tersedia sebagai proyek terpisah. [Fatma's Portfolio Web](https://fatma-widya-myportofolio.pws.cs.ui.ac.id/) · [Repositori Django](https://github.com/fatmawidya/myportofolio)

---

### Tugas 7


---

## 🤖 AI Disclosure



### Strategi prompting dan ringkasan interaksi



### Evaluasi bantuan AI dan keterbatasan


