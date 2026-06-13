import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/formulas.dart';
import '../data/models/calculation_result.dart';
import '../data/repos/project_repo.dart';

class CalculatorProvider with ChangeNotifier {
  final ProjectRepository _repo;
  Map<String, double> _prices = {};

  CalculatorProvider(this._repo) {
    _loadPrices();
  }

  Map<String, double> get prices => _prices;

  void _loadPrices() {
    _prices = _repo.getCustomPrices();
    notifyListeners();
  }

  double getPrice(String key) {
    if (_prices.containsKey(key)) {
      return _prices[key]!;
    }
    // Fallbacks
    switch (key) {
      case 'semen_sak':
        return MaterialDefaultPrices.semenSak;
      case 'pasir':
        return MaterialDefaultPrices.pasir;
      case 'kerikil':
        return MaterialDefaultPrices.kerikil;
      case 'air':
        return MaterialDefaultPrices.air;
      case 'batu_belah':
        return MaterialDefaultPrices.batuBelah;
      case 'bata_merah':
        return MaterialDefaultPrices.bataMerah;
      case 'hebel':
        return MaterialDefaultPrices.hebel;
      case 'semen_acian_sak':
        return MaterialDefaultPrices.semenAcianSak;
      case 'keramik_30':
        return MaterialDefaultPrices.keramik30x30;
      case 'keramik_40':
        return MaterialDefaultPrices.keramik40x40;
      case 'keramik_60':
        return MaterialDefaultPrices.keramik60x60;
      case 'keramik_80':
        return MaterialDefaultPrices.keramik80x80;
      case 'genteng_tanah':
        return MaterialDefaultPrices.gentengTanah;
      case 'genteng_metal':
        return MaterialDefaultPrices.gentengMetal;
      case 'genteng_aspal':
        return MaterialDefaultPrices.gentengAspal;
      case 'kayu_usuk':
        return MaterialDefaultPrices.usukWood;
      case 'kayu_reng':
        return MaterialDefaultPrices.rengWood;
      case 'cat_liter':
        return MaterialDefaultPrices.catLiter;
      default:
        return 0.0;
    }
  }

  Future<void> updatePrice(String key, double price) async {
    _prices[key] = price;
    await _repo.saveCustomPrices(_prices);
    notifyListeners();
  }

  Future<void> resetPrices() async {
    _prices.clear();
    await _repo.saveCustomPrices(_prices);
    notifyListeners();
  }

  CalculationResult performCalculation({
    required CalculationCategory category,
    required Map<String, String> inputs,
  }) {
    // Collect active price mapping
    final Map<String, double> activePrices = {};
    
    // Resolve all possible keys
    final keys = [
      'semen_sak', 'pasir', 'kerikil', 'air', 'batu_belah', 
      'bata_merah', 'hebel', 'semen_acian_sak', 
      'keramik_30', 'keramik_40', 'keramik_60', 'keramik_80', 
      'genteng_tanah', 'genteng_metal', 'genteng_aspal', 
      'kayu_usuk', 'kayu_reng', 'cat_liter'
    ];
    
    for (var key in keys) {
      activePrices[key] = getPrice(key);
    }

    switch (category) {
      case CalculationCategory.beton:
        final vol = double.tryParse(inputs['volume'] ?? '') ?? 0.0;
        final grade = inputs['mutu'] ?? 'K-175';
        return Formulas.calculateBeton(
          volume: vol,
          mutu: grade,
          prices: activePrices,
        );
      case CalculationCategory.pondasi:
        final p = double.tryParse(inputs['panjang'] ?? '') ?? 0.0;
        final l = double.tryParse(inputs['lebar'] ?? '') ?? 0.0;
        final t = double.tryParse(inputs['kedalaman'] ?? '') ?? 0.0;
        return Formulas.calculatePondasi(
          panjang: p,
          lebar: l,
          kedalaman: t,
          prices: activePrices,
        );
      case CalculationCategory.dinding:
        final p = double.tryParse(inputs['panjang'] ?? '') ?? 0.0;
        final t = double.tryParse(inputs['tinggi'] ?? '') ?? 0.0;
        final type = inputs['jenisBata'] ?? 'Merah';
        return Formulas.calculateDinding(
          panjang: p,
          tinggi: t,
          jenisBata: type,
          prices: activePrices,
        );
      case CalculationCategory.plester:
        final area = double.tryParse(inputs['luas'] ?? '') ?? 0.0;
        final thick = double.tryParse(inputs['tebalPlester'] ?? '') ?? 1.5;
        return Formulas.calculatePlesterAcian(
          luas: area,
          tebalPlester: thick,
          prices: activePrices,
        );
      case CalculationCategory.keramik:
        final p = double.tryParse(inputs['panjang'] ?? '') ?? 0.0;
        final l = double.tryParse(inputs['lebar'] ?? '') ?? 0.0;
        final size = inputs['ukuran'] ?? '30x30';
        return Formulas.calculateKeramik(
          panjang: p,
          lebar: l,
          ukuran: size,
          prices: activePrices,
        );
      case CalculationCategory.atap:
        final area = double.tryParse(inputs['luas'] ?? '') ?? 0.0;
        final type = inputs['jenisGenteng'] ?? 'Tanah';
        return Formulas.calculateAtap(
          luas: area,
          jenisGenteng: type,
          prices: activePrices,
        );
      case CalculationCategory.cat:
        final area = double.tryParse(inputs['luas'] ?? '') ?? 0.0;
        final coats = int.tryParse(inputs['lapisan'] ?? '') ?? 2;
        return Formulas.calculateCat(
          luas: area,
          lapisan: coats,
          prices: activePrices,
        );
    }
  }
}
