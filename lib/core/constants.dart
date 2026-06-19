class BoxNames {
  static const String projects = 'projects_box';
  static const String settings = 'settings_box';
}

class SettingKeys {
  static const String materialPrices = 'material_prices';
}

enum CalculationCategory {
  beton,
  pondasi,
  dinding,
  plester,
  keramik,
  atap,
  cat,
  pondasiBatuKali,
  kolomBalok,
  bajaRingan,
  plafon,
  tangga,
  paving,
  partisiGypsum,
  pagarPanel,
  borePile,
  keramikDinding,
  waterproofing,
  begelSpiral,
  uruganSirtu,
}

extension CalculationCategoryExtension on CalculationCategory {
  String get nameIndo {
    switch (this) {
      case CalculationCategory.beton:
        return 'Beton (Campuran)';
      case CalculationCategory.pondasi:
        return 'Pondasi Beton';
      case CalculationCategory.dinding:
        return 'Dinding Bata';
      case CalculationCategory.plester:
        return 'Plester & Acian';
      case CalculationCategory.keramik:
        return 'Keramik Lantai';
      case CalculationCategory.atap:
        return 'Atap Kayu';
      case CalculationCategory.cat:
        return 'Cat Dinding';
      case CalculationCategory.pondasiBatuKali:
        return 'Pondasi Batu Kali';
      case CalculationCategory.kolomBalok:
        return 'Kolom & Balok';
      case CalculationCategory.bajaRingan:
        return 'Atap Baja Ringan';
      case CalculationCategory.plafon:
        return 'Plafon Gypsum';
      case CalculationCategory.tangga:
        return 'Tangga Beton';
      case CalculationCategory.paving:
        return 'Paving Block';
      case CalculationCategory.partisiGypsum:
        return 'Partisi Gypsum';
      case CalculationCategory.pagarPanel:
        return 'Pagar Panel Beton';
      case CalculationCategory.borePile:
        return 'Pondasi Bore Pile';
      case CalculationCategory.keramikDinding:
        return 'Keramik Dinding';
      case CalculationCategory.waterproofing:
        return 'Waterproofing Dak';
      case CalculationCategory.begelSpiral:
        return 'Begel Spiral';
      case CalculationCategory.uruganSirtu:
        return 'Urugan Sirtu';
    }
  }

  String get iconAsset {
    // We'll use Material Icons dynamically, but this is a helper string
    switch (this) {
      case CalculationCategory.beton:
        return 'water_drop';
      case CalculationCategory.pondasi:
        return 'layers';
      case CalculationCategory.dinding:
        return 'grid_on';
      case CalculationCategory.plester:
        return 'format_paint';
      case CalculationCategory.keramik:
        return 'dashboard';
      case CalculationCategory.atap:
        return 'home';
      case CalculationCategory.cat:
        return 'brush';
      case CalculationCategory.pondasiBatuKali:
        return 'foundation';
      case CalculationCategory.kolomBalok:
        return 'view_week';
      case CalculationCategory.bajaRingan:
        return 'architecture';
      case CalculationCategory.plafon:
        return 'border_all';
      case CalculationCategory.tangga:
        return 'reorder';
      case CalculationCategory.paving:
        return 'grid_view';
      case CalculationCategory.partisiGypsum:
        return 'view_day';
      case CalculationCategory.pagarPanel:
        return 'view_column';
      case CalculationCategory.borePile:
        return 'download';
      case CalculationCategory.keramikDinding:
        return 'border_outer';
      case CalculationCategory.waterproofing:
        return 'water';
      case CalculationCategory.begelSpiral:
        return 'refresh';
      case CalculationCategory.uruganSirtu:
        return 'landscape';
    }
  }
}

class MaterialDefaultPrices {
  // Prices in Rupiah (Rp)
  static const double semenSak = 75000.0;     // per sak (50 kg)
  static const double semenKg = 1500.0;       // per kg for general use
  static const double pasir = 280000.0;       // per m3
  static const double kerikil = 320000.0;     // per m3
  static const double air = 20.0;             // per liter
  static const double batuBelah = 350000.0;   // per m3
  
  static const double bataMerah = 1000.0;     // per bh
  static const double hebel = 12000.0;        // per bh (10 cm)
  
  static const double semenAcianSak = 90000.0; // per sak (40 kg)
  static const double semenAcianKg = 2250.0;   // per kg
  
  static const double keramik30x30 = 6000.0;   // per pc (~66.000 / dus isi 11)
  static const double keramik40x40 = 11000.0;  // per pc (~66.000 / dus isi 6)
  static const double keramik60x60 = 32500.0;  // per pc (~130.000 / dus isi 4)
  static const double keramik80x80 = 70000.0;  // per pc (~210.000 / dus isi 3)
  
  static const double gentengTanah = 3000.0;   // per bh
  static const double gentengMetal = 55000.0;  // per m2
  static const double gentengAspal = 140000.0; // per m2
  
  static const double usukWood = 35000.0;      // per batang
  static const double rengWood = 18000.0;      // per batang
  
  static const double catLiter = 45000.0;      // per liter (approx Rp 225k/5L)

  // New materials
  static const double besi6 = 35000.0;         // per batang 12m
  static const double besi8 = 55000.0;         // per batang 12m
  static const double besi10 = 85000.0;        // per batang 12m
  static const double besi12 = 115000.0;       // per batang 12m
  static const double besi16 = 190000.0;       // per batang 12m
  static const double kawatBendrat = 25000.0;  // per kg
  static const double plywood9mm = 120000.0;   // per lembar
  static const double paku = 20000.0;          // per kg
  static const double bajaC = 95000.0;         // per batang 6m
  static const double bajaReng = 45000.0;      // per batang 6m
  static const double sekrupTruss = 250.0;     // per pcs
  static const double sekrupGenteng = 350.0;   // per pcs

  // Plafon & Partisi Gypsum
  static const double gypsumBoard = 65000.0;     // per lembar (1.22 x 2.44 m)
  static const double hollow4x4 = 30000.0;       // per batang 4m
  static const double hollow2x4 = 22000.0;       // per batang 4m
  static const double sekrupPlafon = 150.0;      // per pcs
  static const double compoundGypsum = 8000.0;   // per kg
  static const double tapeGypsum = 20000.0;      // per roll
  
  // Paving Block
  static const double pavingBlock = 1500.0;      // per pcs
  static const double kanstin = 25000.0;         // per pcs
  
  // Partisi Dinding Gypsum
  static const double metalStud = 35000.0;       // per batang 3m
  static const double runner = 32000.0;          // per batang 3m
  
  // Pagar Panel Precast
  static const double daunPanel = 125000.0;      // per pcs
  static const double tiangKolomPrecast = 250000.0; // per pcs
  
  // Keramik Dinding
  static const double keramikDinding = 85000.0;  // per dus (~Rp 85rb/m2)
  static const double semenInstan = 95000.0;     // per sak 40kg
  static const double semenNat = 15000.0;        // per kg
  
  // Waterproofing
  static const double waterproofingLiquid = 55000.0; // per kg
  
  // Sirtu
  static const double sirtu = 260000.0;          // per m3
}
