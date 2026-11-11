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

1. **Jelaskan apa yang dimaksud dengan widget tree pada Flutter dan bagaimana hubungan induk-anak (parent-child) bekerja antar-widget!**

   Widget tree adalah susunan widget yang mendeskripsikan antarmuka secara hierarkis. Widget induk menempatkan widget lain di bawahnya, misalnya melalui properti `child` untuk satu anak atau `children` untuk beberapa anak. Di aplikasi ini, `Row` memiliki tiga `InfoCard` sebagai anak. Setiap `InfoCard` membangun `Card` yang di dalamnya terdapat `Column` untuk menyusun label dan nilai identitas secara vertikal. Dalam proses layout, induk memberi batas ukuran kepada anak, anak memilih ukuran dalam batas tersebut, lalu induk menentukan posisi anak.

2. **Sebutkan semua widget yang kamu gunakan dalam proyek ini dan jelaskan fungsinya masing-masing!**

   | Widget | Fungsi dalam aplikasi |
   | --- | --- |
   | `MyApp` | Menjadi widget awal yang dipasang oleh `runApp`. |
   | `MaterialApp` | Mengatur judul aplikasi, tema Material 3, dan halaman awal. |
   | `MyHomePage` | Menyusun halaman profil dan menu aksi. |
   | `Scaffold` | Menyediakan struktur halaman yang memuat `AppBar`, isi halaman, dan area tampilan `SnackBar`. |
   | `AppBar` | Menampilkan judul MyPortfolio di bagian atas halaman. |
   | `SingleChildScrollView` | Membuat isi halaman bisa digulir saat tinggi layar terbatas. |
   | `Column` | Menyusun elemen secara vertikal, seperti label dan nilai identitas. |
   | `Row` | Menyusun tiga kartu profil secara horizontal. |
   | `InfoCard` | Menampilkan label dan nilai untuk NPM, nama, atau kelas. |
   | `Card` | Memberi bentuk kartu dan elevasi pada informasi profil. |
   | `Container` | Mengatur lebar dan padding kartu profil serta padding kartu aksi. |
   | `Text` | Menampilkan judul, identitas, pesan sambutan, label aksi, dan isi `SnackBar`. |
   | `SizedBox` | Memberi jarak tetap di antara elemen. |
   | `Center` | Memusatkan bagian menu dan isi kartu aksi. |
   | `Padding` | Memberi jarak di sekitar pesan sambutan dan di bawah ikon kartu aksi. |
   | `GridView.count` | Menyusun kartu aksi dalam tiga kolom dengan tinggi kartu yang ditentukan. |
   | `ItemCard` | Menampilkan satu aksi dengan warna, ikon, label, dan respons saat ditekan. |
   | `Material` | Menyediakan permukaan dan warna latar kartu aksi. |
   | `InkWell` | Menangani ketukan dan memberikan efek sentuh pada permukaan kartu. |
   | `Icon` | Menampilkan simbol untuk tiap aksi. |
   | `SnackBar` | Menampilkan pesan singkat sesuai tombol yang ditekan. |
   | `Theme` | Menyediakan skema warna yang diakses halaman melalui `Theme.of(context)`. |
   | `MediaQuery` | Menyediakan ukuran area tampilan untuk menghitung lebar `InfoCard`. |
   | `ScaffoldMessenger` | Mengelola penutupan dan penayangan `SnackBar`. |

   `Theme`, `MediaQuery`, dan `ScaffoldMessenger` diakses dari widget leluhur. `ItemHomepage` berperan sebagai model data yang menyimpan nama, ikon, dan warna untuk setiap kartu aksi.

3. **Apa fungsi dari widget MaterialApp? Jelaskan mengapa widget ini umumnya digunakan sebagai root widget pada aplikasi Flutter!**

   `MaterialApp` menyediakan konfigurasi tingkat aplikasi, seperti tema Material, navigasi, dan halaman awal. Penempatannya di bagian atas widget tree membuat konfigurasi itu dapat digunakan oleh halaman di bawahnya. Pada proyek ini, `MyApp` mengembalikan `MaterialApp` yang memakai tema Material 3 dan menetapkan `MyHomePage()` sebagai `home`. Halaman utama mengambil warna `AppBar` dari tema melalui `Theme.of(context)`.

4. **Jelaskan perbedaan antara StatelessWidget dan StatefulWidget! Kapan kita sebaiknya memilih StatelessWidget dan kapan harus menggunakan StatefulWidget?**

   `StatelessWidget` cocok ketika tampilan dapat ditentukan dari konfigurasi widget dan data yang tersedia dari konteks. Widget ini tetap bisa dibangun ulang ketika input atau dependensinya berubah. `StatefulWidget` memiliki objek `State` terpisah yang dapat menyimpan nilai yang berubah selama widget terpasang. Pemanggilan `setState` menjadwalkan build ulang untuk menerapkan perubahan tersebut. Di proyek ini, `MyHomePage` memakai `StatelessWidget` karena data profil dan menu sudah ditentukan, sementara penayangan pesan dikelola oleh `ScaffoldMessenger`. Contoh penggunaan `StatefulWidget` adalah halaman daftar yang menyimpan filter pilihan pengguna.

5. **Apa itu BuildContext dan mengapa penting di Flutter? Bagaimana penggunaannya di dalam metode build?**

   `BuildContext` menunjukkan posisi widget dalam pohon widget. Flutter memberikannya ke `build(BuildContext context)` agar widget bisa mengakses informasi dan layanan yang tersedia dari leluhurnya. Dalam proyek ini, `Theme.of(context)` mengambil warna tema, `MediaQuery.of(context)` membaca lebar area tampilan untuk menentukan lebar kartu profil, dan `ScaffoldMessenger.of(context)` dipakai saat kartu aksi ditekan untuk menutup pesan sebelumnya dan menampilkan pesan baru.

6. **Jelaskan konsep hot reload di Flutter dan apa perbedaannya dengan hot restart! Kapan kita tidak bisa hanya mengandalkan hot reload dan harus melakukan hot restart atau full restart?**

   Hot reload memuat perubahan kode Dart dan membangun ulang tampilan sambil mempertahankan state. Ini cocok untuk perubahan tampilan seperti teks atau padding. Hot restart memulai ulang aplikasi Dart dari `main()` dan mereset state. Gunakan hot restart ketika perubahan perlu menjalankan ulang kode di `main()` atau `initState()`. Untuk perubahan pada kode native seperti Kotlin atau Swift, lakukan full restart dengan menghentikan aplikasi dan menjalankannya kembali agar bagian native ikut dibangun ulang.

Referensi teknis — [BuildContext](https://api.flutter.dev/flutter/widgets/BuildContext-class.html) dan [Hot reload](https://docs.flutter.dev/tools/hot-reload).

---

## 🤖 AI Disclosure

Pada pengerjaan Tutorial 08 dan Tugas 7, saya menggunakan ChatGPT sebagai alat bantu untuk memahami instruksi, mencocokkan kode dengan checklist tugas, dan meninjau masalah tampilan pada aplikasi Flutter. Saya juga menggunakannya untuk mendapat contoh kode dan bantuan menyusun README serta draf jawaban reflektif. Saya menerapkan perubahan pada aplikasi, mengecek hasilnya di Chrome, serta melakukan commit dan push sendiri.

### Strategi prompting dan ringkasan interaksi

Saya memberi ChatGPT konteks berupa PDF tugas, kode Flutter yang sedang saya kerjakan, dan tangkapan layar saat ada masalah tampilan. Saya memulai dengan meminta pemeriksaan berdasarkan checklist. Setelah itu, saya mempersempit pertanyaan ke bagian yang perlu dikerjakan dan meminta petunjuk yang menyebutkan file, blok kode, serta langkah pengecekannya.

Beberapa prompt yang saya gunakan, diringkas dari percakapan:
- “Cocokkan kode Flutter saya dengan checklist Tugas 7. Tunjukkan poin yang sudah terpenuhi dan yang masih perlu saya kerjakan dengan istilah yang sama seperti di PDF.”
- “Periksa tangkapan layar aplikasi di Chrome. Jelaskan penyebab bottom overflow dan tunjukkan blok layout yang perlu saya ubah agar ketiga kartu tampil utuh.”
- “Bantu saya membagi pekerjaan menjadi beberapa tahap yang punya hasil jelas. Sarankan pesan commit untuk tiap tahap dan periksa perubahan sebelum saya commit.”

Saya memakai jawaban ChatGPT sebagai panduan saat mengerjakan perubahan. Setelah menerapkannya, saya kembali dengan hasil pengecekan atau tangkapan layar untuk memastikan perbaikannya sesuai sebelum melanjutkan ke tahap berikutnya.

### Evaluasi bantuan AI dan keterbatasan

ChatGPT saya gunakan sebagai alat bantu ketika ada konsep atau langkah pengerjaan yang belum saya pahami. Saya meminta penjelasan, arahan untuk memeriksa kesalahan, serta bantuan meninjau dan memperbaiki kode. Saran yang diberikan tetap perlu dicocokkan dengan materi tutorial dan kebutuhan proyek karena tidak selalu langsung sesuai.

Dalam pengujian, ChatGPT membantu memberikan arahan mengenai bagian yang perlu diperiksa dan membantu meninjau hasilnya. Hasil pengujian di Chrome membantu saya mengecek tampilan dan interaksi pada ukuran jendela yang saya gunakan. Tampilan pada ukuran layar atau perangkat lain perlu diperiksa secara terpisah.

Melalui proses ini, saya belajar untuk lebih jelas menyampaikan pertanyaan dan menilai kesesuaian jawaban AI. Saya tetap perlu memahami kode dan memeriksa kembali saran sebelum menggunakannya. Keputusan penggunaan saran dan tanggung jawab atas hasil akhir tetap berada pada saya.
