import 'package:flutter_test/flutter_test.dart';
import 'package:hitung_bangun/core/formulas.dart';

void main() {
  group('HitungBangun Formulas Unit Tests', () {
    final Map<String, double> mockPrices = {
      'semen_sak': 75000.0,
      'pasir': 250000.0,
      'kerikil': 300000.0,
      'air': 10.0,
      'bata_merah': 1000.0,
      'hebel': 10000.0,
      'semen_acian_sak': 90000.0,
      'keramik_30': 6000.0,
      'genteng_tanah': 3000.0,
      'kayu_usuk': 35000.0,
      'kayu_reng': 15000.0,
      'cat_liter': 40000.0,
    };

    test('Beton Campuran Manual K-175 Ratios', () {
      final result = Formulas.calculateBeton(
        volume: 2.0,
        mutu: 'K-175',
        prices: mockPrices,
      );

      // Mutu K-175: 326kg Semen per m3. For 2m3: 652kg / 50kg = 13.04 sak
      final semenReq = result.requirements.firstWhere((r) => r.key == 'semen_sak');
      expect(semenReq.quantity, 13.04);
      expect(semenReq.unit, 'sak');
      expect(semenReq.totalPrice, 13.04 * 75000.0);

      // Air: 215L per m3. For 2m3: 430L
      final airReq = result.requirements.firstWhere((r) => r.key == 'air');
      expect(airReq.quantity, 430.0);
    });

    test('Pondasi Trench Galian & Material Estimates', () {
      final result = Formulas.calculatePondasi(
        panjang: 10.0,
        lebar: 1.0,
        kedalaman: 1.0,
        prices: mockPrices,
      );

      // Volume Galian = 10 * 1 * 1 = 10 m3
      final galianReq = result.requirements.firstWhere((r) => r.key == 'galian');
      expect(galianReq.quantity, 10.0);

      // Pasir Urug (5cm) = 10 * 1 * 0.05 = 0.5 m3
      final pasirUrugReq = result.requirements.firstWhere((r) => r.key == 'pasir_urug');
      expect(pasirUrugReq.quantity, 0.5);
    });

    test('Dinding Bata Merah Ratios', () {
      final result = Formulas.calculateDinding(
        panjang: 10.0,
        tinggi: 3.0,
        jenisBata: 'Merah',
        prices: mockPrices,
      );

      // Area = 30m2. Bata Merah = 30 * 70 = 2100 bh
      final bataReq = result.requirements.firstWhere((r) => r.key == 'bata_merah');
      expect(bataReq.quantity, 2100.0);
    });

    test('Cat Dinding Coverage Estimates', () {
      final result = Formulas.calculateCat(
        luas: 50.0,
        lapisan: 2,
        prices: mockPrices,
      );

      // Luas total = 50 * 2 = 100m2. Paint volume needed = 100 / 10 = 10 Liters
      final catReq = result.requirements.firstWhere((r) => r.key == 'cat_liter');
      expect(catReq.quantity, 10.0);
    });
  });
}
