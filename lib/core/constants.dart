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
  // 20 New Categories
  cakarAyam,
  floordeck,
  platSlab,
  cutFill,
  retainingWall,
  septicTank,
  batako,
  glassBlock,
  kusenAluminium,
  floorScreed,
  pondasiSumuran,
  plafonPvc,
  plintLantai,
  kusenKayu,
  bakKontrol,
  grassBlock,
  kanopi,
  railing,
  bajaWf,
  plumbing,
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
      // 20 New Categories
      case CalculationCategory.cakarAyam:
        return 'Pondasi Cakar Ayam';
      case CalculationCategory.floordeck:
        return 'Plat Floor Deck';
      case CalculationCategory.platSlab:
        return 'Plat Slab Beton';
      case CalculationCategory.cutFill:
        return 'Urugan & Pemadatan';
      case CalculationCategory.retainingWall:
        return 'Dinding Penahan Tanah';
      case CalculationCategory.septicTank:
        return 'Septic Tank & Resapan';
      case CalculationCategory.batako:
        return 'Dinding Batako';
      case CalculationCategory.glassBlock:
        return 'Dinding Glass Block';
      case CalculationCategory.kusenAluminium:
        return 'Kusen Aluminium';
      case CalculationCategory.floorScreed:
        return 'Plesteran Screed';
      case CalculationCategory.pondasiSumuran:
        return 'Pondasi Sumuran';
      case CalculationCategory.plafonPvc:
        return 'Plafon PVC';
      case CalculationCategory.plintLantai:
        return 'Plint Keramik';
      case CalculationCategory.kusenKayu:
        return 'Kusen Pintu Kayu';
      case CalculationCategory.bakKontrol:
        return 'Bak Kontrol Air';
      case CalculationCategory.grassBlock:
        return 'Grass Block';
      case CalculationCategory.kanopi:
        return 'Kanopi Minimalis';
      case CalculationCategory.railing:
        return 'Railing Logam';
      case CalculationCategory.bajaWf:
        return 'Struktur Baja WF';
      case CalculationCategory.plumbing:
        return 'Instalasi Pipa Air';
    }
  }

  String get iconAsset {
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
      // 20 New Categories
      case CalculationCategory.cakarAyam:
        return 'grid_3x3';
      case CalculationCategory.floordeck:
        return 'view_quilt';
      case CalculationCategory.platSlab:
        return 'table_rows';
      case CalculationCategory.cutFill:
        return 'align_vertical_bottom';
      case CalculationCategory.retainingWall:
        return 'reorder';
      case CalculationCategory.septicTank:
        return 'waves';
      case CalculationCategory.batako:
        return 'view_in_ar';
      case CalculationCategory.glassBlock:
        return 'widgets';
      case CalculationCategory.kusenAluminium:
        return 'crop_square';
      case CalculationCategory.floorScreed:
        return 'line_style';
      case CalculationCategory.pondasiSumuran:
        return 'adjust';
      case CalculationCategory.plafonPvc:
        return 'border_style';
      case CalculationCategory.plintLantai:
        return 'border_bottom';
      case CalculationCategory.kusenKayu:
        return 'meeting_room';
      case CalculationCategory.bakKontrol:
        return 'inbox';
      case CalculationCategory.grassBlock:
        return 'eco';
      case CalculationCategory.kanopi:
        return 'umbrella';
      case CalculationCategory.railing:
        return 'fence';
      case CalculationCategory.bajaWf:
        return 'view_headline';
      case CalculationCategory.plumbing:
        return 'plumbing';
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

  // Iron & Framework
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

  // New materials for 20 new calculators
  static const double bondex = 90000.0;         // per meter
  static const double wiremeshM6 = 380000.0;     // per lembar
  static const double wiremeshM8 = 550000.0;     // per lembar
  static const double wiremeshM10 = 850000.0;    // per lembar
  static const double tanahUrug = 180000.0;      // per m3
  static const double batako = 3500.0;           // per bh
  static const double glassBlock = 22000.0;      // per bh
  static const double kusenAluminium = 120000.0; // per batang 6m
  static const double sealant = 35000.0;         // per tube
  static const double buisBeton = 175000.0;      // per unit 80cm
  static const double plafonPvc = 25000.0;       // per m1
  static const double lisPvc = 15000.0;          // per m1
  static const double plintKeramik = 12000.0;    // per pcs
  static const double balokKayu = 4500000.0;     // per m3
  static const double lemKayu = 3000.0;          // per kg (wood glue)
  static const double platChecker = 350000.0;    // per pcs
  static const double grassBlock = 22000.0;      // per pcs
  static const double polycarbonate = 150000.0;  // per m2
  static const double spandek = 75000.0;         // per m2
  static const double pipaStainless = 180000.0;  // per batang 6m
  static const double bajaWf = 16000.0;          // per kg (steel beam weight rate)
  static const double bajaWf150 = 2688000.0;     // per batang 12m (14kg/m * 12m * 16000)
  static const double bajaWf200 = 4089600.0;     // per batang 12m (21.3kg/m * 12m * 16000)
  static const double bajaWf250 = 5683200.0;     // per batang 12m (29.6kg/m * 12m * 16000)
  static const double catAntiKarat = 65000.0;    // per kg
  static const double pipaPvcAW = 45000.0;       // per batang 4m
  static const double pipaPvcD = 95000.0;        // per batang 4m
  static const double fittingPvc = 8000.0;       // per pcs
  static const double lemPipa = 15000.0;         // per tube
  static const double sealTape = 5000.0;         // per roll
}
