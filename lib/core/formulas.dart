import 'dart:math' as math;
import '../data/models/calculation_result.dart';
import 'constants.dart';

class Formulas {
  // Conversions
  static const double sandDensity = 1400.0;    // kg/m3
  static const double gravelDensity = 1350.0;  // kg/m3

  /// 1. Beton (Campuran Manual)
  /// Mutu K-175: 326kg Semen, 760kg Pasir, 1029kg Kerikil, 215L Air
  /// Mutu K-225: 371kg Semen, 698kg Pasir, 1047kg Kerikil, 215L Air
  /// Mutu K-250: 384kg Semen, 692kg Pasir, 1039kg Kerikil, 215L Air
  /// Mutu K-300: 413kg Semen, 681kg Pasir, 1021kg Kerikil, 215L Air
  static CalculationResult calculateBeton({
    required double volume,
    required String mutu,
    required Map<String, double> prices,
  }) {
    double semenPerM3 = 0.0;
    double pasirPerM3 = 0.0;
    double kerikilPerM3 = 0.0;
    const double airPerM3 = 215.0; // Liters

    switch (mutu) {
      case 'K-175':
        semenPerM3 = 326.0;
        pasirPerM3 = 760.0;
        kerikilPerM3 = 1029.0;
        break;
      case 'K-225':
        semenPerM3 = 371.0;
        pasirPerM3 = 698.0;
        kerikilPerM3 = 1047.0;
        break;
      case 'K-250':
        semenPerM3 = 384.0;
        pasirPerM3 = 692.0;
        kerikilPerM3 = 1039.0;
        break;
      case 'K-300':
        semenPerM3 = 413.0;
        pasirPerM3 = 681.0;
        kerikilPerM3 = 1021.0;
        break;
      default:
        semenPerM3 = 326.0;
        pasirPerM3 = 760.0;
        kerikilPerM3 = 1029.0;
    }

    final semenSak = (semenPerM3 * volume) / 50.0; // 50kg bag
    final pasirM3 = (pasirPerM3 * volume) / sandDensity;
    final kerikilM3 = (kerikilPerM3 * volume) / gravelDensity;
    final airLiters = airPerM3 * volume;

    final semenPrice = prices['semen_sak'] ?? MaterialDefaultPrices.semenSak;
    final pasirPrice = prices['pasir'] ?? MaterialDefaultPrices.pasir;
    final kerikilPrice = prices['kerikil'] ?? MaterialDefaultPrices.kerikil;
    final airPrice = prices['air'] ?? MaterialDefaultPrices.air;

    return CalculationResult(
      requirements: [
        MaterialRequirement(
          key: 'semen_sak',
          name: 'Semen (Sak 50kg)',
          quantity: double.parse(semenSak.toStringAsFixed(2)),
          unit: 'sak',
          unitPrice: semenPrice,
        ),
        MaterialRequirement(
          key: 'pasir',
          name: 'Pasir Beton',
          quantity: double.parse(pasirM3.toStringAsFixed(2)),
          unit: 'm³',
          unitPrice: pasirPrice,
        ),
        MaterialRequirement(
          key: 'kerikil',
          name: 'Kerikil Beton',
          quantity: double.parse(kerikilM3.toStringAsFixed(2)),
          unit: 'm³',
          unitPrice: kerikilPrice,
        ),
        MaterialRequirement(
          key: 'air',
          name: 'Air',
          quantity: double.parse(airLiters.toStringAsFixed(1)),
          unit: 'liter',
          unitPrice: airPrice,
        ),
      ],
    );
  }

  /// 2. Pondasi
  /// Input: panjang, lebar, kedalaman (meter)
  /// Output: volume galian m3, kebutuhan beton m3 (broken down to materials), pasir urug m3
  static CalculationResult calculatePondasi({
    required double panjang,
    required double lebar,
    required double kedalaman,
    required Map<String, double> prices,
  }) {
    final volumeGalian = panjang * lebar * kedalaman;
    
    // Assume 5 cm of sand bed (pasir urug) at the bottom
    const tebalPasirUrug = 0.05;
    final volumePasirUrug = panjang * lebar * tebalPasirUrug;
    
    // Remaining height is for the concrete structure
    final tinggiBeton = math.max(0.0, kedalaman - tebalPasirUrug);
    final volumeBeton = panjang * lebar * tinggiBeton;

    // Estimate using K-175 for foundation concrete
    const semenPerM3 = 326.0;
    const pasirPerM3 = 760.0;
    const kerikilPerM3 = 1029.0;
    const airPerM3 = 215.0;

    final semenSak = (semenPerM3 * volumeBeton) / 50.0;
    final pasirBetonM3 = (pasirPerM3 * volumeBeton) / sandDensity;
    final kerikilM3 = (kerikilPerM3 * volumeBeton) / gravelDensity;
    final airLiters = airPerM3 * volumeBeton;

    final semenPrice = prices['semen_sak'] ?? MaterialDefaultPrices.semenSak;
    final pasirPrice = prices['pasir'] ?? MaterialDefaultPrices.pasir;
    final kerikilPrice = prices['kerikil'] ?? MaterialDefaultPrices.kerikil;
    final airPrice = prices['air'] ?? MaterialDefaultPrices.air;
    final pasirUrugPrice = prices['pasir'] ?? MaterialDefaultPrices.pasir;

    return CalculationResult(
      requirements: [
        MaterialRequirement(
          key: 'galian',
          name: 'Volume Galian',
          quantity: double.parse(volumeGalian.toStringAsFixed(2)),
          unit: 'm³',
          unitPrice: 0.0, // Excavation is volume indicator, no purchase material
        ),
        MaterialRequirement(
          key: 'pasir_urug',
          name: 'Pasir Urug (Tebal 5cm)',
          quantity: double.parse(volumePasirUrug.toStringAsFixed(2)),
          unit: 'm³',
          unitPrice: pasirUrugPrice,
        ),
        MaterialRequirement(
          key: 'semen_sak',
          name: 'Semen (Sak 50kg) untuk Beton',
          quantity: double.parse(semenSak.toStringAsFixed(2)),
          unit: 'sak',
          unitPrice: semenPrice,
        ),
        MaterialRequirement(
          key: 'pasir',
          name: 'Pasir Beton',
          quantity: double.parse(pasirBetonM3.toStringAsFixed(2)),
          unit: 'm³',
          unitPrice: pasirPrice,
        ),
        MaterialRequirement(
          key: 'kerikil',
          name: 'Kerikil Beton',
          quantity: double.parse(kerikilM3.toStringAsFixed(2)),
          unit: 'm³',
          unitPrice: kerikilPrice,
        ),
        MaterialRequirement(
          key: 'air',
          name: 'Air',
          quantity: double.parse(airLiters.toStringAsFixed(1)),
          unit: 'liter',
          unitPrice: airPrice,
        ),
      ],
    );
  }

  /// 3. Dinding Bata
  /// Input: panjang x tinggi dinding (meter), jenis bata (merah / hebel)
  /// Output: jumlah bata, semen, pasir (adukan 1:4)
  /// - Bata merah: 70 bh/m2
  /// - Hebel 10cm: 8.3 bh/m2
  static CalculationResult calculateDinding({
    required double panjang,
    required double tinggi,
    required String jenisBata,
    required Map<String, double> prices,
  }) {
    final luas = panjang * tinggi;
    double jumlahBata = 0.0;
    double semenSak = 0.0;
    double pasirM3 = 0.0;
    String bataKey = 'bata_merah';
    String bataName = 'Bata Merah';
    double bataPrice = prices['bata_merah'] ?? MaterialDefaultPrices.bataMerah;

    if (jenisBata.toLowerCase() == 'hebel') {
      bataKey = 'hebel';
      bataName = 'Bata Ringan (Hebel) 10cm';
      bataPrice = prices['hebel'] ?? MaterialDefaultPrices.hebel;
      jumlahBata = luas * 8.3;
      // Mortar (semen instan) for hebel: 4 kg per m2. No sand.
      semenSak = (luas * 4.0) / 40.0; // Semen instan is typically 40kg/sak
    } else {
      jumlahBata = luas * 70.0;
      // Adukan 1:4 (Bata merah): Semen 11.5 kg/m2, Pasir 0.043 m3/m2
      semenSak = (luas * 11.5) / 50.0; // 50kg bag
      pasirM3 = luas * 0.043;
    }

    final semenPrice = jenisBata.toLowerCase() == 'hebel'
        ? (prices['semen_acian_sak'] ?? MaterialDefaultPrices.semenAcianSak) // Semen instan price
        : (prices['semen_sak'] ?? MaterialDefaultPrices.semenSak);
    final pasirPrice = prices['pasir'] ?? MaterialDefaultPrices.pasir;

    final requirements = <MaterialRequirement>[
      MaterialRequirement(
        key: bataKey,
        name: bataName,
        quantity: double.parse(jumlahBata.toStringAsFixed(0)),
        unit: 'bh',
        unitPrice: bataPrice,
      ),
      MaterialRequirement(
        key: jenisBata.toLowerCase() == 'hebel' ? 'semen_acian_sak' : 'semen_sak',
        name: jenisBata.toLowerCase() == 'hebel' ? 'Semen Instan (Sak 40kg)' : 'Semen (Sak 50kg)',
        quantity: double.parse(semenSak.toStringAsFixed(2)),
        unit: 'sak',
        unitPrice: semenPrice,
      ),
    ];

    if (jenisBata.toLowerCase() != 'hebel') {
      requirements.add(
        MaterialRequirement(
          key: 'pasir',
          name: 'Pasir Pasang',
          quantity: double.parse(pasirM3.toStringAsFixed(2)),
          unit: 'm³',
          unitPrice: pasirPrice,
        ),
      );
    }

    return CalculationResult(requirements: requirements);
  }

  /// 4. Plester & Acian
  /// Input: luas dinding (m2), ketebalan plester (cm)
  /// Output: semen, pasir (1:4), semen acian (kg)
  /// - Plester (1cm): Semen 4.16 kg/m2, Pasir 0.016 m3/m2 per cm of thickness
  /// - Acian: Semen Acian 3.25 kg/m2
  static CalculationResult calculatePlesterAcian({
    required double luas,
    required double tebalPlester,
    required Map<String, double> prices,
  }) {
    final semenPlesterKg = luas * 4.16 * tebalPlester;
    final pasirPlesterM3 = luas * 0.016 * tebalPlester;
    final semenAcianKg = luas * 3.25;

    final semenPlesterSak = semenPlesterKg / 50.0; // General cement in 50kg sak
    final semenAcianSak = semenAcianKg / 40.0;   // Acian cement in 40kg sak

    final semenPrice = prices['semen_sak'] ?? MaterialDefaultPrices.semenSak;
    final pasirPrice = prices['pasir'] ?? MaterialDefaultPrices.pasir;
    final acianPrice = prices['semen_acian_sak'] ?? MaterialDefaultPrices.semenAcianSak;

    return CalculationResult(
      requirements: [
        MaterialRequirement(
          key: 'semen_sak',
          name: 'Semen Plester (Sak 50kg)',
          quantity: double.parse(semenPlesterSak.toStringAsFixed(2)),
          unit: 'sak',
          unitPrice: semenPrice,
        ),
        MaterialRequirement(
          key: 'pasir',
          name: 'Pasir Plester',
          quantity: double.parse(pasirPlesterM3.toStringAsFixed(2)),
          unit: 'm³',
          unitPrice: pasirPrice,
        ),
        MaterialRequirement(
          key: 'semen_acian_sak',
          name: 'Semen Acian (Sak 40kg)',
          quantity: double.parse(semenAcianSak.toStringAsFixed(2)),
          unit: 'sak',
          unitPrice: acianPrice,
        ),
      ],
    );
  }

  /// 5. Keramik Lantai
  /// Input: panjang x lebar ruangan (m), ukuran keramik (30x30 / 40x40 / 60x60 / 80x80)
  /// Output: jumlah keramik (pcs), semen, pasir, tambahan waste 10%
  /// - Semen pasang keramik: 10 kg/m2
  /// - Pasir pasang: 0.045 m3/m2
  static CalculationResult calculateKeramik({
    required double panjang,
    required double lebar,
    required String ukuran,
    required Map<String, double> prices,
  }) {
    final luas = panjang * lebar;
    final luasDenganWaste = luas * 1.1; // 10% waste

    double pcArea = 0.09; // Default 30x30
    String sizeKey = 'keramik_30';
    String sizeName = 'Keramik 30x30 cm';
    double tilePrice = prices['keramik_30'] ?? MaterialDefaultPrices.keramik30x30;

    switch (ukuran) {
      case '30x30':
        pcArea = 0.09;
        sizeKey = 'keramik_30';
        sizeName = 'Keramik 30x30 cm';
        tilePrice = prices['keramik_30'] ?? MaterialDefaultPrices.keramik30x30;
        break;
      case '40x40':
        pcArea = 0.16;
        sizeKey = 'keramik_40';
        sizeName = 'Keramik 40x40 cm';
        tilePrice = prices['keramik_40'] ?? MaterialDefaultPrices.keramik40x40;
        break;
      case '60x60':
        pcArea = 0.36;
        sizeKey = 'keramik_60';
        sizeName = 'Keramik 60x60 cm';
        tilePrice = prices['keramik_60'] ?? MaterialDefaultPrices.keramik60x60;
        break;
      case '80x80':
        pcArea = 0.64;
        sizeKey = 'keramik_80';
        sizeName = 'Keramik 80x80 cm';
        tilePrice = prices['keramik_80'] ?? MaterialDefaultPrices.keramik80x80;
        break;
    }

    final totalPcs = (luasDenganWaste / pcArea).ceilToDouble();
    final semenSak = (luas * 10.0) / 50.0;
    final pasirM3 = luas * 0.045;

    final semenPrice = prices['semen_sak'] ?? MaterialDefaultPrices.semenSak;
    final pasirPrice = prices['pasir'] ?? MaterialDefaultPrices.pasir;

    return CalculationResult(
      requirements: [
        MaterialRequirement(
          key: sizeKey,
          name: sizeName,
          quantity: totalPcs,
          unit: 'pcs',
          unitPrice: tilePrice,
        ),
        MaterialRequirement(
          key: 'semen_sak',
          name: 'Semen Pasang (Sak 50kg)',
          quantity: double.parse(semenSak.toStringAsFixed(2)),
          unit: 'sak',
          unitPrice: semenPrice,
        ),
        MaterialRequirement(
          key: 'pasir',
          name: 'Pasir Pasang',
          quantity: double.parse(pasirM3.toStringAsFixed(2)),
          unit: 'm³',
          unitPrice: pasirPrice,
        ),
      ],
    );
  }

  /// 6. Atap
  /// Input: luas atap (m2), jenis (genteng tanah / metal / aspal)
  /// Output: jumlah material, reng, usuk (estimasi)
  /// - Genteng tanah: 25 bh/m2
  /// - Genteng metal: 1.6 m2/sheet -> 1.6 sheets/m2
  /// - Genteng aspal: 1.05 m2/m2
  /// - Usuk: 4m length, standard framing (approx 2.5m per m2 for clay tile, 2m for metal/asphalt)
  /// - Reng: 4m length, standard spacing (approx 3.5m per m2 for clay tile, 2.5m for metal, 1.5m for asphalt)
  static CalculationResult calculateAtap({
    required double luas,
    required String jenisGenteng,
    required Map<String, double> prices,
  }) {
    double gentengQty = 0.0;
    String gentengUnit = 'bh';
    String gentengKey = 'genteng_tanah';
    String gentengName = 'Genteng Tanah Liat';
    double gentengPrice = prices['genteng_tanah'] ?? MaterialDefaultPrices.gentengTanah;

    double usukFactor = 2.5;
    double rengFactor = 3.5;

    if (jenisGenteng.toLowerCase() == 'metal') {
      gentengKey = 'genteng_metal';
      gentengName = 'Genteng Metal Sheet';
      gentengPrice = prices['genteng_metal'] ?? MaterialDefaultPrices.gentengMetal;
      gentengUnit = 'm²';
      gentengQty = luas * 1.05; // 5% overlap
      usukFactor = 2.0;
      rengFactor = 2.5;
    } else if (jenisGenteng.toLowerCase() == 'aspal') {
      gentengKey = 'genteng_aspal';
      gentengName = 'Genteng Aspal (Shingle)';
      gentengPrice = prices['genteng_aspal'] ?? MaterialDefaultPrices.gentengAspal;
      gentengUnit = 'm²';
      gentengQty = luas * 1.05;
      usukFactor = 2.0;
      rengFactor = 1.5; // less reng, but needs plywood sheet backing
    } else {
      gentengQty = luas * 25.0; // 25 pieces per m2
    }

    final usukMeters = luas * usukFactor;
    final rengMeters = luas * rengFactor;

    // Convert length to standard 4m lumber poles
    final usukBatang = (usukMeters / 4.0).ceilToDouble();
    final rengBatang = (rengMeters / 4.0).ceilToDouble();

    final usukPrice = prices['kayu_usuk'] ?? MaterialDefaultPrices.usukWood;
    final rengPrice = prices['kayu_reng'] ?? MaterialDefaultPrices.rengWood;

    final requirements = <MaterialRequirement>[
      MaterialRequirement(
        key: gentengKey,
        name: gentengName,
        quantity: gentengQty,
        unit: gentengUnit,
        unitPrice: gentengPrice,
      ),
      MaterialRequirement(
        key: 'kayu_usuk',
        name: 'Kayu Usuk 5x7 (Batang 4m)',
        quantity: usukBatang,
        unit: 'batang',
        unitPrice: usukPrice,
      ),
      MaterialRequirement(
        key: 'kayu_reng',
        name: 'Kayu Reng 2x3 (Batang 4m)',
        quantity: rengBatang,
        unit: 'batang',
        unitPrice: rengPrice,
      ),
    ];

    // Asphalt shingles require plywood underlayment (1.22 x 2.44 m = 2.97 m2)
    if (jenisGenteng.toLowerCase() == 'aspal') {
      final plywoodPrice = 125000.0; // Estimate multiplex price
      final plywoodQty = (luas / 2.97).ceilToDouble();
      requirements.add(
        MaterialRequirement(
          key: 'plywood',
          name: 'Multiplex 9mm (1.22x2.44m) Alas',
          quantity: plywoodQty,
          unit: 'lembar',
          unitPrice: plywoodPrice,
        ),
      );
    }

    return CalculationResult(requirements: requirements);
  }

  /// 7. Cat Dinding
  /// Input: luas dinding (m2), jumlah lapisan
  /// Output: kebutuhan cat (liter), kaleng (5L / 25L)
  /// Coverage default: 10 m2/liter
  static CalculationResult calculateCat({
    required double luas,
    required int lapisan,
    required Map<String, double> prices,
  }) {
    final totalLuas = luas * lapisan;
    final totalLiter = totalLuas / 10.0;

    final catPriceLiter = prices['cat_liter'] ?? MaterialDefaultPrices.catLiter;

    // We can list paint in Liters, but estimate how many 5L or 25L cans are needed
    final cans5L = (totalLiter / 5.0).ceilToDouble();
    final cans25L = (totalLiter / 25.0).ceilToDouble();

    return CalculationResult(
      requirements: [
        MaterialRequirement(
          key: 'cat_liter',
          name: 'Cat Dinding (Total Volume)',
          quantity: double.parse(totalLiter.toStringAsFixed(1)),
          unit: 'liter',
          unitPrice: catPriceLiter,
        ),
        MaterialRequirement(
          key: 'cat_5l',
          name: 'Estimasi Kemasan Galon (5L)',
          quantity: cans5L,
          unit: 'galon',
          unitPrice: catPriceLiter * 5,
        ),
        MaterialRequirement(
          key: 'cat_25l',
          name: 'Estimasi Kemasan Pail (25L)',
          quantity: cans25L,
          unit: 'pail',
          unitPrice: catPriceLiter * 25,
        ),
      ],
    );
  }

  /// 8. Pondasi Batu Kali (Trapesoid)
  /// Input: panjang, lebar atas, lebar bawah, tinggi (meter)
  /// Adukan: '1:3', '1:4', '1:5', '1:6'
  static CalculationResult calculatePondasiBatuKali({
    required double panjang,
    required double lebarAtas,
    required double lebarBawah,
    required double tinggi,
    required String adukan,
    required Map<String, double> prices,
  }) {
    final volumeGalian = panjang * lebarBawah * tinggi;
    
    // Pasir urug tebal 5cm di bawah pondasi
    final volumePasirUrug = panjang * lebarBawah * 0.05;
    
    // Volume Pondasi (Trapesium)
    final volumePondasi = panjang * ((lebarAtas + lebarBawah) / 2) * tinggi;
    
    // Koefisien SNI per m3 pondasi batu kali:
    // Batu Belah: 1.2 m3
    // Semen Portland (kg):
    // - 1:3 = 202 kg
    // - 1:4 = 163 kg
    // - 1:5 = 136 kg
    // - 1:6 = 117 kg
    // Pasir Pasang (m3):
    // - 1:3 = 0.485 m3
    // - 1:4 = 0.520 m3
    // - 1:5 = 0.544 m3
    // - 1:6 = 0.561 m3
    double cementCoeff = 163.0; // Default 1:4
    double sandCoeff = 0.520;   // Default 1:4

    switch (adukan) {
      case '1:3':
        cementCoeff = 202.0;
        sandCoeff = 0.485;
        break;
      case '1:4':
        cementCoeff = 163.0;
        sandCoeff = 0.520;
        break;
      case '1:5':
        cementCoeff = 136.0;
        sandCoeff = 0.544;
        break;
      case '1:6':
        cementCoeff = 117.0;
        sandCoeff = 0.561;
        break;
    }

    final batuBelahM3 = 1.2 * volumePondasi;
    final semenSak = (cementCoeff * volumePondasi) / 50.0; // 50kg bag
    final pasirPondasiM3 = sandCoeff * volumePondasi;

    final batuPrice = prices['batu_belah'] ?? MaterialDefaultPrices.batuBelah;
    final semenPrice = prices['semen_sak'] ?? MaterialDefaultPrices.semenSak;
    final pasirPrice = prices['pasir'] ?? MaterialDefaultPrices.pasir;

    return CalculationResult(
      requirements: [
        MaterialRequirement(
          key: 'galian',
          name: 'Volume Galian Tanah',
          quantity: double.parse(volumeGalian.toStringAsFixed(2)),
          unit: 'm³',
          unitPrice: 0.0,
        ),
        MaterialRequirement(
          key: 'pasir_urug',
          name: 'Pasir Urug Bawah Pondasi (Tebal 5cm)',
          quantity: double.parse(volumePasirUrug.toStringAsFixed(2)),
          unit: 'm³',
          unitPrice: pasirPrice,
        ),
        MaterialRequirement(
          key: 'batu_belah',
          name: 'Batu Belah / Batu Kali',
          quantity: double.parse(batuBelahM3.toStringAsFixed(2)),
          unit: 'm³',
          unitPrice: batuPrice,
        ),
        MaterialRequirement(
          key: 'semen_sak',
          name: 'Semen Portland (Adukan $adukan)',
          quantity: double.parse(semenSak.toStringAsFixed(2)),
          unit: 'sak',
          unitPrice: semenPrice,
        ),
        MaterialRequirement(
          key: 'pasir',
          name: 'Pasir Pasang (Adukan $adukan)',
          quantity: double.parse(pasirPondasiM3.toStringAsFixed(2)),
          unit: 'm³',
          unitPrice: pasirPrice,
        ),
      ],
    );
  }

  /// 9. Kolom & Balok (Struktur Beton Bertulang)
  /// Input: panjang total (m), lebar penampang (cm), tinggi penampang (cm)
  /// Besi Utama: diameter (8, 10, 12, 16 mm), jumlah (4, 6 batang)
  /// Besi Begel: diameter (6, 8 mm), jarak (10, 15, 20 cm)
  /// Bekisting: bool
  /// Mutu Beton: K-175, K-225, K-250, K-300
  static CalculationResult calculateKolomBalok({
    required double panjang,
    required double lebarCm,
    required double tinggiCm,
    required int diameterUtama,
    required int jumlahUtama,
    required int diameterBegel,
    required double jarakBegelCm,
    required bool bekisting,
    required String mutuBeton,
    required Map<String, double> prices,
  }) {
    final lebarM = lebarCm / 100.0;
    final tinggiM = tinggiCm / 100.0;
    final volumeBeton = panjang * lebarM * tinggiM;

    // 1. Concrete ingredients using concrete mix logic
    double semenPerM3 = 371.0; // K-225 default
    double pasirPerM3 = 698.0;
    double kerikilPerM3 = 1047.0;
    const double airPerM3 = 215.0;

    switch (mutuBeton) {
      case 'K-175':
        semenPerM3 = 326.0;
        pasirPerM3 = 760.0;
        kerikilPerM3 = 1029.0;
        break;
      case 'K-225':
        semenPerM3 = 371.0;
        pasirPerM3 = 698.0;
        kerikilPerM3 = 1047.0;
        break;
      case 'K-250':
        semenPerM3 = 384.0;
        pasirPerM3 = 692.0;
        kerikilPerM3 = 1039.0;
        break;
      case 'K-300':
        semenPerM3 = 413.0;
        pasirPerM3 = 681.0;
        kerikilPerM3 = 1021.0;
        break;
    }

    final semenSak = (semenPerM3 * volumeBeton) / 50.0;
    final pasirM3 = (pasirPerM3 * volumeBeton) / sandDensity;
    final kerikilM3 = (kerikilPerM3 * volumeBeton) / gravelDensity;
    final airLiters = airPerM3 * volumeBeton;

    // 2. Reinforcement steel (Pembesian)
    final weightUtamaPerMeter = 0.006165 * diameterUtama * diameterUtama;
    final totalPanjangUtama = panjang * jumlahUtama;
    final totalWeightUtama = totalPanjangUtama * weightUtamaPerMeter;
    final batangUtama = (totalPanjangUtama / 12.0).ceilToDouble(); // 12m standard length

    // Sengkang/Begel
    final lebarBegelCm = math.max(2.0, lebarCm - 4.0);
    final tinggiBegelCm = math.max(2.0, tinggiCm - 4.0);
    final panjangSatuBegelM = ((2.0 * (lebarBegelCm + tinggiBegelCm)) + 10.0) / 100.0;
    final jumlahBegel = ((panjang * 100.0) / jarakBegelCm).ceil() + 1;
    final totalPanjangBegel = jumlahBegel * panjangSatuBegelM;
    final weightBegelPerMeter = 0.006165 * diameterBegel * diameterBegel;
    final totalWeightBegel = totalPanjangBegel * weightBegelPerMeter;
    final batangBegel = (totalPanjangBegel / 12.0).ceilToDouble();

    // Wire tie (Kawat bendrat): 1.5% of total steel weight
    final kawatBendratKg = (totalWeightUtama + totalWeightBegel) * 0.015;

    // Prices mapping
    final semenPrice = prices['semen_sak'] ?? MaterialDefaultPrices.semenSak;
    final pasirPrice = prices['pasir'] ?? MaterialDefaultPrices.pasir;
    final kerikilPrice = prices['kerikil'] ?? MaterialDefaultPrices.kerikil;
    final airPrice = prices['air'] ?? MaterialDefaultPrices.air;
    
    final priceKeyUtama = 'besi_$diameterUtama';
    final priceKeyBegel = 'besi_$diameterBegel';
    
    final besiUtamaPrice = prices[priceKeyUtama] ?? _getDefaultBesiPrice(diameterUtama);
    final besiBegelPrice = prices[priceKeyBegel] ?? _getDefaultBesiPrice(diameterBegel);
    final kawatPrice = prices['kawat_bendrat'] ?? MaterialDefaultPrices.kawatBendrat;

    final requirements = <MaterialRequirement>[
      MaterialRequirement(
        key: 'semen_sak',
        name: 'Semen Portland (Beton $mutuBeton)',
        quantity: double.parse(semenSak.toStringAsFixed(2)),
        unit: 'sak',
        unitPrice: semenPrice,
      ),
      MaterialRequirement(
        key: 'pasir',
        name: 'Pasir Beton',
        quantity: double.parse(pasirM3.toStringAsFixed(2)),
        unit: 'm³',
        unitPrice: pasirPrice,
      ),
      MaterialRequirement(
        key: 'kerikil',
        name: 'Kerikil / Batu Pecah',
        quantity: double.parse(kerikilM3.toStringAsFixed(2)),
        unit: 'm³',
        unitPrice: kerikilPrice,
      ),
      MaterialRequirement(
        key: 'air',
        name: 'Air',
        quantity: double.parse(airLiters.toStringAsFixed(1)),
        unit: 'liter',
        unitPrice: airPrice,
      ),
      MaterialRequirement(
        key: priceKeyUtama,
        name: 'Besi Beton Utama Ø$diameterUtama mm (Batang 12m)',
        quantity: batangUtama,
        unit: 'batang',
        unitPrice: besiUtamaPrice,
      ),
      MaterialRequirement(
        key: priceKeyBegel,
        name: 'Besi Begel / Sengkang Ø$diameterBegel mm (Batang 12m)',
        quantity: batangBegel,
        unit: 'batang',
        unitPrice: besiBegelPrice,
      ),
      MaterialRequirement(
        key: 'kawat_bendrat',
        name: 'Kawat Beton (Bendrat)',
        quantity: double.parse(kawatBendratKg.toStringAsFixed(2)),
        unit: 'kg',
        unitPrice: kawatPrice,
      ),
    ];

    // 3. Bekisting (Formwork)
    if (bekisting) {
      final luasBekisting = (2.0 * (lebarM + tinggiM)) * panjang;
      
      final plywoodQty = (luasBekisting * 0.35).ceilToDouble();
      final kasoQty = (luasBekisting * 0.5).ceilToDouble();
      final pakuQty = luasBekisting * 0.3;

      final plywoodPrice = prices['plywood_9mm'] ?? MaterialDefaultPrices.plywood9mm;
      final kasoPrice = prices['kayu_usuk'] ?? MaterialDefaultPrices.usukWood;
      final pakuPrice = prices['paku'] ?? MaterialDefaultPrices.paku;

      requirements.addAll([
        MaterialRequirement(
          key: 'plywood_9mm',
          name: 'Triplek / Plywood 9mm Bekisting',
          quantity: plywoodQty,
          unit: 'lembar',
          unitPrice: plywoodPrice,
        ),
        MaterialRequirement(
          key: 'kayu_usuk',
          name: 'Kayu Kaso 5x7 (Batang 4m) Bekisting',
          quantity: kasoQty,
          unit: 'batang',
          unitPrice: kasoPrice,
        ),
        MaterialRequirement(
          key: 'paku',
          name: 'Paku Beton / Kayu (5-7cm)',
          quantity: double.parse(pakuQty.toStringAsFixed(2)),
          unit: 'kg',
          unitPrice: pakuPrice,
        ),
      ]);
    }

    return CalculationResult(requirements: requirements);
  }

  static double _getDefaultBesiPrice(int diameter) {
    switch (diameter) {
      case 6:
        return MaterialDefaultPrices.besi6;
      case 8:
        return MaterialDefaultPrices.besi8;
      case 10:
        return MaterialDefaultPrices.besi10;
      case 12:
        return MaterialDefaultPrices.besi12;
      case 16:
        return MaterialDefaultPrices.besi16;
      default:
        return 50000.0;
    }
  }

  /// 10. Rangka Atap Baja Ringan (Galvalum)
  /// Input: luas atap (m2)
  /// Output: Canal C, Reng, Sekrup
  static CalculationResult calculateBajaRingan({
    required double luasAtap,
    required Map<String, double> prices,
  }) {
    final kanalCQty = (luasAtap * 1.2).ceilToDouble();
    final rengQty = (luasAtap * 1.5).ceilToDouble();
    final sekrupTrussQty = (luasAtap * 10.0).ceilToDouble();
    final sekrupGentengQty = (luasAtap * 12.0).ceilToDouble();

    final kanalPrice = prices['baja_c'] ?? MaterialDefaultPrices.bajaC;
    final rengPrice = prices['baja_reng'] ?? MaterialDefaultPrices.bajaReng;
    final sekrupTrussPrice = prices['sekrup_truss'] ?? MaterialDefaultPrices.sekrupTruss;
    final sekrupGentengPrice = prices['sekrup_genteng'] ?? MaterialDefaultPrices.sekrupGenteng;

    return CalculationResult(
      requirements: [
        MaterialRequirement(
          key: 'baja_c',
          name: 'Baja Ringan Canal C-75 (Batang 6m)',
          quantity: kanalCQty,
          unit: 'batang',
          unitPrice: kanalPrice,
        ),
        MaterialRequirement(
          key: 'baja_reng',
          name: 'Reng Baja Ringan (Batang 6m)',
          quantity: rengQty,
          unit: 'batang',
          unitPrice: rengPrice,
        ),
        MaterialRequirement(
          key: 'sekrup_truss',
          name: 'Sekrup Rangka (Truss Screw)',
          quantity: sekrupTrussQty,
          unit: 'pcs',
          unitPrice: sekrupTrussPrice,
        ),
        MaterialRequirement(
          key: 'sekrup_genteng',
          name: 'Sekrup Genteng (Roofing Screw)',
          quantity: sekrupGentengQty,
          unit: 'pcs',
          unitPrice: sekrupGentengPrice,
        ),
      ],
    );
  }

  /// 11. Plafon Gypsum
  static CalculationResult calculatePlafon({
    required double luas,
    required Map<String, double> prices,
  }) {
    final gypsumQty = double.parse((luas * 0.364).toStringAsFixed(2));
    final hollow4x4Qty = double.parse((luas * 0.55).toStringAsFixed(2));
    final hollow2x4Qty = double.parse((luas * 0.60).toStringAsFixed(2));
    final sekrupQty = double.parse((luas * 17.0).toStringAsFixed(0));
    final compoundQty = double.parse((luas * 0.36).toStringAsFixed(2));
    final tapeQty = double.parse((luas * 0.05).toStringAsFixed(2));

    final gPrice = prices['gypsum_board'] ?? MaterialDefaultPrices.gypsumBoard;
    final h4Price = prices['hollow_4x4'] ?? MaterialDefaultPrices.hollow4x4;
    final h2Price = prices['hollow_2x4'] ?? MaterialDefaultPrices.hollow2x4;
    final sPrice = prices['sekrup_plafon'] ?? MaterialDefaultPrices.sekrupPlafon;
    final cPrice = prices['compound_gypsum'] ?? MaterialDefaultPrices.compoundGypsum;
    final tPrice = prices['tape_gypsum'] ?? MaterialDefaultPrices.tapeGypsum;

    return CalculationResult(
      requirements: [
        MaterialRequirement(
          key: 'gypsum_board',
          name: 'Papan Gypsum (Lembar 1.22x2.44m)',
          quantity: gypsumQty,
          unit: 'lembar',
          unitPrice: gPrice,
        ),
        MaterialRequirement(
          key: 'hollow_4x4',
          name: 'Besi Hollow 4x4 cm (Batang 4m)',
          quantity: hollow4x4Qty,
          unit: 'batang',
          unitPrice: h4Price,
        ),
        MaterialRequirement(
          key: 'hollow_2x4',
          name: 'Besi Hollow 2x4 cm (Batang 4m)',
          quantity: hollow2x4Qty,
          unit: 'batang',
          unitPrice: h2Price,
        ),
        MaterialRequirement(
          key: 'sekrup_plafon',
          name: 'Sekrup Gypsum',
          quantity: sekrupQty,
          unit: 'pcs',
          unitPrice: sPrice,
        ),
        MaterialRequirement(
          key: 'compound_gypsum',
          name: 'Compound Gypsum',
          quantity: compoundQty,
          unit: 'kg',
          unitPrice: cPrice,
        ),
        MaterialRequirement(
          key: 'tape_gypsum',
          name: 'Tape Gypsum (Roll 30m)',
          quantity: tapeQty,
          unit: 'roll',
          unitPrice: tPrice,
        ),
      ],
    );
  }

  /// 12. Tangga Beton
  static CalculationResult calculateTangga({
    required int anakTangga,
    required double lebar,
    required double tinggiAnak,
    required double lebarAlas,
    required double tebalPlat,
    required double panjangBordes,
    required double lebarBordes,
    required double tebalBordes,
    required int diameterUtama,
    required double jarakUtama,
    required int diameterBagi,
    required double jarakBagi,
    required bool bekisting,
    required String mutuBeton,
    required Map<String, double> prices,
  }) {
    final rM = tinggiAnak / 100.0;
    final tM = lebarAlas / 100.0;
    final dM = tebalPlat / 100.0;
    final dbM = tebalBordes / 100.0;

    final lPlat = anakTangga * math.sqrt((rM * rM) + (tM * tM));
    
    final vPlat = lPlat * lebar * dM;
    final vAnak = anakTangga * (0.5 * rM * tM) * lebar;
    final vBordes = panjangBordes * lebarBordes * dbM;
    final totalVolBeton = vPlat + vAnak + vBordes;

    double semenPerM3 = 371.0;
    double pasirPerM3 = 698.0;
    double kerikilPerM3 = 1047.0;
    const double airPerM3 = 215.0;

    switch (mutuBeton) {
      case 'K-175':
        semenPerM3 = 326.0;
        pasirPerM3 = 760.0;
        kerikilPerM3 = 1029.0;
        break;
      case 'K-225':
        semenPerM3 = 371.0;
        pasirPerM3 = 698.0;
        kerikilPerM3 = 1047.0;
        break;
      case 'K-250':
        semenPerM3 = 384.0;
        pasirPerM3 = 692.0;
        kerikilPerM3 = 1039.0;
        break;
      case 'K-300':
        semenPerM3 = 413.0;
        pasirPerM3 = 681.0;
        kerikilPerM3 = 1021.0;
        break;
    }

    final semenSak = (semenPerM3 * totalVolBeton) / 50.0;
    final pasirM3 = (pasirPerM3 * totalVolBeton) / sandDensity;
    final kerikilM3 = (kerikilPerM3 * totalVolBeton) / gravelDensity;
    final airLiters = airPerM3 * totalVolBeton;

    final weightUtama = 0.006165 * diameterUtama * diameterUtama;
    final lajurUtama = ((lebar * 100.0) / jarakUtama).ceil() * 2;
    final totalPanjangUtama = lajurUtama * (lPlat + panjangBordes + 0.3);
    final batangUtama = (totalPanjangUtama / 12.0).ceilToDouble();

    final weightBagi = 0.006165 * diameterBagi * diameterBagi;
    final lajurBagi = (((lPlat + panjangBordes) * 100.0) / jarakBagi).ceil() * 2;
    final totalPanjangBagi = lajurBagi * lebar;
    final batangBagi = (totalPanjangBagi / 12.0).ceilToDouble();

    final totalSteelWeight = (totalPanjangUtama * weightUtama) + (totalPanjangBagi * weightBagi);
    final kawatKg = totalSteelWeight * 0.015;

    final semenPrice = prices['semen_sak'] ?? MaterialDefaultPrices.semenSak;
    final pasirPrice = prices['pasir'] ?? MaterialDefaultPrices.pasir;
    final kerikilPrice = prices['kerikil'] ?? MaterialDefaultPrices.kerikil;
    final airPrice = prices['air'] ?? MaterialDefaultPrices.air;
    
    final priceKeyUtama = 'besi_$diameterUtama';
    final priceKeyBagi = 'besi_$diameterBagi';
    
    final besiUtamaPrice = prices[priceKeyUtama] ?? _getDefaultBesiPrice(diameterUtama);
    final besiBagiPrice = prices[priceKeyBagi] ?? _getDefaultBesiPrice(diameterBagi);
    final kawatPrice = prices['kawat_bendrat'] ?? MaterialDefaultPrices.kawatBendrat;

    final requirements = <MaterialRequirement>[
      MaterialRequirement(
        key: 'semen_sak',
        name: 'Semen (Cor Tangga $mutuBeton)',
        quantity: double.parse(semenSak.toStringAsFixed(2)),
        unit: 'sak',
        unitPrice: semenPrice,
      ),
      MaterialRequirement(
        key: 'pasir',
        name: 'Pasir Beton',
        quantity: double.parse(pasirM3.toStringAsFixed(2)),
        unit: 'm³',
        unitPrice: pasirPrice,
      ),
      MaterialRequirement(
        key: 'kerikil',
        name: 'Kerikil Beton',
        quantity: double.parse(kerikilM3.toStringAsFixed(2)),
        unit: 'm³',
        unitPrice: kerikilPrice,
      ),
      MaterialRequirement(
        key: 'air',
        name: 'Air',
        quantity: double.parse(airLiters.toStringAsFixed(1)),
        unit: 'liter',
        unitPrice: airPrice,
      ),
      MaterialRequirement(
        key: priceKeyUtama,
        name: 'Besi Utama Ø$diameterUtama mm (Batang 12m)',
        quantity: batangUtama,
        unit: 'batang',
        unitPrice: besiUtamaPrice,
      ),
      MaterialRequirement(
        key: priceKeyBagi,
        name: 'Besi Bagi Ø$diameterBagi mm (Batang 12m)',
        quantity: batangBagi,
        unit: 'batang',
        unitPrice: besiBagiPrice,
      ),
      MaterialRequirement(
        key: 'kawat_bendrat',
        name: 'Kawat Beton (Bendrat)',
        quantity: double.parse(kawatKg.toStringAsFixed(2)),
        unit: 'kg',
        unitPrice: kawatPrice,
      ),
    ];

    if (bekisting) {
      final luasBekisting = (lPlat * lebar) + (panjangBordes * lebarBordes) + (anakTangga * (tinggiAnak / 100.0) * lebar);
      final plywoodQty = (luasBekisting * 0.35).ceilToDouble();
      final kasoQty = (luasBekisting * 0.5).ceilToDouble();
      final pakuQty = luasBekisting * 0.3;

      final plywoodPrice = prices['plywood_9mm'] ?? MaterialDefaultPrices.plywood9mm;
      final kasoPrice = prices['kayu_usuk'] ?? MaterialDefaultPrices.usukWood;
      final pakuPrice = prices['paku'] ?? MaterialDefaultPrices.paku;

      requirements.addAll([
        MaterialRequirement(
          key: 'plywood_9mm',
          name: 'Triplek / Plywood 9mm Bekisting',
          quantity: plywoodQty,
          unit: 'lembar',
          unitPrice: plywoodPrice,
        ),
        MaterialRequirement(
          key: 'kayu_usuk',
          name: 'Kayu Kaso 5x7 (Batang 4m) Bekisting',
          quantity: kasoQty,
          unit: 'batang',
          unitPrice: kasoPrice,
        ),
        MaterialRequirement(
          key: 'paku',
          name: 'Paku Kayu/Bekisting (5-7cm)',
          quantity: double.parse(pakuQty.toStringAsFixed(2)),
          unit: 'kg',
          unitPrice: pakuPrice,
        ),
      ]);
    }

    return CalculationResult(requirements: requirements);
  }

  /// 13. Paving Block
  static CalculationResult calculatePaving({
    required double luas,
    required double panjangKanstin,
    required Map<String, double> prices,
  }) {
    final pavingQty = (luas * 44.0).ceilToDouble();
    final pasirUrugQty = double.parse((luas * 0.05).toStringAsFixed(2));
    final kanstinQty = (panjangKanstin / 0.6).ceilToDouble();

    final pavingPrice = prices['paving_block'] ?? MaterialDefaultPrices.pavingBlock;
    final pasirPrice = prices['pasir'] ?? MaterialDefaultPrices.pasir;
    final kanstinPrice = prices['kanstin'] ?? MaterialDefaultPrices.kanstin;

    return CalculationResult(
      requirements: [
        MaterialRequirement(
          key: 'paving_block',
          name: 'Paving Block',
          quantity: pavingQty,
          unit: 'pcs',
          unitPrice: pavingPrice,
        ),
        MaterialRequirement(
          key: 'pasir',
          name: 'Pasir Urug Alas Paving (Tebal 5cm)',
          quantity: pasirUrugQty,
          unit: 'm³',
          unitPrice: pasirPrice,
        ),
        MaterialRequirement(
          key: 'kanstin',
          name: 'Kanstin Beton Pembatas (60cm)',
          quantity: kanstinQty,
          unit: 'pcs',
          unitPrice: kanstinPrice,
        ),
      ],
    );
  }

  /// 14. Partisi Gypsum 2 Sisi
  static CalculationResult calculatePartisiGypsum({
    required double luas,
    required Map<String, double> prices,
  }) {
    final gypsumQty = double.parse((luas * 0.728).toStringAsFixed(2));
    final studQty = double.parse((luas * 0.8).toStringAsFixed(2));
    final runnerQty = double.parse((luas * 0.4).toStringAsFixed(2));
    final sekrupQty = double.parse((luas * 34.0).toStringAsFixed(0));
    final compoundQty = double.parse((luas * 0.72).toStringAsFixed(2));

    final gPrice = prices['gypsum_board'] ?? MaterialDefaultPrices.gypsumBoard;
    final studPrice = prices['metal_stud'] ?? MaterialDefaultPrices.metalStud;
    final runnerPrice = prices['runner'] ?? MaterialDefaultPrices.runner;
    final sPrice = prices['sekrup_plafon'] ?? MaterialDefaultPrices.sekrupPlafon;
    final cPrice = prices['compound_gypsum'] ?? MaterialDefaultPrices.compoundGypsum;

    return CalculationResult(
      requirements: [
        MaterialRequirement(
          key: 'gypsum_board',
          name: 'Papan Gypsum (Lembar 1.22x2.44m)',
          quantity: gypsumQty,
          unit: 'lembar',
          unitPrice: gPrice,
        ),
        MaterialRequirement(
          key: 'metal_stud',
          name: 'Rangka Metal Stud 7.5cm (Batang 3m)',
          quantity: studQty,
          unit: 'batang',
          unitPrice: studPrice,
        ),
        MaterialRequirement(
          key: 'runner',
          name: 'Rangka U-Runner 7.5cm (Batang 3m)',
          quantity: runnerQty,
          unit: 'batang',
          unitPrice: runnerPrice,
        ),
        MaterialRequirement(
          key: 'sekrup_plafon',
          name: 'Sekrup Partisi Gypsum',
          quantity: sekrupQty,
          unit: 'pcs',
          unitPrice: sPrice,
        ),
        MaterialRequirement(
          key: 'compound_gypsum',
          name: 'Compound Gypsum',
          quantity: compoundQty,
          unit: 'kg',
          unitPrice: cPrice,
        ),
      ],
    );
  }

  /// 15. Pagar Panel Precast
  static CalculationResult calculatePagarPanel({
    required double panjang,
    required double tinggi,
    required Map<String, double> prices,
  }) {
    final susunKeAtas = (tinggi / 0.4).round();
    final jumlahBentang = (panjang / 2.4).ceil();
    
    final daunQty = (jumlahBentang * susunKeAtas).toDouble();
    final tiangQty = (jumlahBentang + 1).toDouble();

    final daunPrice = prices['daun_panel'] ?? MaterialDefaultPrices.daunPanel;
    final tiangPrice = prices['tiang_kolom_precast'] ?? MaterialDefaultPrices.tiangKolomPrecast;

    return CalculationResult(
      requirements: [
        MaterialRequirement(
          key: 'daun_panel',
          name: 'Daun Panel Beton Precast (240x40x5 cm)',
          quantity: daunQty,
          unit: 'lembar',
          unitPrice: daunPrice,
        ),
        MaterialRequirement(
          key: 'tiang_kolom_precast',
          name: 'Tiang Kolom Precast Beton',
          quantity: tiangQty,
          unit: 'batang',
          unitPrice: tiangPrice,
        ),
      ],
    );
  }

  /// 16. Pondasi Bore Pile
  static CalculationResult calculateBorePile({
    required int titik,
    required double diameter,
    required double kedalaman,
    required int diameterUtama,
    required int jumlahUtama,
    required int diameterSpiral,
    required double jarakSpiral,
    required String mutuBeton,
    required Map<String, double> prices,
  }) {
    final radius = diameter / 200.0;
    final volPerTitik = math.pi * radius * radius * kedalaman;
    final totalVolBeton = volPerTitik * titik;

    double semenPerM3 = 371.0;
    double pasirPerM3 = 698.0;
    double kerikilPerM3 = 1047.0;
    const double airPerM3 = 215.0;

    switch (mutuBeton) {
      case 'K-175':
        semenPerM3 = 326.0;
        pasirPerM3 = 760.0;
        kerikilPerM3 = 1029.0;
        break;
      case 'K-225':
        semenPerM3 = 371.0;
        pasirPerM3 = 698.0;
        kerikilPerM3 = 1047.0;
        break;
      case 'K-250':
        semenPerM3 = 384.0;
        pasirPerM3 = 692.0;
        kerikilPerM3 = 1039.0;
        break;
      case 'K-300':
        semenPerM3 = 413.0;
        pasirPerM3 = 681.0;
        kerikilPerM3 = 1021.0;
        break;
    }

    final semenSak = (semenPerM3 * totalVolBeton) / 50.0;
    final pasirM3 = (pasirPerM3 * totalVolBeton) / sandDensity;
    final kerikilM3 = (kerikilPerM3 * totalVolBeton) / gravelDensity;
    final airLiters = airPerM3 * totalVolBeton;

    final weightUtama = 0.006165 * diameterUtama * diameterUtama;
    final totalPanjangUtama = titik * jumlahUtama * (kedalaman + 0.5);
    final batangUtama = (totalPanjangUtama / 12.0).ceilToDouble();

    final dSpiralCm = math.max(2.0, diameter - 6.0);
    final kelilingSpiralM = math.pi * (dSpiralCm / 100.0);
    final putaranSpiral = ((kedalaman * 100.0) / jarakSpiral).ceil() + 2;
    final totalPanjangSpiral = titik * putaranSpiral * kelilingSpiralM;
    final weightSpiral = 0.006165 * diameterSpiral * diameterSpiral;
    final batangSpiral = (totalPanjangSpiral / 12.0).ceilToDouble();

    final totalSteelWeight = (totalPanjangUtama * weightUtama) + (totalPanjangSpiral * weightSpiral);
    final kawatKg = totalSteelWeight * 0.015;

    final semenPrice = prices['semen_sak'] ?? MaterialDefaultPrices.semenSak;
    final pasirPrice = prices['pasir'] ?? MaterialDefaultPrices.pasir;
    final kerikilPrice = prices['kerikil'] ?? MaterialDefaultPrices.kerikil;
    final airPrice = prices['air'] ?? MaterialDefaultPrices.air;
    
    final priceKeyUtama = 'besi_$diameterUtama';
    final priceKeySpiral = 'besi_$diameterSpiral';
    
    final besiUtamaPrice = prices[priceKeyUtama] ?? _getDefaultBesiPrice(diameterUtama);
    final besiSpiralPrice = prices[priceKeySpiral] ?? _getDefaultBesiPrice(diameterSpiral);
    final kawatPrice = prices['kawat_bendrat'] ?? MaterialDefaultPrices.kawatBendrat;

    return CalculationResult(
      requirements: [
        MaterialRequirement(
          key: 'semen_sak',
          name: 'Semen (Cor Bore Pile $mutuBeton)',
          quantity: double.parse(semenSak.toStringAsFixed(2)),
          unit: 'sak',
          unitPrice: semenPrice,
        ),
        MaterialRequirement(
          key: 'pasir',
          name: 'Pasir Beton',
          quantity: double.parse(pasirM3.toStringAsFixed(2)),
          unit: 'm³',
          unitPrice: pasirPrice,
        ),
        MaterialRequirement(
          key: 'kerikil',
          name: 'Kerikil Beton',
          quantity: double.parse(kerikilM3.toStringAsFixed(2)),
          unit: 'm³',
          unitPrice: kerikilPrice,
        ),
        MaterialRequirement(
          key: 'air',
          name: 'Air',
          quantity: double.parse(airLiters.toStringAsFixed(1)),
          unit: 'liter',
          unitPrice: airPrice,
        ),
        MaterialRequirement(
          key: priceKeyUtama,
          name: 'Besi Utama Ø$diameterUtama mm (Batang 12m)',
          quantity: batangUtama,
          unit: 'batang',
          unitPrice: besiUtamaPrice,
        ),
        MaterialRequirement(
          key: priceKeySpiral,
          name: 'Besi Spiral Ø$diameterSpiral mm (Batang 12m)',
          quantity: batangSpiral,
          unit: 'batang',
          unitPrice: besiSpiralPrice,
        ),
        MaterialRequirement(
          key: 'kawat_bendrat',
          name: 'Kawat Beton (Bendrat)',
          quantity: double.parse(kawatKg.toStringAsFixed(2)),
          unit: 'kg',
          unitPrice: kawatPrice,
        ),
      ],
    );
  }

  /// 17. Keramik Dinding (30x60 cm standard)
  static CalculationResult calculateKeramikDinding({
    required double luas,
    required Map<String, double> prices,
  }) {
    final luasDenganWaste = luas * 1.1;
    final totalDus = (luasDenganWaste / (0.18 * 6)).ceilToDouble();
    
    final semenInstanSak = (luas * 10.0) / 40.0;
    final semenNatKg = luas * 0.5;

    final tilePrice = prices['keramik_dinding'] ?? MaterialDefaultPrices.keramikDinding;
    final mortarPrice = prices['semen_instan'] ?? MaterialDefaultPrices.semenInstan;
    final natPrice = prices['semen_nat'] ?? MaterialDefaultPrices.semenNat;

    return CalculationResult(
      requirements: [
        MaterialRequirement(
          key: 'keramik_dinding',
          name: 'Keramik Dinding 30x60 cm',
          quantity: totalDus,
          unit: 'dus',
          unitPrice: tilePrice,
        ),
        MaterialRequirement(
          key: 'semen_instan',
          name: 'Semen Instan Perekat (Sak 40kg)',
          quantity: double.parse(semenInstanSak.toStringAsFixed(2)),
          unit: 'sak',
          unitPrice: mortarPrice,
        ),
        MaterialRequirement(
          key: 'semen_nat',
          name: 'Semen Pengisi Nat Keramik',
          quantity: double.parse(semenNatKg.toStringAsFixed(2)),
          unit: 'kg',
          unitPrice: natPrice,
        ),
      ],
    );
  }

  /// 18. Waterproofing Dak Beton
  static CalculationResult calculateWaterproofing({
    required double luas,
    required Map<String, double> prices,
  }) {
    final liquidQty = double.parse((luas * 1.0).toStringAsFixed(1));
    final liquidPrice = prices['waterproofing_liquid'] ?? MaterialDefaultPrices.waterproofingLiquid;

    return CalculationResult(
      requirements: [
        MaterialRequirement(
          key: 'waterproofing_liquid',
          name: 'Cairan Waterproofing Pelapis Dak',
          quantity: liquidQty,
          unit: 'kg',
          unitPrice: liquidPrice,
        ),
      ],
    );
  }

  /// 19. Begel Spiral Kolom Silinder
  static CalculationResult calculateBegelSpiral({
    required int titik,
    required double tinggi,
    required double diameter,
    required int diameterSpiral,
    required double jarakSpiral,
    required Map<String, double> prices,
  }) {
    final dSpiralCm = math.max(2.0, diameter - 5.0);
    final kelilingSpiralM = math.pi * (dSpiralCm / 100.0);
    final putaranSpiral = ((tinggi * 100.0) / jarakSpiral).ceil() + 3;
    final totalPanjangSpiral = titik * putaranSpiral * kelilingSpiralM;
    final weightSpiral = 0.006165 * diameterSpiral * diameterSpiral;
    final totalWeight = totalPanjangSpiral * weightSpiral;
    final batangSpiral = (totalPanjangSpiral / 12.0).ceilToDouble();
    final kawatKg = totalWeight * 0.015;

    final besiSpiralPrice = prices['besi_$diameterSpiral'] ?? _getDefaultBesiPrice(diameterSpiral);
    final kawatPrice = prices['kawat_bendrat'] ?? MaterialDefaultPrices.kawatBendrat;

    return CalculationResult(
      requirements: [
        MaterialRequirement(
          key: 'besi_$diameterSpiral',
          name: 'Besi Begel Spiral Ø$diameterSpiral mm (Batang 12m)',
          quantity: batangSpiral,
          unit: 'batang',
          unitPrice: besiSpiralPrice,
        ),
        MaterialRequirement(
          key: 'kawat_bendrat',
          name: 'Kawat Beton (Bendrat)',
          quantity: double.parse(kawatKg.toStringAsFixed(2)),
          unit: 'kg',
          unitPrice: kawatPrice,
        ),
      ],
    );
  }

  /// 20. Urugan Sirtu (Pasir Batu)
  static CalculationResult calculateUruganSirtu({
    required double panjang,
    required double lebar,
    required double tebal,
    required Map<String, double> prices,
  }) {
    final volGembur = panjang * lebar * (tebal / 100.0);
    final sirtuQty = double.parse((volGembur * 1.2).toStringAsFixed(2));

    final sirtuPrice = prices['sirtu'] ?? MaterialDefaultPrices.sirtu;

    return CalculationResult(
      requirements: [
        MaterialRequirement(
          key: 'sirtu',
          name: 'Material Sirtu Urug (Pasir Batu)',
          quantity: sirtuQty,
          unit: 'm³',
          unitPrice: sirtuPrice,
        ),
      ],
    );
  }

  /// 21. Pondasi Tapak (Footplate / Cakar Ayam)
  static CalculationResult calculateCakarAyam({
    required double panjang,
    required double lebar,
    required double tebal,
    required int diameterBesi,
    required double jarakBesi,
    required String mutuBeton,
    required Map<String, double> prices,
  }) {
    final volumeBeton = panjang * lebar * tebal;
    
    // Besi tulangan anyaman X & Y
    final jumlahX = (lebar / (jarakBesi / 100.0)).ceil() + 1;
    final jumlahY = (panjang / (jarakBesi / 100.0)).ceil() + 1;
    final totalPanjangBesi = (jumlahX * panjang) + (jumlahY * lebar) + (jumlahX + jumlahY) * 0.3; // with hooks
    final batangBesi = (totalPanjangBesi / 12.0).ceilToDouble();
    
    final weightPerM = 0.006165 * diameterBesi * diameterBesi;
    final kawatKg = totalPanjangBesi * weightPerM * 0.015;
    
    // Beton manual mix ratios based on mutu
    double semenPerM3 = 326.0;
    double pasirPerM3 = 760.0;
    double kerikilPerM3 = 1029.0;
    double airPerM3 = 215.0;
    
    switch (mutuBeton) {
      case 'K-175':
        semenPerM3 = 326.0; pasirPerM3 = 760.0; kerikilPerM3 = 1029.0; break;
      case 'K-225':
        semenPerM3 = 371.0; pasirPerM3 = 698.0; kerikilPerM3 = 1047.0; break;
      case 'K-250':
        semenPerM3 = 384.0; pasirPerM3 = 692.0; kerikilPerM3 = 1039.0; break;
      case 'K-300':
        semenPerM3 = 413.0; pasirPerM3 = 681.0; kerikilPerM3 = 1021.0; break;
    }
    
    final semenSak = (semenPerM3 * volumeBeton) / 50.0;
    final pasirM3 = (pasirPerM3 * volumeBeton) / sandDensity;
    final kerikilM3 = (kerikilPerM3 * volumeBeton) / gravelDensity;
    final airLiters = airPerM3 * volumeBeton;
    
    // Bekisting Plywood & Kaso
    final keliling = 2.0 * (panjang + lebar);
    final luasBekisting = keliling * tebal;
    final plywoodLembar = (luasBekisting / 2.97).ceilToDouble();
    final kasoBatang = (keliling / 2.0).ceilToDouble();
    final pakuKg = luasBekisting * 0.3;
    
    final semenPrice = prices['semen_sak'] ?? MaterialDefaultPrices.semenSak;
    final pasirPrice = prices['pasir'] ?? MaterialDefaultPrices.pasir;
    final kerikilPrice = prices['kerikil'] ?? MaterialDefaultPrices.kerikil;
    final airPrice = prices['air'] ?? MaterialDefaultPrices.air;
    final besiPrice = prices['besi_$diameterBesi'] ?? _getDefaultBesiPrice(diameterBesi);
    final bendratPrice = prices['kawat_bendrat'] ?? MaterialDefaultPrices.kawatBendrat;
    final plywoodPrice = prices['plywood_9mm'] ?? MaterialDefaultPrices.plywood9mm;
    final kasoPrice = prices['kaso_5x7'] ?? 35000.0; // fallback standard kaso
    final pakuPrice = prices['paku'] ?? MaterialDefaultPrices.paku;
    
    return CalculationResult(
      requirements: [
        MaterialRequirement(key: 'semen_sak', name: 'Semen (Sak 50kg)', quantity: double.parse(semenSak.toStringAsFixed(2)), unit: 'sak', unitPrice: semenPrice),
        MaterialRequirement(key: 'pasir', name: 'Pasir Beton', quantity: double.parse(pasirM3.toStringAsFixed(2)), unit: 'm³', unitPrice: pasirPrice),
        MaterialRequirement(key: 'kerikil', name: 'Kerikil Beton', quantity: double.parse(kerikilM3.toStringAsFixed(2)), unit: 'm³', unitPrice: kerikilPrice),
        MaterialRequirement(key: 'air', name: 'Air Kerja', quantity: double.parse(airLiters.toStringAsFixed(1)), unit: 'liter', unitPrice: airPrice),
        MaterialRequirement(key: 'besi_$diameterBesi', name: 'Besi Tulangan Ø$diameterBesi mm (12m)', quantity: batangBesi, unit: 'batang', unitPrice: besiPrice),
        MaterialRequirement(key: 'kawat_bendrat', name: 'Kawat Beton (Bendrat)', quantity: double.parse(kawatKg.toStringAsFixed(2)), unit: 'kg', unitPrice: bendratPrice),
        MaterialRequirement(key: 'plywood_9mm', name: 'Triplek Bekisting 9mm', quantity: plywoodLembar, unit: 'lembar', unitPrice: plywoodPrice),
        MaterialRequirement(key: 'kaso_5x7', name: 'Kayu Kaso 5x7 cm (Rangka)', quantity: kasoBatang, unit: 'batang', unitPrice: kasoPrice),
        MaterialRequirement(key: 'paku', name: 'Paku Bekisting', quantity: double.parse(pakuKg.toStringAsFixed(2)), unit: 'kg', unitPrice: pakuPrice),
      ],
    );
  }

  /// 22. Plat Lantai Floordeck (Bondex & Wiremesh)
  static CalculationResult calculateFloordeck({
    required double panjang,
    required double lebar,
    required double tebal,
    required String tipeWiremesh,
    required int layer,
    required Map<String, double> prices,
  }) {
    final area = panjang * lebar;
    final volumeBeton = area * tebal;
    
    final bondexLembar = (area / 6.0).ceilToDouble(); // 1 sheet = 1x6m
    final wiremeshLembar = ((area / 10.0) * layer).ceilToDouble(); // 1 sheet = 2.1x5.4m with overlap
    final scaffoldingSet = (area / 2.0).ceilToDouble();
    
    final bondexPrice = prices['bondex'] ?? MaterialDefaultPrices.bondex;
    final wmPriceKey = 'wiremesh_${tipeWiremesh.toLowerCase()}';
    
    double wmDefaultPrice = MaterialDefaultPrices.wiremeshM8;
    if (tipeWiremesh == 'M6') {
      wmDefaultPrice = MaterialDefaultPrices.wiremeshM6;
    } else if (tipeWiremesh == 'M10') {
      wmDefaultPrice = MaterialDefaultPrices.wiremeshM10;
    }
    
    final wiremeshPrice = prices[wmPriceKey] ?? wmDefaultPrice;
    final semenPrice = prices['semen_sak'] ?? MaterialDefaultPrices.semenSak;
    final pasirPrice = prices['pasir'] ?? MaterialDefaultPrices.pasir;
    final kerikilPrice = prices['kerikil'] ?? MaterialDefaultPrices.kerikil;
    
    // Assume K-250 mix for flooring structure
    final semenSak = (384.0 * volumeBeton) / 50.0;
    final pasirM3 = (692.0 * volumeBeton) / sandDensity;
    final kerikilM3 = (1039.0 * volumeBeton) / gravelDensity;

    return CalculationResult(
      requirements: [
        MaterialRequirement(key: 'bondex', name: 'Lembar Bondex (6m)', quantity: bondexLembar, unit: 'lembar', unitPrice: bondexPrice),
        MaterialRequirement(key: wmPriceKey, name: 'Wiremesh $tipeWiremesh', quantity: wiremeshLembar, unit: 'lembar', unitPrice: wiremeshPrice),
        MaterialRequirement(key: 'semen_sak', name: 'Semen (Sak 50kg)', quantity: double.parse(semenSak.toStringAsFixed(2)), unit: 'sak', unitPrice: semenPrice),
        MaterialRequirement(key: 'pasir', name: 'Pasir Beton', quantity: double.parse(pasirM3.toStringAsFixed(2)), unit: 'm³', unitPrice: pasirPrice),
        MaterialRequirement(key: 'kerikil', name: 'Kerikil Beton', quantity: double.parse(kerikilM3.toStringAsFixed(2)), unit: 'm³', unitPrice: kerikilPrice),
        MaterialRequirement(key: 'scaffolding', name: 'Scaffolding Penyangga', quantity: scaffoldingSet, unit: 'set', unitPrice: 45000.0), // fallback rental/buy price
      ],
    );
  }

  /// 23. Plat Slab Lantai dengan Wiremesh
  static CalculationResult calculatePlatSlab({
    required double panjang,
    required double lebar,
    required double tebal,
    required String tipeWiremesh,
    required int layer,
    required Map<String, double> prices,
  }) {
    final area = panjang * lebar;
    final volumeBeton = area * tebal;
    
    final wiremeshLembar = ((area / 10.0) * layer).ceilToDouble();
    final plywoodLembar = (area / 2.97).ceilToDouble();
    final kasoBatang = (area * 1.5).ceilToDouble();
    
    final wmPriceKey = 'wiremesh_${tipeWiremesh.toLowerCase()}';
    
    double wmDefaultPrice = MaterialDefaultPrices.wiremeshM8;
    if (tipeWiremesh == 'M6') {
      wmDefaultPrice = MaterialDefaultPrices.wiremeshM6;
    } else if (tipeWiremesh == 'M10') {
      wmDefaultPrice = MaterialDefaultPrices.wiremeshM10;
    }
    
    final wiremeshPrice = prices[wmPriceKey] ?? wmDefaultPrice;
    final semenPrice = prices['semen_sak'] ?? MaterialDefaultPrices.semenSak;
    final pasirPrice = prices['pasir'] ?? MaterialDefaultPrices.pasir;
    final kerikilPrice = prices['kerikil'] ?? MaterialDefaultPrices.kerikil;
    final plywoodPrice = prices['plywood_9mm'] ?? MaterialDefaultPrices.plywood9mm;
    
    // Assume structural K-225 mix
    final semenSak = (371.0 * volumeBeton) / 50.0;
    final pasirM3 = (698.0 * volumeBeton) / sandDensity;
    final kerikilM3 = (1047.0 * volumeBeton) / gravelDensity;

    return CalculationResult(
      requirements: [
        MaterialRequirement(key: wmPriceKey, name: 'Wiremesh $tipeWiremesh', quantity: wiremeshLembar, unit: 'lembar', unitPrice: wiremeshPrice),
        MaterialRequirement(key: 'semen_sak', name: 'Semen (Sak 50kg)', quantity: double.parse(semenSak.toStringAsFixed(2)), unit: 'sak', unitPrice: semenPrice),
        MaterialRequirement(key: 'pasir', name: 'Pasir Beton', quantity: double.parse(pasirM3.toStringAsFixed(2)), unit: 'm³', unitPrice: pasirPrice),
        MaterialRequirement(key: 'kerikil', name: 'Kerikil Beton', quantity: double.parse(kerikilM3.toStringAsFixed(2)), unit: 'm³', unitPrice: kerikilPrice),
        MaterialRequirement(key: 'plywood_9mm', name: 'Triplek Bekisting 9mm', quantity: plywoodLembar, unit: 'lembar', unitPrice: plywoodPrice),
        MaterialRequirement(key: 'kaso_5x7', name: 'Kayu Kaso 5x7 cm', quantity: kasoBatang, unit: 'batang', unitPrice: 35000.0),
      ],
    );
  }

  /// 24. Urugan Tanah & Pemadatan (Cut & Fill)
  static CalculationResult calculateCutFill({
    required double panjang,
    required double lebar,
    required double tebal,
    required String jenisTanah,
    required Map<String, double> prices,
  }) {
    final volPadat = panjang * lebar * (tebal / 100.0);
    final factor = jenisTanah == 'Biasa' ? 1.2 : 1.3;
    final volGembur = double.parse((volPadat * factor).toStringAsFixed(2));
    
    final tanahPrice = prices['tanah_urug'] ?? MaterialDefaultPrices.tanahUrug;

    return CalculationResult(
      requirements: [
        MaterialRequirement(key: 'tanah_urug', name: 'Tanah Urug Merah', quantity: volGembur, unit: 'm³', unitPrice: tanahPrice),
      ],
    );
  }

  /// 25. Dinding Penahan Tanah (Retaining Wall Batu Kali)
  static CalculationResult calculateRetainingWall({
    required double panjang,
    required double tinggi,
    required double lebarAtas,
    required double lebarBawah,
    required String campuran,
    required Map<String, double> prices,
  }) {
    final volume = panjang * ((lebarAtas + lebarBawah) / 2.0) * tinggi;
    
    final batuBelahM3 = double.parse((volume * 1.2).toStringAsFixed(2));
    double semenKg = 0.0;
    double pasirM3 = 0.52 * volume;
    
    if (campuran == '1:3') {
      semenKg = 163.0 * volume;
    } else if (campuran == '1:4') {
      semenKg = 125.0 * volume;
    } else {
      semenKg = 97.0 * volume;
    }
    
    final semenSak = double.parse((semenKg / 50.0).toStringAsFixed(2));
    pasirM3 = double.parse(pasirM3.toStringAsFixed(2));
    final pipaPvcBatang = ((panjang * tinggi) / 8.0).ceilToDouble(); // 1 pipe Ø2" suling per 8m2
    
    final batuPrice = prices['batu_belah'] ?? MaterialDefaultPrices.batuBelah;
    final semenPrice = prices['semen_sak'] ?? MaterialDefaultPrices.semenSak;
    final pasirPrice = prices['pasir'] ?? MaterialDefaultPrices.pasir;
    final pipaPrice = prices['pipa_pvc_d'] ?? MaterialDefaultPrices.pipaPvcD;

    return CalculationResult(
      requirements: [
        MaterialRequirement(key: 'batu_belah', name: 'Batu Kali Belah', quantity: batuBelahM3, unit: 'm³', unitPrice: batuPrice),
        MaterialRequirement(key: 'semen_sak', name: 'Semen (Sak 50kg)', quantity: semenSak, unit: 'sak', unitPrice: semenPrice),
        MaterialRequirement(key: 'pasir', name: 'Pasir Pasang', quantity: pasirM3, unit: 'm³', unitPrice: pasirPrice),
        MaterialRequirement(key: 'pipa_pvc_d', name: 'Pipa PVC Ø2" Suling (4m)', quantity: pipaPvcBatang, unit: 'batang', unitPrice: pipaPrice),
      ],
    );
  }

  /// 26. Septic Tank Konvensional & Resapan
  static CalculationResult calculateSepticTank({
    required double panjang,
    required double lebar,
    required double tinggi,
    required Map<String, double> prices,
  }) {
    // Dinding keliling bata merah
    final keliling = 2.0 * (panjang + lebar);
    final luasDinding = keliling * tinggi;
    final bataMerahPcs = (luasDinding * 70.0).ceilToDouble();
    final semenDindingSak = (luasDinding * 11.5) / 50.0;
    final pasirDindingM3 = luasDinding * 0.043;
    
    // Beton penutup 10cm
    final volumeBeton = panjang * lebar * 0.10;
    final semenBetonSak = (326.0 * volumeBeton) / 50.0;
    final pasirBetonM3 = (760.0 * volumeBeton) / sandDensity;
    final kerikilBetonM3 = (1029.0 * volumeBeton) / gravelDensity;
    
    // Resapan
    final areaResapan = panjang * lebar;
    final ijukKg = areaResapan * 10.0;
    final kerikilFilterM3 = areaResapan * 0.30;
    final pasirUrugM3 = areaResapan * 0.10;
    
    // Total semens & pasirs
    final totalSemen = double.parse((semenDindingSak + semenBetonSak).toStringAsFixed(2));
    final totalPasir = double.parse((pasirDindingM3 + pasirBetonM3 + pasirUrugM3).toStringAsFixed(2));
    final totalKerikil = double.parse((kerikilBetonM3 + kerikilFilterM3).toStringAsFixed(2));
    
    final bataPrice = prices['bata_merah'] ?? MaterialDefaultPrices.bataMerah;
    final semenPrice = prices['semen_sak'] ?? MaterialDefaultPrices.semenSak;
    final pasirPrice = prices['pasir'] ?? MaterialDefaultPrices.pasir;
    final kerikilPrice = prices['kerikil'] ?? MaterialDefaultPrices.kerikil;
    final kawatPrice = prices['kawat_bendrat'] ?? MaterialDefaultPrices.kawatBendrat;
    
    return CalculationResult(
      requirements: [
        MaterialRequirement(key: 'bata_merah', name: 'Bata Merah', quantity: bataMerahPcs, unit: 'bh', unitPrice: bataPrice),
        MaterialRequirement(key: 'semen_sak', name: 'Semen (Sak 50kg)', quantity: totalSemen, unit: 'sak', unitPrice: semenPrice),
        MaterialRequirement(key: 'pasir', name: 'Pasir Pasang & Urug', quantity: totalPasir, unit: 'm³', unitPrice: pasirPrice),
        MaterialRequirement(key: 'kerikil', name: 'Kerikil Filter & Cor', quantity: totalKerikil, unit: 'm³', unitPrice: kerikilPrice),
        MaterialRequirement(key: 'kawat_bendrat', name: 'Ijuk Resapan', quantity: ijukKg, unit: 'kg', unitPrice: kawatPrice),
      ],
    );
  }

  /// 27. Dinding Batako (Bata Berongga)
  static CalculationResult calculateBatako({
    required double panjang,
    required double tinggi,
    required String campuran,
    required Map<String, double> prices,
  }) {
    final luas = panjang * tinggi;
    final batakoPcs = (luas * 12.5).ceilToDouble();
    
    double semenKg = 0.0;
    double pasirM3 = 0.0;
    
    if (campuran == '1:3') {
      semenKg = 12.5 * luas; pasirM3 = 0.03 * luas;
    } else if (campuran == '1:4') {
      semenKg = 9.8 * luas; pasirM3 = 0.035 * luas;
    } else {
      semenKg = 8.2 * luas; pasirM3 = 0.04 * luas;
    }
    
    final semenSak = double.parse((semenKg / 50.0).toStringAsFixed(2));
    pasirM3 = double.parse(pasirM3.toStringAsFixed(2));
    
    final batakoPrice = prices['batako'] ?? MaterialDefaultPrices.batako;
    final semenPrice = prices['semen_sak'] ?? MaterialDefaultPrices.semenSak;
    final pasirPrice = prices['pasir'] ?? MaterialDefaultPrices.pasir;

    return CalculationResult(
      requirements: [
        MaterialRequirement(key: 'batako', name: 'Batako Berongga', quantity: batakoPcs, unit: 'bh', unitPrice: batakoPrice),
        MaterialRequirement(key: 'semen_sak', name: 'Semen (Sak 50kg)', quantity: semenSak, unit: 'sak', unitPrice: semenPrice),
        MaterialRequirement(key: 'pasir', name: 'Pasir Pasang', quantity: pasirM3, unit: 'm³', unitPrice: pasirPrice),
      ],
    );
  }

  /// 28. Dinding Glass Block
  static CalculationResult calculateGlassBlock({
    required double panjang,
    required double tinggi,
    required String ukuran,
    required Map<String, double> prices,
  }) {
    final luas = panjang * tinggi;
    final factor = ukuran == '20x20' ? 25.0 : 28.0;
    final glassPcs = (luas * factor * 1.02).ceilToDouble(); // 2% waste
    
    final cementInstanKg = luas * 8.0;
    final cementNatKg = luas * 1.5;
    final angkurBesiBatang = ((panjang + tinggi) * 1.5 / 6.0).ceilToDouble();
    
    final glassPrice = prices['glass_block'] ?? MaterialDefaultPrices.glassBlock;
    final cementInstanPrice = prices['semen_instan'] ?? MaterialDefaultPrices.semenInstan;
    final cementNatPrice = prices['semen_nat'] ?? MaterialDefaultPrices.semenNat;
    final besiPrice = prices['besi_6'] ?? MaterialDefaultPrices.besi6;

    return CalculationResult(
      requirements: [
        MaterialRequirement(key: 'glass_block', name: 'Glass Block $ukuran', quantity: glassPcs, unit: 'bh', unitPrice: glassPrice),
        MaterialRequirement(key: 'semen_instan', name: 'Semen Instan Perekat', quantity: cementInstanKg, unit: 'kg', unitPrice: cementInstanPrice / 40.0),
        MaterialRequirement(key: 'semen_nat', name: 'Semen Nat Putih', quantity: cementNatKg, unit: 'kg', unitPrice: cementNatPrice),
        MaterialRequirement(key: 'besi_6', name: 'Besi Penguat Ø6 mm', quantity: angkurBesiBatang, unit: 'batang', unitPrice: besiPrice),
      ],
    );
  }

  /// 29. Kusen & Pintu Aluminium
  static CalculationResult calculateKusenAluminium({
    required double lebar,
    required double tinggi,
    required String profile,
    required Map<String, double> prices,
  }) {
    final keliling = 2.0 * (lebar + tinggi);
    final batangAlum = (keliling / 6.0 * 1.05).ceilToDouble(); // 5% waste
    final sealantTubes = (keliling / 8.0).ceilToDouble();
    final dynabolts = ((lebar + tinggi) * 2.0).ceilToDouble();
    
    final alumPrice = prices['kusen_aluminium'] ?? MaterialDefaultPrices.kusenAluminium;
    final sealantPrice = prices['sealant'] ?? MaterialDefaultPrices.sealant;
    final dynaboltPrice = prices['sekrup_plafon'] ?? MaterialDefaultPrices.sekrupPlafon;

    return CalculationResult(
      requirements: [
        MaterialRequirement(key: 'kusen_aluminium', name: 'Batang Aluminium $profile (6m)', quantity: batangAlum, unit: 'batang', unitPrice: alumPrice),
        MaterialRequirement(key: 'sealant', name: 'Sealant Silikon', quantity: sealantTubes, unit: 'tube', unitPrice: sealantPrice),
        MaterialRequirement(key: 'sekrup_plafon', name: 'Sekrup Dynabolt Kusen', quantity: dynabolts, unit: 'pcs', unitPrice: dynaboltPrice),
      ],
    );
  }

  /// 30. Plesteran Lantai (Floor Screed)
  static CalculationResult calculateFloorScreed({
    required double luas,
    required double tebal,
    required String campuran,
    required Map<String, double> prices,
  }) {
    final volume = luas * (tebal / 100.0);
    
    double semenKg = 0.0;
    double pasirM3 = 0.0;
    
    if (campuran == '1:3') {
      semenKg = 320.0 * volume; pasirM3 = 0.70 * volume;
    } else if (campuran == '1:4') {
      semenKg = 245.0 * volume; pasirM3 = 0.75 * volume;
    } else {
      semenKg = 202.0 * volume; pasirM3 = 0.80 * volume;
    }
    
    final semenSak = double.parse((semenKg / 50.0).toStringAsFixed(2));
    pasirM3 = double.parse(pasirM3.toStringAsFixed(2));
    
    final semenPrice = prices['semen_sak'] ?? MaterialDefaultPrices.semenSak;
    final pasirPrice = prices['pasir'] ?? MaterialDefaultPrices.pasir;

    return CalculationResult(
      requirements: [
        MaterialRequirement(key: 'semen_sak', name: 'Semen (Sak 50kg)', quantity: semenSak, unit: 'sak', unitPrice: semenPrice),
        MaterialRequirement(key: 'pasir', name: 'Pasir Beton/Screed', quantity: pasirM3, unit: 'm³', unitPrice: pasirPrice),
      ],
    );
  }

  /// 31. Pondasi Sumuran
  static CalculationResult calculatePondasiSumuran({
    required double diameter,
    required double kedalaman,
    required int jumlahTitik,
    required Map<String, double> prices,
  }) {
    final buisPcs = (kedalaman * jumlahTitik).ceilToDouble();
    final radius = diameter / 200.0;
    final volumeCor = jumlahTitik * math.pi * radius * radius * kedalaman;
    
    // Assume K-175 mix inside sumuran
    final semenSak = (326.0 * volumeCor) / 50.0;
    final pasirM3 = (760.0 * volumeCor) / sandDensity;
    final kerikilM3 = (1029.0 * volumeCor) / gravelDensity;
    
    final buisPrice = prices['buis_beton'] ?? MaterialDefaultPrices.buisBeton;
    final semenPrice = prices['semen_sak'] ?? MaterialDefaultPrices.semenSak;
    final pasirPrice = prices['pasir'] ?? MaterialDefaultPrices.pasir;
    final kerikilPrice = prices['kerikil'] ?? MaterialDefaultPrices.kerikil;

    return CalculationResult(
      requirements: [
        MaterialRequirement(key: 'buis_beton', name: 'Buis Beton Ø$diameter cm', quantity: buisPcs, unit: 'pcs', unitPrice: buisPrice),
        MaterialRequirement(key: 'semen_sak', name: 'Semen Cor Pengisi (Sak)', quantity: double.parse(semenSak.toStringAsFixed(2)), unit: 'sak', unitPrice: semenPrice),
        MaterialRequirement(key: 'pasir', name: 'Pasir Beton', quantity: double.parse(pasirM3.toStringAsFixed(2)), unit: 'm³', unitPrice: pasirPrice),
        MaterialRequirement(key: 'kerikil', name: 'Kerikil Beton', quantity: double.parse(kerikilM3.toStringAsFixed(2)), unit: 'm³', unitPrice: kerikilPrice),
      ],
    );
  }

  /// 32. Plafon PVC
  static CalculationResult calculatePlafonPvc({
    required double panjang,
    required double lebar,
    required Map<String, double> prices,
  }) {
    final area = panjang * lebar;
    final pvcLembar = (area / 0.8 * 1.05).ceilToDouble(); // 1 sheet = 0.2m x 4m = 0.8m2
    final hollow4x4 = (area * 0.85).ceilToDouble();
    final hollow2x4 = (area * 1.10).ceilToDouble();
    final keliling = 2.0 * (panjang + lebar);
    final lisBatang = (keliling / 4.0).ceilToDouble();
    final sekrupPcs = area * 15.0;
    
    final pvcPrice = prices['plafon_pvc'] ?? MaterialDefaultPrices.plafonPvc;
    final hollow4x4Price = prices['hollow_4x4'] ?? MaterialDefaultPrices.hollow4x4;
    final hollow2x4Price = prices['hollow_2x4'] ?? MaterialDefaultPrices.hollow2x4;
    final lisPrice = prices['lis_pvc'] ?? MaterialDefaultPrices.lisPvc;
    final sekrupPrice = prices['sekrup_plafon'] ?? MaterialDefaultPrices.sekrupPlafon;

    return CalculationResult(
      requirements: [
        MaterialRequirement(key: 'plafon_pvc', name: 'Papan Plafon PVC (4m)', quantity: pvcLembar, unit: 'lembar', unitPrice: pvcPrice * 4.0),
        MaterialRequirement(key: 'hollow_4x4', name: 'Besi Hollow 4x4 cm (4m)', quantity: hollow4x4, unit: 'batang', unitPrice: hollow4x4Price),
        MaterialRequirement(key: 'hollow_2x4', name: 'Besi Hollow 2x4 cm (4m)', quantity: hollow2x4, unit: 'batang', unitPrice: hollow2x4Price),
        MaterialRequirement(key: 'lis_pvc', name: 'Lis Profil PVC (4m)', quantity: lisBatang, unit: 'batang', unitPrice: lisPrice * 4.0),
        MaterialRequirement(key: 'sekrup_plafon', name: 'Sekrup Plafon', quantity: sekrupPcs, unit: 'pcs', unitPrice: sekrupPrice),
      ],
    );
  }

  /// 33. Pemasangan Plint Lantai (Skirting)
  static CalculationResult calculatePlintLantai({
    required double keliling,
    required String ukuran,
    required Map<String, double> prices,
  }) {
    double pcsPerMeter = 2.5; // for 40cm
    if (ukuran == '10x30') pcsPerMeter = 3.33;
    if (ukuran == '10x60') pcsPerMeter = 1.67;
    
    final plintPcs = (keliling * pcsPerMeter * 1.15).ceilToDouble(); // 15% waste
    final semenKg = keliling * 1.14;
    final pasirM3 = keliling * 0.003;
    final semenNatKg = keliling * 0.10;
    
    final plintPrice = prices['plint_keramik'] ?? MaterialDefaultPrices.plintKeramik;
    final semenPrice = prices['semen_sak'] ?? MaterialDefaultPrices.semenSak;
    final pasirPrice = prices['pasir'] ?? MaterialDefaultPrices.pasir;
    final natPrice = prices['semen_nat'] ?? MaterialDefaultPrices.semenNat;

    return CalculationResult(
      requirements: [
        MaterialRequirement(key: 'plint_keramik', name: 'Plint Keramik $ukuran cm', quantity: plintPcs, unit: 'pcs', unitPrice: plintPrice),
        MaterialRequirement(key: 'semen_sak', name: 'Semen (Sak 50kg)', quantity: double.parse((semenKg / 50.0).toStringAsFixed(2)), unit: 'sak', unitPrice: semenPrice),
        MaterialRequirement(key: 'pasir', name: 'Pasir Adukan', quantity: double.parse(pasirM3.toStringAsFixed(3)), unit: 'm³', unitPrice: pasirPrice),
        MaterialRequirement(key: 'semen_nat', name: 'Semen Pengisi Nat Plint', quantity: double.parse(semenNatKg.toStringAsFixed(2)), unit: 'kg', unitPrice: natPrice),
      ],
    );
  }

  /// 34. Pemasangan Kusen Pintu Kayu
  static CalculationResult calculateKusenKayu({
    required double lebar,
    required double tinggi,
    required Map<String, double> prices,
  }) {
    // Assume 6x12 cm wood profile = 0.0072 m3 per meter length
    final panjangKusen = 2.0 * (lebar + tinggi);
    final volumeKayuM3 = double.parse((panjangKusen * 0.0072 * 1.10).toStringAsFixed(4)); // 10% waste
    final pakuKg = double.parse((panjangKusen * 0.05).toStringAsFixed(2));
    final lemWoodKg = double.parse((panjangKusen * 0.02).toStringAsFixed(2));
    
    final kayuPrice = prices['balok_kayu'] ?? MaterialDefaultPrices.balokKayu;
    final pakuPrice = prices['paku'] ?? MaterialDefaultPrices.paku;
    final lemPrice = prices['lem_kayu'] ?? MaterialDefaultPrices.lemKayu;

    return CalculationResult(
      requirements: [
        MaterialRequirement(key: 'balok_kayu', name: 'Balok Kayu Kusen', quantity: volumeKayuM3, unit: 'm³', unitPrice: kayuPrice),
        MaterialRequirement(key: 'paku', name: 'Paku Kayu Kusen', quantity: pakuKg, unit: 'kg', unitPrice: pakuPrice),
        MaterialRequirement(key: 'lem_kayu', name: 'Lem Kayu Konstruksi', quantity: lemWoodKg, unit: 'kg', unitPrice: lemPrice),
      ],
    );
  }

  /// 35. Bak Kontrol Bata & Beton (Concrete Box)
  static CalculationResult calculateBakKontrol({
    required double panjang,
    required double lebar,
    required double tinggi,
    required int jumlah,
    required Map<String, double> prices,
  }) {
    final keliling = 2.0 * (panjang + lebar);
    final luasDinding = keliling * tinggi * jumlah;
    final bataMerahPcs = (luasDinding * 70.0).ceilToDouble();
    
    // Semen 1:4 adukan dinding
    final semenDindingKg = luasDinding * 11.5;
    final pasirDindingM3 = luasDinding * 0.043;
    
    final platPcs = jumlah.toDouble();
    
    final bataPrice = prices['bata_merah'] ?? MaterialDefaultPrices.bataMerah;
    final semenPrice = prices['semen_sak'] ?? MaterialDefaultPrices.semenSak;
    final pasirPrice = prices['pasir'] ?? MaterialDefaultPrices.pasir;
    final platPrice = prices['plat_checker'] ?? MaterialDefaultPrices.platChecker;

    return CalculationResult(
      requirements: [
        MaterialRequirement(key: 'bata_merah', name: 'Bata Merah Bak Kontrol', quantity: bataMerahPcs, unit: 'bh', unitPrice: bataPrice),
        MaterialRequirement(key: 'semen_sak', name: 'Semen (Sak 50kg)', quantity: double.parse((semenDindingKg / 50.0).toStringAsFixed(2)), unit: 'sak', unitPrice: semenPrice),
        MaterialRequirement(key: 'pasir', name: 'Pasir Pasang', quantity: double.parse(pasirDindingM3.toStringAsFixed(2)), unit: 'm³', unitPrice: pasirPrice),
        MaterialRequirement(key: 'plat_checker', name: 'Plat Penutup Besi Checker', quantity: platPcs, unit: 'pcs', unitPrice: platPrice),
      ],
    );
  }

  /// 36. Grass Block
  static CalculationResult calculateGrassBlock({
    required double luas,
    required Map<String, double> prices,
  }) {
    final grassPcs = (luas * 25.0 * 1.05).ceilToDouble(); // 25 pcs per m2
    final tanahHumusM3 = double.parse((luas * 0.08).toStringAsFixed(2)); // 8 cm soil bed
    final benihRumputM2 = double.parse((luas * 1.0).toStringAsFixed(1));
    
    final grassPrice = prices['grass_block'] ?? MaterialDefaultPrices.grassBlock;
    final kawatPrice = prices['kawat_bendrat'] ?? MaterialDefaultPrices.kawatBendrat; // humustanah mapped to kawat_bendrat or sirtu
    
    return CalculationResult(
      requirements: [
        MaterialRequirement(key: 'grass_block', name: 'Grass Block Lubang', quantity: grassPcs, unit: 'pcs', unitPrice: grassPrice),
        MaterialRequirement(key: 'tanah_urug', name: 'Tanah Humus Pengisi Lubang', quantity: tanahHumusM3, unit: 'm³', unitPrice: 180000.0),
        MaterialRequirement(key: 'kawat_bendrat', name: 'Benih Rumput Gajah Mini', quantity: benihRumputM2, unit: 'm²', unitPrice: kawatPrice),
      ],
    );
  }

  /// 37. Kanopi Minimalis
  static CalculationResult calculateKanopi({
    required double panjang,
    required double lebar,
    required String atapType,
    required Map<String, double> prices,
  }) {
    final area = panjang * lebar;
    final hollow4x6 = ((panjang * 3 + lebar * 4) / 6.0 * 1.10).ceilToDouble();
    final hollow4x4 = ((panjang * 4 + lebar * 3) / 6.0 * 1.10).ceilToDouble();
    final atapLuas = double.parse((area * 1.10).toStringAsFixed(2));
    final sekrupPcs = (area * 12.0).ceilToDouble();
    final kawatElektroda = double.parse((area * 0.20).toStringAsFixed(2));
    
    final hollow4x6Price = prices['hollow_4x4'] ?? MaterialDefaultPrices.hollow4x4; // use hollow4x4 as fallback frame rate
    final hollow4x4Price = prices['hollow_2x4'] ?? MaterialDefaultPrices.hollow2x4;
    final atapPrice = atapType == 'Polycarbonate'
        ? (prices['polycarbonate'] ?? MaterialDefaultPrices.polycarbonate)
        : (prices['spandek'] ?? MaterialDefaultPrices.spandek);
    final sekrupPrice = prices['sekrup_genteng'] ?? MaterialDefaultPrices.sekrupGenteng;
    final lasPrice = prices['kawat_bendrat'] ?? MaterialDefaultPrices.kawatBendrat;

    return CalculationResult(
      requirements: [
        MaterialRequirement(key: 'hollow_4x4', name: 'Hollow Besi 4x6 cm (Rangka 6m)', quantity: hollow4x6, unit: 'batang', unitPrice: hollow4x6Price * 1.5),
        MaterialRequirement(key: 'hollow_2x4', name: 'Hollow Besi 4x4 cm (Reng/Gording 6m)', quantity: hollow4x4, unit: 'batang', unitPrice: hollow4x4Price * 1.3),
        MaterialRequirement(key: atapType == 'Polycarbonate' ? 'polycarbonate' : 'spandek', name: 'Atap $atapType', quantity: atapLuas, unit: 'm²', unitPrice: atapPrice),
        MaterialRequirement(key: 'sekrup_genteng', name: 'Sekrup Roofing Kanopi', quantity: sekrupPcs, unit: 'pcs', unitPrice: sekrupPrice),
        MaterialRequirement(key: 'kawat_bendrat', name: 'Kawat Las / Elektroda', quantity: kawatElektroda, unit: 'kg', unitPrice: lasPrice),
      ],
    );
  }

  /// 38. Railing Tangga & Balkon Logam
  static CalculationResult calculateRailing({
    required double panjang,
    required double tinggi,
    required Map<String, double> prices,
  }) {
    final pipaHandrail = (panjang / 6.0 * 1.15).ceilToDouble();
    final verticalPickets = ((panjang / 0.12) * tinggi / 6.0 * 1.15).ceilToDouble(); // 12cm spacing
    final dynabolts = (panjang * 2.0).ceilToDouble();
    final elektrodaLas = double.parse((panjang * 0.15).toStringAsFixed(2));
    
    final pipaPrice = prices['pipa_stainless'] ?? MaterialDefaultPrices.pipaStainless;
    final hollowPrice = prices['hollow_2x4'] ?? MaterialDefaultPrices.hollow2x4;
    final dynaboltPrice = prices['sekrup_plafon'] ?? MaterialDefaultPrices.sekrupPlafon;
    final lasPrice = prices['kawat_bendrat'] ?? MaterialDefaultPrices.kawatBendrat;

    return CalculationResult(
      requirements: [
        MaterialRequirement(key: 'pipa_stainless', name: 'Pipa Utama Railing Ø2" (6m)', quantity: pipaHandrail, unit: 'batang', unitPrice: pipaPrice),
        MaterialRequirement(key: 'hollow_2x4', name: 'Hollow Vertical Ø1" Pickets (6m)', quantity: verticalPickets, unit: 'batang', unitPrice: hollowPrice),
        MaterialRequirement(key: 'sekrup_plafon', name: 'Dynabolt Railing Pcs', quantity: dynabolts, unit: 'pcs', unitPrice: dynaboltPrice),
        MaterialRequirement(key: 'kawat_bendrat', name: 'Kawat Las Elektroda', quantity: elektrodaLas, unit: 'kg', unitPrice: lasPrice),
      ],
    );
  }

  /// 39. Pekerjaan Struktur Baja WF/H-Beam
  static CalculationResult calculateBajaWf({
    required double panjang,
    required String tipeWF,
    required Map<String, double> prices,
  }) {
    double weightPerM = 21.3; // WF 200
    if (tipeWF == 'WF 150') weightPerM = 14.0;
    if (tipeWF == 'WF 250') weightPerM = 29.6;
    
    final steelWeight = panjang * weightPerM;
    final platSimpulKg = double.parse((steelWeight * 0.08).toStringAsFixed(2)); // 8% plat gusset
    final bautPcs = (panjang / 2.0 * 6.0).ceilToDouble();
    final lasKg = double.parse((steelWeight * 0.01).toStringAsFixed(2));
    final catPrimerKg = double.parse((steelWeight * 0.015).toStringAsFixed(2));
    
    final wfPriceKey = 'baja_${tipeWF.toLowerCase().replaceAll(' ', '')}';
    double wfDefaultPrice = MaterialDefaultPrices.bajaWf200;
    if (tipeWF == 'WF 150') {
      wfDefaultPrice = MaterialDefaultPrices.bajaWf150;
    } else if (tipeWF == 'WF 250') {
      wfDefaultPrice = MaterialDefaultPrices.bajaWf250;
    }
    final steelPrice = prices[wfPriceKey] ?? wfDefaultPrice;
    
    final platPrice = prices['plat_checker'] ?? MaterialDefaultPrices.platChecker; // gusset plate rate
    final bautPrice = prices['sekrup_truss'] ?? MaterialDefaultPrices.sekrupTruss; // bolt rate
    final lasPrice = prices['kawat_bendrat'] ?? MaterialDefaultPrices.kawatBendrat;
    final catPrice = prices['cat_anti_karat'] ?? MaterialDefaultPrices.catAntiKarat;

    return CalculationResult(
      requirements: [
        MaterialRequirement(key: wfPriceKey, name: 'Baja WF Profile $tipeWF (Batang)', quantity: (panjang / 12.0).ceilToDouble(), unit: 'batang', unitPrice: steelPrice),
        MaterialRequirement(key: 'plat_checker', name: 'Plat Besi Simpul Sambungan', quantity: platSimpulKg, unit: 'kg', unitPrice: platPrice / 30.0), // per kg based on plate sheet weight
        MaterialRequirement(key: 'sekrup_truss', name: 'Baut Baja HTB Pcs', quantity: bautPcs, unit: 'pcs', unitPrice: bautPrice * 10.0), // 10x sekrup price
        MaterialRequirement(key: 'kawat_bendrat', name: 'Elektroda Las Baja', quantity: lasKg, unit: 'kg', unitPrice: lasPrice),
        MaterialRequirement(key: 'cat_anti_karat', name: 'Cat Dasar Anti Karat (Zinc Prim)', quantity: catPrimerKg, unit: 'kg', unitPrice: catPrice),
      ],
    );
  }

  /// 40. Saluran Pipa Air Bersih & Kotor (Plumbing PVC)
  static CalculationResult calculatePlumbing({
    required double panjang,
    required String diameter,
    required Map<String, double> prices,
  }) {
    final batangPipa = (panjang / 4.0 * 1.05).ceilToDouble(); // 4m per pipe + 5% waste
    final fittingPcs = (panjang / 2.0).ceilToDouble();
    final lemTube = (panjang / 10.0).ceilToDouble();
    final tapeRoll = (panjang / 12.0).ceilToDouble();
    
    final pipeAW = diameter == '1/2"' || diameter == '3/4"';
    final pipePrice = pipeAW
        ? (prices['pipa_pvc_aw'] ?? MaterialDefaultPrices.pipaPvcAW)
        : (prices['pipa_pvc_d'] ?? MaterialDefaultPrices.pipaPvcD);
    final fittingPrice = prices['fitting_pvc'] ?? MaterialDefaultPrices.fittingPvc;
    final lemPrice = prices['lem_pipa'] ?? MaterialDefaultPrices.lemPipa;
    final tapePrice = prices['seal_tape'] ?? MaterialDefaultPrices.sealTape;

    return CalculationResult(
      requirements: [
        MaterialRequirement(key: pipeAW ? 'pipa_pvc_aw' : 'pipa_pvc_d', name: 'Pipa PVC $diameter (AW/D 4m)', quantity: batangPipa, unit: 'batang', unitPrice: pipePrice),
        MaterialRequirement(key: 'fitting_pvc', name: 'Aksesoris Fitting PVC (Elbow/Sock)', quantity: fittingPcs, unit: 'pcs', unitPrice: fittingPrice),
        MaterialRequirement(key: 'lem_pipa', name: 'Lem Pipa PVC Solvent Cement', quantity: lemTube, unit: 'tube', unitPrice: lemPrice),
        MaterialRequirement(key: 'seal_tape', name: 'Seal Tape Pipa Air', quantity: tapeRoll, unit: 'roll', unitPrice: tapePrice),
      ],
    );
  }
}
