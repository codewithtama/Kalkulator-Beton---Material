# Kalkulator Beton & Material — Agent Prompt [SELESAI]

Build a Flutter Android app: **HitungBangun** — kalkulator kebutuhan material bangunan untuk user Indonesia.

## [x] STACK
- [x] Provider
- [x] Hive & Hive Flutter
- [x] fl_chart
- [x] pdf (printing)
- [x] share_plus
- [x] intl

## [x] STRUCTURE
```
lib/
├── core/           → constants.dart, theme.dart, formulas.dart, pdf_helper.dart
├── data/models/    → project.dart (Hive), calculation_result.dart
├── data/repos/     → project_repo.dart
├── providers/      → calculator_provider.dart, history_provider.dart
├── screens/        → home_screen.dart, calculator_screen.dart, result_screen.dart, history_screen.dart, settings_screen.dart
└── widgets/        → input_field.dart, material_card.dart, summary_card.dart
```

## [x] FITUR KALKULASI

### [x] Beton (Campuran Manual)
Input: volume (m³), mutu beton (K-175 / K-225 / K-250 / K-300)
Output per m³ berdasarkan SNI:
- [x] Semen (sak 50kg)
- [x] Pasir (m³)
- [x] Kerikil (m³)
- [x] Air (liter)

Rasio campuran hardcode per mutu:
| Mutu | Semen | Pasir | Kerikil |
|------|-------|-------|---------|
| K-175 | 326kg | 760kg | 1029kg |
| K-225 | 371kg | 698kg | 1047kg |
| K-250 | 384kg | 692kg | 1039kg |
| K-300 | 413kg | 681kg | 1021kg |

### [x] Pondasi
Input: panjang, lebar, kedalaman (meter)
Output: volume galian m³, kebutuhan beton (semen, pasir, kerikil, air), pasir urug

### [x] Dinding Bata
Input: panjang x tinggi dinding (meter), jenis bata (merah / hebel)
Output: jumlah bata, semen, pasir (adukan 1:4)
- [x] Bata merah: 70 bh/m²
- [x] Hebel 10cm: 8.3 bh/m²

### [x] Plester & Acian
Input: luas dinding (m²), ketebalan plester (cm)
Output: semen, pasir (1:4), semen acian (kg)

### [x] Keramik Lantai
Input: panjang x lebar ruangan (m), ukuran keramik (30x30 / 40x40 / 60x60 / 80x80)
Output: jumlah keramik (pcs), semen, pasir, tambahan waste 10%

### [x] Atap
Input: luas atap (m²), jenis (genteng tanah / metal / aspal)
Output: jumlah material (genteng/sheet/shingle), reng, usuk (estimasi)

### [x] Cat Dinding
Input: luas dinding (m²), jumlah lapisan
Output: kebutuhan cat (liter), kaleng (5L / 25L)
- [x] Coverage default: 10 m²/liter

## [x] FITUR APP

- [x] **Home** — grid menu tiap kalkulasi, tombol riwayat
- [x] **Calculator Screen** — form input per kategori, validasi realtime
- [x] **Result Screen** — tabel material + estimasi harga (user input harga satuan manual), total biaya (visualisasi diagram fl_chart), tombol simpan & share
- [x] **History** — list project tersimpan di Hive, tap untuk lihat ulang hasil
- [x] **Export PDF** — generate ringkasan kalkulasi dengan package `pdf` + `printing`
- [x] **Harga Satuan** — user bisa set harga material sendiri di Settings (semen/sak, pasir/m³, dll), disimpan ke Hive

## [x] DESIGN
- [x] Light theme default, warna aksen oranye/kuning (nuansa konstruksi)
- [x] UI copy bahasa Indonesia
- [x] Input menggunakan suffix unit (m, m², m³, kg)
- [x] Hasil ditampilkan dalam card per material dengan icon
