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
      case 'besi_6':
        return MaterialDefaultPrices.besi6;
      case 'besi_8':
        return MaterialDefaultPrices.besi8;
      case 'besi_10':
        return MaterialDefaultPrices.besi10;
      case 'besi_12':
        return MaterialDefaultPrices.besi12;
      case 'besi_16':
        return MaterialDefaultPrices.besi16;
      case 'kawat_bendrat':
        return MaterialDefaultPrices.kawatBendrat;
      case 'plywood_9mm':
        return MaterialDefaultPrices.plywood9mm;
      case 'paku':
        return MaterialDefaultPrices.paku;
      case 'baja_c':
        return MaterialDefaultPrices.bajaC;
      case 'baja_reng':
        return MaterialDefaultPrices.bajaReng;
      case 'sekrup_truss':
        return MaterialDefaultPrices.sekrupTruss;
      case 'sekrup_genteng':
        return MaterialDefaultPrices.sekrupGenteng;
      case 'gypsum_board':
        return MaterialDefaultPrices.gypsumBoard;
      case 'hollow_4x4':
        return MaterialDefaultPrices.hollow4x4;
      case 'hollow_2x4':
        return MaterialDefaultPrices.hollow2x4;
      case 'sekrup_plafon':
        return MaterialDefaultPrices.sekrupPlafon;
      case 'compound_gypsum':
        return MaterialDefaultPrices.compoundGypsum;
      case 'tape_gypsum':
        return MaterialDefaultPrices.tapeGypsum;
      case 'paving_block':
        return MaterialDefaultPrices.pavingBlock;
      case 'kanstin':
        return MaterialDefaultPrices.kanstin;
      case 'metal_stud':
        return MaterialDefaultPrices.metalStud;
      case 'runner':
        return MaterialDefaultPrices.runner;
      case 'daun_panel':
        return MaterialDefaultPrices.daunPanel;
      case 'tiang_kolom_precast':
        return MaterialDefaultPrices.tiangKolomPrecast;
      case 'keramik_dinding':
        return MaterialDefaultPrices.keramikDinding;
      case 'semen_instan':
        return MaterialDefaultPrices.semenInstan;
      case 'semen_nat':
        return MaterialDefaultPrices.semenNat;
      case 'waterproofing_liquid':
        return MaterialDefaultPrices.waterproofingLiquid;
      case 'sirtu':
        return MaterialDefaultPrices.sirtu;
      // 20 New Calculator Materials
      case 'bondex':
        return MaterialDefaultPrices.bondex;
      case 'wiremesh_m6':
        return MaterialDefaultPrices.wiremeshM6;
      case 'wiremesh_m8':
        return MaterialDefaultPrices.wiremeshM8;
      case 'wiremesh_m10':
        return MaterialDefaultPrices.wiremeshM10;
      case 'tanah_urug':
        return MaterialDefaultPrices.tanahUrug;
      case 'batako':
        return MaterialDefaultPrices.batako;
      case 'glass_block':
        return MaterialDefaultPrices.glassBlock;
      case 'kusen_aluminium':
        return MaterialDefaultPrices.kusenAluminium;
      case 'sealant':
        return MaterialDefaultPrices.sealant;
      case 'buis_beton':
        return MaterialDefaultPrices.buisBeton;
      case 'plafon_pvc':
        return MaterialDefaultPrices.plafonPvc;
      case 'lis_pvc':
        return MaterialDefaultPrices.lisPvc;
      case 'plint_keramik':
        return MaterialDefaultPrices.plintKeramik;
      case 'balok_kayu':
        return MaterialDefaultPrices.balokKayu;
      case 'lem_kayu':
        return MaterialDefaultPrices.lemKayu;
      case 'plat_checker':
        return MaterialDefaultPrices.platChecker;
      case 'grass_block':
        return MaterialDefaultPrices.grassBlock;
      case 'polycarbonate':
        return MaterialDefaultPrices.polycarbonate;
      case 'spandek':
        return MaterialDefaultPrices.spandek;
      case 'pipa_stainless':
        return MaterialDefaultPrices.pipaStainless;
      case 'baja_wf150':
        return MaterialDefaultPrices.bajaWf150;
      case 'baja_wf200':
        return MaterialDefaultPrices.bajaWf200;
      case 'baja_wf250':
        return MaterialDefaultPrices.bajaWf250;
      case 'cat_anti_karat':
        return MaterialDefaultPrices.catAntiKarat;
      case 'pipa_pvc_aw':
        return MaterialDefaultPrices.pipaPvcAW;
      case 'pipa_pvc_d':
        return MaterialDefaultPrices.pipaPvcD;
      case 'fitting_pvc':
        return MaterialDefaultPrices.fittingPvc;
      case 'lem_pipa':
        return MaterialDefaultPrices.lemPipa;
      case 'seal_tape':
        return MaterialDefaultPrices.sealTape;
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
      'kayu_usuk', 'kayu_reng', 'cat_liter',
      'besi_6', 'besi_8', 'besi_10', 'besi_12', 'besi_16',
      'kawat_bendrat', 'plywood_9mm', 'paku',
      'baja_c', 'baja_reng', 'sekrup_truss', 'sekrup_genteng',
      'gypsum_board', 'hollow_4x4', 'hollow_2x4', 'sekrup_plafon', 
      'compound_gypsum', 'tape_gypsum', 'paving_block', 'kanstin', 
      'metal_stud', 'runner', 'daun_panel', 'tiang_kolom_precast', 
      'keramik_dinding', 'semen_instan', 'semen_nat', 
      'waterproofing_liquid', 'sirtu',
      // New ones
      'bondex', 'wiremesh_m6', 'wiremesh_m8', 'wiremesh_m10',
      'tanah_urug', 'batako', 'glass_block', 'kusen_aluminium',
      'sealant', 'buis_beton', 'plafon_pvc', 'lis_pvc', 'plint_keramik',
      'balok_kayu', 'lem_kayu', 'plat_checker', 'grass_block',
      'polycarbonate', 'spandek', 'pipa_stainless', 'baja_wf150',
      'baja_wf200', 'baja_wf250', 'cat_anti_karat', 'pipa_pvc_aw',
      'pipa_pvc_d', 'fitting_pvc', 'lem_pipa', 'seal_tape'
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
      case CalculationCategory.pondasiBatuKali:
        final p = double.tryParse(inputs['panjang'] ?? '') ?? 0.0;
        final la = double.tryParse(inputs['lebarAtas'] ?? '') ?? 0.0;
        final lb = double.tryParse(inputs['lebarBawah'] ?? '') ?? 0.0;
        final t = double.tryParse(inputs['tinggi'] ?? '') ?? 0.0;
        final adukan = inputs['adukan'] ?? '1:4';
        return Formulas.calculatePondasiBatuKali(
          panjang: p,
          lebarAtas: la,
          lebarBawah: lb,
          tinggi: t,
          adukan: adukan,
          prices: activePrices,
        );
      case CalculationCategory.kolomBalok:
        final p = double.tryParse(inputs['panjang'] ?? '') ?? 0.0;
        final l = double.tryParse(inputs['lebar'] ?? '') ?? 0.0;
        final t = double.tryParse(inputs['tinggi'] ?? '') ?? 0.0;
        final dUtama = int.tryParse(inputs['diameterUtama'] ?? '') ?? 10;
        final jUtama = int.tryParse(inputs['jumlahUtama'] ?? '') ?? 4;
        final dBegel = int.tryParse(inputs['diameterBegel'] ?? '') ?? 6;
        final jBegel = double.tryParse(inputs['jarakBegel'] ?? '') ?? 15.0;
        final bekisting = inputs['bekisting'] == 'true';
        final mutu = inputs['mutuBeton'] ?? 'K-225';
        return Formulas.calculateKolomBalok(
          panjang: p,
          lebarCm: l,
          tinggiCm: t,
          diameterUtama: dUtama,
          jumlahUtama: jUtama,
          diameterBegel: dBegel,
          jarakBegelCm: jBegel,
          bekisting: bekisting,
          mutuBeton: mutu,
          prices: activePrices,
        );
      case CalculationCategory.bajaRingan:
        final area = double.tryParse(inputs['luasAtap'] ?? '') ?? 0.0;
        return Formulas.calculateBajaRingan(
          luasAtap: area,
          prices: activePrices,
        );
      case CalculationCategory.plafon:
        final area = double.tryParse(inputs['luas'] ?? '') ?? 0.0;
        return Formulas.calculatePlafon(
          luas: area,
          prices: activePrices,
        );
      case CalculationCategory.tangga:
        final anak = int.tryParse(inputs['anakTangga'] ?? '') ?? 0;
        final l = double.tryParse(inputs['lebar'] ?? '') ?? 0.0;
        final ta = double.tryParse(inputs['tinggiAnak'] ?? '') ?? 0.0;
        final la = double.tryParse(inputs['lebarAlas'] ?? '') ?? 0.0;
        final tp = double.tryParse(inputs['tebalPlat'] ?? '') ?? 0.0;
        final pb = double.tryParse(inputs['panjangBordes'] ?? '') ?? 0.0;
        final lb = double.tryParse(inputs['lebarBordes'] ?? '') ?? 0.0;
        final tb = double.tryParse(inputs['tebalBordes'] ?? '') ?? 0.0;
        final dUtama = int.tryParse(inputs['diameterUtama'] ?? '') ?? 10;
        final jUtama = double.tryParse(inputs['jarakUtama'] ?? '') ?? 15.0;
        final dBagi = int.tryParse(inputs['diameterBagi'] ?? '') ?? 8;
        final jBagi = double.tryParse(inputs['jarakBagi'] ?? '') ?? 20.0;
        final bekisting = inputs['bekisting'] == 'true';
        final mutu = inputs['mutuBeton'] ?? 'K-225';
        return Formulas.calculateTangga(
          anakTangga: anak,
          lebar: l,
          tinggiAnak: ta,
          lebarAlas: la,
          tebalPlat: tp,
          panjangBordes: pb,
          lebarBordes: lb,
          tebalBordes: tb,
          diameterUtama: dUtama,
          jarakUtama: jUtama,
          diameterBagi: dBagi,
          jarakBagi: jBagi,
          bekisting: bekisting,
          mutuBeton: mutu,
          prices: activePrices,
        );
      case CalculationCategory.paving:
        final area = double.tryParse(inputs['luas'] ?? '') ?? 0.0;
        final pk = double.tryParse(inputs['panjangKanstin'] ?? '') ?? 0.0;
        return Formulas.calculatePaving(
          luas: area,
          panjangKanstin: pk,
          prices: activePrices,
        );
      case CalculationCategory.partisiGypsum:
        final area = double.tryParse(inputs['luas'] ?? '') ?? 0.0;
        return Formulas.calculatePartisiGypsum(
          luas: area,
          prices: activePrices,
        );
      case CalculationCategory.pagarPanel:
        final p = double.tryParse(inputs['panjang'] ?? '') ?? 0.0;
        final t = double.tryParse(inputs['tinggi'] ?? '') ?? 0.0;
        return Formulas.calculatePagarPanel(
          panjang: p,
          tinggi: t,
          prices: activePrices,
        );
      case CalculationCategory.borePile:
        final t = int.tryParse(inputs['titik'] ?? '') ?? 0;
        final dia = double.tryParse(inputs['diameter'] ?? '') ?? 0.0;
        final kd = double.tryParse(inputs['kedalaman'] ?? '') ?? 0.0;
        final dUtama = int.tryParse(inputs['diameterUtama'] ?? '') ?? 12;
        final jUtama = int.tryParse(inputs['jumlahUtama'] ?? '') ?? 6;
        final dSpiral = int.tryParse(inputs['diameterSpiral'] ?? '') ?? 8;
        final jSpiral = double.tryParse(inputs['jarakSpiral'] ?? '') ?? 15.0;
        final mutu = inputs['mutuBeton'] ?? 'K-225';
        return Formulas.calculateBorePile(
          titik: t,
          diameter: dia,
          kedalaman: kd,
          diameterUtama: dUtama,
          jumlahUtama: jUtama,
          diameterSpiral: dSpiral,
          jarakSpiral: jSpiral,
          mutuBeton: mutu,
          prices: activePrices,
        );
      case CalculationCategory.keramikDinding:
        final area = double.tryParse(inputs['luas'] ?? '') ?? 0.0;
        return Formulas.calculateKeramikDinding(
          luas: area,
          prices: activePrices,
        );
      case CalculationCategory.waterproofing:
        final area = double.tryParse(inputs['luas'] ?? '') ?? 0.0;
        return Formulas.calculateWaterproofing(
          luas: area,
          prices: activePrices,
        );
      case CalculationCategory.begelSpiral:
        final t = int.tryParse(inputs['titik'] ?? '') ?? 0;
        final h = double.tryParse(inputs['tinggi'] ?? '') ?? 0.0;
        final dia = double.tryParse(inputs['diameter'] ?? '') ?? 0.0;
        final dSpiral = int.tryParse(inputs['diameterSpiral'] ?? '') ?? 8;
        final jSpiral = double.tryParse(inputs['jarakSpiral'] ?? '') ?? 15.0;
        return Formulas.calculateBegelSpiral(
          titik: t,
          tinggi: h,
          diameter: dia,
          diameterSpiral: dSpiral,
          jarakSpiral: jSpiral,
          prices: activePrices,
        );
      case CalculationCategory.uruganSirtu:
        final p = double.tryParse(inputs['panjang'] ?? '') ?? 0.0;
        final l = double.tryParse(inputs['lebar'] ?? '') ?? 0.0;
        final t = double.tryParse(inputs['tebal'] ?? '') ?? 0.0;
        return Formulas.calculateUruganSirtu(
          panjang: p,
          lebar: l,
          tebal: t,
          prices: activePrices,
        );
      // 20 New Categories
      case CalculationCategory.cakarAyam:
        final p = double.tryParse(inputs['panjang'] ?? '') ?? 0.0;
        final l = double.tryParse(inputs['lebar'] ?? '') ?? 0.0;
        final t = double.tryParse(inputs['tebal'] ?? '') ?? 0.0;
        final dUtama = int.tryParse(inputs['diameterUtama'] ?? '') ?? 10;
        final jBesi = double.tryParse(inputs['jarakBesi'] ?? '') ?? 15.0;
        final mutu = inputs['mutuBeton'] ?? 'K-225';
        return Formulas.calculateCakarAyam(
          panjang: p,
          lebar: l,
          tebal: t,
          diameterBesi: dUtama,
          jarakBesi: jBesi,
          mutuBeton: mutu,
          prices: activePrices,
        );
      case CalculationCategory.floordeck:
        final p = double.tryParse(inputs['panjang'] ?? '') ?? 0.0;
        final l = double.tryParse(inputs['lebar'] ?? '') ?? 0.0;
        final t = double.tryParse(inputs['tebal'] ?? '') ?? 0.12;
        final wire = inputs['tipeWiremesh'] ?? 'M8';
        final lay = int.tryParse(inputs['layer'] ?? '') ?? 1;
        return Formulas.calculateFloordeck(
          panjang: p,
          lebar: l,
          tebal: t,
          tipeWiremesh: wire,
          layer: lay,
          prices: activePrices,
        );
      case CalculationCategory.platSlab:
        final p = double.tryParse(inputs['panjang'] ?? '') ?? 0.0;
        final l = double.tryParse(inputs['lebar'] ?? '') ?? 0.0;
        final t = double.tryParse(inputs['tebal'] ?? '') ?? 0.12;
        final wire = inputs['tipeWiremesh'] ?? 'M8';
        final lay = int.tryParse(inputs['layer'] ?? '') ?? 1;
        return Formulas.calculatePlatSlab(
          panjang: p,
          lebar: l,
          tebal: t,
          tipeWiremesh: wire,
          layer: lay,
          prices: activePrices,
        );
      case CalculationCategory.cutFill:
        final p = double.tryParse(inputs['panjang'] ?? '') ?? 0.0;
        final l = double.tryParse(inputs['lebar'] ?? '') ?? 0.0;
        final t = double.tryParse(inputs['tebal'] ?? '') ?? 0.0;
        final type = inputs['jenisTanah'] ?? 'Biasa';
        return Formulas.calculateCutFill(
          panjang: p,
          lebar: l,
          tebal: t,
          jenisTanah: type,
          prices: activePrices,
        );
      case CalculationCategory.retainingWall:
        final p = double.tryParse(inputs['panjang'] ?? '') ?? 0.0;
        final h = double.tryParse(inputs['tinggi'] ?? '') ?? 0.0;
        final la = double.tryParse(inputs['lebarAtas'] ?? '') ?? 0.3;
        final lb = double.tryParse(inputs['lebarBawah'] ?? '') ?? 0.8;
        final mix = inputs['campuran'] ?? '1:4';
        return Formulas.calculateRetainingWall(
          panjang: p,
          tinggi: h,
          lebarAtas: la,
          lebarBawah: lb,
          campuran: mix,
          prices: activePrices,
        );
      case CalculationCategory.septicTank:
        final p = double.tryParse(inputs['panjang'] ?? '') ?? 2.0;
        final l = double.tryParse(inputs['lebar'] ?? '') ?? 1.5;
        final h = double.tryParse(inputs['tinggi'] ?? '') ?? 1.5;
        return Formulas.calculateSepticTank(
          panjang: p,
          lebar: l,
          tinggi: h,
          prices: activePrices,
        );
      case CalculationCategory.batako:
        final p = double.tryParse(inputs['panjang'] ?? '') ?? 0.0;
        final t = double.tryParse(inputs['tinggi'] ?? '') ?? 0.0;
        final mix = inputs['campuran'] ?? '1:4';
        return Formulas.calculateBatako(
          panjang: p,
          tinggi: t,
          campuran: mix,
          prices: activePrices,
        );
      case CalculationCategory.glassBlock:
        final p = double.tryParse(inputs['panjang'] ?? '') ?? 0.0;
        final t = double.tryParse(inputs['tinggi'] ?? '') ?? 0.0;
        final size = inputs['ukuran'] ?? '20x20';
        return Formulas.calculateGlassBlock(
          panjang: p,
          tinggi: t,
          ukuran: size,
          prices: activePrices,
        );
      case CalculationCategory.kusenAluminium:
        final w = double.tryParse(inputs['lebar'] ?? '') ?? 0.0;
        final h = double.tryParse(inputs['tinggi'] ?? '') ?? 0.0;
        final prof = inputs['profile'] ?? '3 inch';
        return Formulas.calculateKusenAluminium(
          lebar: w,
          tinggi: h,
          profile: prof,
          prices: activePrices,
        );
      case CalculationCategory.floorScreed:
        final area = double.tryParse(inputs['luas'] ?? '') ?? 0.0;
        final thick = double.tryParse(inputs['tebal'] ?? '') ?? 3.0;
        final mix = inputs['campuran'] ?? '1:4';
        return Formulas.calculateFloorScreed(
          luas: area,
          tebal: thick,
          campuran: mix,
          prices: activePrices,
        );
      case CalculationCategory.pondasiSumuran:
        final dia = double.tryParse(inputs['diameter'] ?? '') ?? 80.0;
        final kd = double.tryParse(inputs['kedalaman'] ?? '') ?? 0.0;
        final points = int.tryParse(inputs['jumlahTitik'] ?? '') ?? 1;
        return Formulas.calculatePondasiSumuran(
          diameter: dia,
          kedalaman: kd,
          jumlahTitik: points,
          prices: activePrices,
        );
      case CalculationCategory.plafonPvc:
        final p = double.tryParse(inputs['panjang'] ?? '') ?? 0.0;
        final l = double.tryParse(inputs['lebar'] ?? '') ?? 0.0;
        return Formulas.calculatePlafonPvc(
          panjang: p,
          lebar: l,
          prices: activePrices,
        );
      case CalculationCategory.plintLantai:
        final kel = double.tryParse(inputs['keliling'] ?? '') ?? 0.0;
        final size = inputs['ukuran'] ?? '10x40';
        return Formulas.calculatePlintLantai(
          keliling: kel,
          ukuran: size,
          prices: activePrices,
        );
      case CalculationCategory.kusenKayu:
        final w = double.tryParse(inputs['lebar'] ?? '') ?? 0.0;
        final h = double.tryParse(inputs['tinggi'] ?? '') ?? 0.0;
        return Formulas.calculateKusenKayu(
          lebar: w,
          tinggi: h,
          prices: activePrices,
        );
      case CalculationCategory.bakKontrol:
        final p = double.tryParse(inputs['panjang'] ?? '') ?? 0.0;
        final l = double.tryParse(inputs['lebar'] ?? '') ?? 0.0;
        final h = double.tryParse(inputs['tinggi'] ?? '') ?? 0.0;
        final qty = int.tryParse(inputs['jumlah'] ?? '') ?? 1;
        return Formulas.calculateBakKontrol(
          panjang: p,
          lebar: l,
          tinggi: h,
          jumlah: qty,
          prices: activePrices,
        );
      case CalculationCategory.grassBlock:
        final area = double.tryParse(inputs['luas'] ?? '') ?? 0.0;
        return Formulas.calculateGrassBlock(
          luas: area,
          prices: activePrices,
        );
      case CalculationCategory.kanopi:
        final p = double.tryParse(inputs['panjang'] ?? '') ?? 0.0;
        final l = double.tryParse(inputs['lebar'] ?? '') ?? 0.0;
        final type = inputs['atapType'] ?? 'Polycarbonate';
        return Formulas.calculateKanopi(
          panjang: p,
          lebar: l,
          atapType: type,
          prices: activePrices,
        );
      case CalculationCategory.railing:
        final p = double.tryParse(inputs['panjang'] ?? '') ?? 0.0;
        final h = double.tryParse(inputs['tinggi'] ?? '') ?? 0.9;
        return Formulas.calculateRailing(
          panjang: p,
          tinggi: h,
          prices: activePrices,
        );
      case CalculationCategory.bajaWf:
        final p = double.tryParse(inputs['panjang'] ?? '') ?? 0.0;
        final type = inputs['tipeWF'] ?? 'WF 200';
        return Formulas.calculateBajaWf(
          panjang: p,
          tipeWF: type,
          prices: activePrices,
        );
      case CalculationCategory.plumbing:
        final p = double.tryParse(inputs['panjang'] ?? '') ?? 0.0;
        final dia = inputs['diameter'] ?? '1/2"';
        return Formulas.calculatePlumbing(
          panjang: p,
          diameter: dia,
          prices: activePrices,
        );
    }
  }
}
