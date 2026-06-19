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
}
