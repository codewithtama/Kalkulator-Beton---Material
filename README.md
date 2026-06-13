# HitungBangun 🏗️

**HitungBangun** adalah aplikasi Flutter Android untuk menghitung estimasi kebutuhan material bangunan dan rincian biaya proyek konstruksi secara presisi berdasarkan standar koefisien SNI Indonesia.

---

## 🚀 Fitur Utama

Aplikasi ini mendukung 7 kategori kalkulasi material utama:
1. **Beton (Campuran Manual):** Menghitung kebutuhan Semen (sak 50kg), Pasir (m³), Kerikil (m³), dan Air (liter) per volume beton dengan mutu pilihan (`K-175`, `K-225`, `K-250`, `K-300`).
2. **Pondasi:** Menghitung volume galian tanah, pasir urug (alas galian tebal 5cm), serta kebutuhan material beton pondasi.
3. **Dinding Bata:** Menghitung kebutuhan bata merah tradisional atau bata ringan (Hebel 10cm), beserta semen mortar instan atau pasir pasang (untuk adukan 1:4).
4. **Plesteran & Acian:** Estimasi kebutuhan semen plester, pasir plester, serta semen acian berdasarkan luas dinding dan ketebalan plesteran.
5. **Keramik Lantai:** Estimasi jumlah keping keramik (untuk ukuran 30x30, 40x40, 60x60, 80x80) dengan tambahan toleransi waste 10%, serta semen & pasir perekat lantai.
6. **Atap:** Estimasi kebutuhan genteng (tanah liat, metal sheet, atau aspal shingle), reng kayu, usuk kayu, dan alas multiplex (untuk atap aspal).
7. **Cat Dinding:** Menghitung volume cat (liter) dan kemasan kaleng (galon 5L / pail 25L) berdasarkan luas dinding dan jumlah lapisan cat.

---

## 🛠️ Stack Teknologi

- **Framework:** Flutter (Android Native/Multiplatform)
- **State Management:** Provider
- **Local Database:** Hive & Hive Flutter (menyimpan riwayat proyek dan pengaturan harga secara offline)
- **Visualisasi Grafik:** fl_chart (diagram lingkar distribusi biaya)
- **Ekspor Dokumen:** pdf & printing (generate ringkasan PDF berukuran A4 untuk cetak atau bagikan)
- **Sharing:** share_plus (berbagi ringkasan teks kalkulasi)
- **Font & Tipografi:** Google Fonts (Plus Jakarta Sans)

---

## 📂 Struktur Folder Proyek

```
lib/
├── core/
│   ├── constants.dart      → Konstanta database, default harga material
│   ├── theme.dart          → Tema visual konstruksi oranye/amber Material 3
│   ├── formulas.dart       → Logika matematika perhitungan material (SNI)
│   └── pdf_helper.dart     → Helper ekspor PDF A4
├── data/
│   ├── models/
│   │   ├── project.dart             → Model data riwayat proyek Hive
│   │   └── calculation_result.dart  → Struktur data hasil hitung
│   └── repos/
│       └── project_repo.dart        → Repositori CRUD lokal Hive
├── providers/
│   ├── calculator_provider.dart  → Manajemen state kalkulator & harga
│   └── history_provider.dart     → Manajemen state riwayat proyek
├── widgets/
│   ├── input_field.dart    → Input teks berlabel dengan suffix satuan (m, m², m³)
│   ├── material_card.dart  → Card visualisasi kebutuhan material individual
│   └── summary_card.dart   → Card total estimasi biaya
└── screens/
    ├── home/
    │   └── home_screen.dart        → Dashboard utama menu grid kategori
    ├── calculator/
    │   └── calculator_screen.dart  → Form input dinamis sesuai kategori
    ├── result/
    │   └── result_screen.dart      → Visualisasi grafik, share, & ekspor PDF
    ├── history/
    │   └── history_screen.dart     → Riwayat kalkulasi tersimpan
    └── settings/
        └── settings_screen.dart    → Pengaturan harga satuan material custom
```

---

## ⚙️ Petunjuk Penggunaan Lokal

### Prasyarat
- Flutter SDK terbaru terinstal di sistem Anda.
- Android Emulator atau HP Android yang terhubung via ADB.

### Langkah-Langkah Run Proyek
1. Clone atau masuk ke direktori proyek:
   ```bash
   cd "Kalkulator Beton & Material"
   ```
2. Unduh paket dependensi:
   ```bash
   flutter pub get
   ```
3. Jalankan build_runner untuk generate adapter database Hive:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
4. Jalankan aplikasi pada perangkat yang terhubung:
   ```bash
   flutter run
   ```
5. Untuk menjalankan unit test formula kalkulasi:
   ```bash
   flutter test
   ```
