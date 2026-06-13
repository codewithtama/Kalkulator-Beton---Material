# Kalkulator Beton & Material — Agent Prompt

Build a Flutter Android app: **HitungBangun** — kalkulator kebutuhan material bangunan untuk user Indonesia.

## STACK
Provider, hive, fl_chart, pdf (printing), share_plus, intl

## STRUCTURE
```
lib/
├── core/           → constants.dart, theme.dart, formulas.dart
├── data/models/    → project.dart (Hive), calculation_result.dart
├── data/repos/     → project_repo.dart
├── providers/      → calculator_provider.dart, history_provider.dart
├── screens/        → home, calculator, result, history, settings
└── widgets/        → input_field, material_card, result_row, summary_card
```

## FITUR KALKULASI

### Beton (Campuran Manual)
Input: volume (m³), mutu beton (K-175 / K-225 / K-250 / K-300)
Output per m³ berdasarkan SNI:
- Semen (sak 50kg)
- Pasir (m³)
- Kerikil (m³)
- Air (liter)

Rasio campuran hardcode per mutu:
| Mutu | Semen | Pasir | Kerikil |
|------|-------|-------|---------|
| K-175 | 326kg | 760kg | 1029kg |
| K-225 | 371kg | 698kg | 1047kg |
| K-250 | 384kg | 692kg | 1039kg |
| K-300 | 413kg | 681kg | 1021kg |

### Pondasi
Input: panjang, lebar, kedalaman (meter)
Output: volume galian m³, kebutuhan beton, pasir urug

### Dinding Bata
Input: panjang x tinggi dinding (meter), jenis bata (merah / hebel)
Output: jumlah bata, semen, pasir (adukan 1:4)
- Bata merah: 70 bh/m²
- Hebel 10cm: 8.3 bh/m²

### Plester & Acian
Input: luas dinding (m²), ketebalan plester (cm)
Output: semen, pasir (1:4), semen acian (kg)

### Keramik Lantai
Input: panjang x lebar ruangan (m), ukuran keramik (30x30 / 40x40 / 60x60 / 80x80)
Output: jumlah keramik (pcs), semen, pasir, tambahan waste 10%

### Atap
Input: luas atap (m²), jenis (genteng tanah / metal / aspal)
Output: jumlah material, reng, usuk (estimasi)

### Cat Dinding
Input: luas dinding (m²), jumlah lapisan
Output: kebutuhan cat (liter), kaleng (5L / 25L)
Coverage default: 10 m²/liter

## FITUR APP

- **Home** — grid menu tiap kalkulasi, tombol riwayat
- **Calculator Screen** — form input per kategori, validasi realtime
- **Result Screen** — tabel material + estimasi harga (user input harga satuan manual), total biaya, tombol simpan & share
- **History** — list project tersimpan di Hive, tap untuk lihat ulang hasil
- **Export PDF** — generate ringkasan kalkulasi dengan package `pdf` + `printing`
- **Harga Satuan** — user bisa set harga material sendiri di Settings (semen/sak, pasir/m³, dll), disimpan ke Hive

## DESIGN
- Light theme default, warna aksen oranye/kuning (nuansa konstruksi)
- UI copy bahasa Indonesia
- Input menggunakan suffix unit (m, m², m³, kg)
- Hasil ditampilkan dalam card per material dengan icon

## BUILD ORDER
constants → formulas → theme → models → repo → providers → widgets → screens → pdf export
