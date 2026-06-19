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
}
