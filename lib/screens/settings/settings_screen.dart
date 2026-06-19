import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/calculator_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};

  final List<Map<String, String>> _priceFields = [
    {'key': 'semen_sak', 'label': 'Semen (Sak 50kg)', 'unit': 'sak'},
    {'key': 'pasir', 'label': 'Pasir', 'unit': 'm³'},
    {'key': 'kerikil', 'label': 'Kerikil', 'unit': 'm³'},
    {'key': 'air', 'label': 'Air', 'unit': 'liter'},
    {'key': 'batu_belah', 'label': 'Batu Belah', 'unit': 'm³'},
    {'key': 'bata_merah', 'label': 'Bata Merah', 'unit': 'buah'},
    {'key': 'hebel', 'label': 'Bata Ringan (Hebel) 10cm', 'unit': 'buah'},
    {'key': 'semen_acian_sak', 'label': 'Semen Acian (Sak 40kg)', 'unit': 'sak'},
    {'key': 'keramik_30', 'label': 'Keramik 30x30 cm', 'unit': 'buah'},
    {'key': 'keramik_40', 'label': 'Keramik 40x40 cm', 'unit': 'buah'},
    {'key': 'keramik_60', 'label': 'Keramik 60x60 cm', 'unit': 'buah'},
    {'key': 'keramik_80', 'label': 'Keramik 80x80 cm', 'unit': 'buah'},
    {'key': 'genteng_tanah', 'label': 'Genteng Tanah Liat', 'unit': 'buah'},
    {'key': 'genteng_metal', 'label': 'Genteng Metal Sheet', 'unit': 'm²'},
    {'key': 'genteng_aspal', 'label': 'Genteng Aspal', 'unit': 'm²'},
    {'key': 'kayu_usuk', 'label': 'Kayu Usuk 5x7', 'unit': 'batang'},
    {'key': 'kayu_reng', 'label': 'Kayu Reng 2x3', 'unit': 'batang'},
    {'key': 'cat_liter', 'label': 'Cat Dinding', 'unit': 'liter'},
    {'key': 'besi_6', 'label': 'Besi Beton Ø6 mm', 'unit': 'batang'},
    {'key': 'besi_8', 'label': 'Besi Beton Ø8 mm', 'unit': 'batang'},
    {'key': 'besi_10', 'label': 'Besi Beton Ø10 mm', 'unit': 'batang'},
    {'key': 'besi_12', 'label': 'Besi Beton Ø12 mm', 'unit': 'batang'},
    {'key': 'besi_16', 'label': 'Besi Beton Ø16 mm', 'unit': 'batang'},
    {'key': 'kawat_bendrat', 'label': 'Kawat Beton (Bendrat)', 'unit': 'kg'},
    {'key': 'plywood_9mm', 'label': 'Triplek / Plywood 9mm', 'unit': 'lembar'},
    {'key': 'paku', 'label': 'Paku Kayu / Beton', 'unit': 'kg'},
    {'key': 'baja_c', 'label': 'Baja Ringan Canal C-75', 'unit': 'batang'},
    {'key': 'baja_reng', 'label': 'Reng Baja Ringan', 'unit': 'batang'},
    {'key': 'sekrup_truss', 'label': 'Sekrup Rangka (Truss)', 'unit': 'pcs'},
    {'key': 'sekrup_genteng', 'label': 'Sekrup Genteng', 'unit': 'pcs'},
    {'key': 'gypsum_board', 'label': 'Papan Gypsum (1.22x2.44m)', 'unit': 'lembar'},
    {'key': 'hollow_4x4', 'label': 'Besi Hollow 4x4 cm', 'unit': 'batang'},
    {'key': 'hollow_2x4', 'label': 'Besi Hollow 2x4 cm', 'unit': 'batang'},
    {'key': 'sekrup_plafon', 'label': 'Sekrup Gypsum', 'unit': 'pcs'},
    {'key': 'compound_gypsum', 'label': 'Compound Gypsum', 'unit': 'kg'},
    {'key': 'tape_gypsum', 'label': 'Tape Gypsum', 'unit': 'roll'},
    {'key': 'paving_block', 'label': 'Paving Block', 'unit': 'pcs'},
    {'key': 'kanstin', 'label': 'Kanstin Beton Pembatas', 'unit': 'pcs'},
    {'key': 'metal_stud', 'label': 'Metal Stud 7.5cm', 'unit': 'batang'},
    {'key': 'runner', 'label': 'U-Runner 7.5cm', 'unit': 'batang'},
    {'key': 'daun_panel', 'label': 'Daun Panel Precast', 'unit': 'lembar'},
    {'key': 'tiang_kolom_precast', 'label': 'Tiang Precast Beton', 'unit': 'batang'},
    {'key': 'keramik_dinding', 'label': 'Keramik Dinding 30x60 cm', 'unit': 'dus'},
    {'key': 'semen_instan', 'label': 'Semen Instan Perekat', 'unit': 'sak'},
    {'key': 'semen_nat', 'label': 'Semen Pengisi Nat', 'unit': 'kg'},
    {'key': 'waterproofing_liquid', 'label': 'Cairan Waterproofing Pelapis', 'unit': 'kg'},
    {'key': 'sirtu', 'label': 'Material Sirtu Urug', 'unit': 'm³'},
    // New Materials
    {'key': 'bondex', 'label': 'Lembar Bondex (6m)', 'unit': 'lembar'},
    {'key': 'wiremesh_m6', 'label': 'Kawat Wiremesh M6', 'unit': 'lembar'},
    {'key': 'wiremesh_m8', 'label': 'Kawat Wiremesh M8', 'unit': 'lembar'},
    {'key': 'wiremesh_m10', 'label': 'Kawat Wiremesh M10', 'unit': 'lembar'},
    {'key': 'tanah_urug', 'label': 'Tanah Urug Merah', 'unit': 'm³'},
    {'key': 'batako', 'label': 'Batako Berongga', 'unit': 'buah'},
    {'key': 'glass_block', 'label': 'Glass Block Dekorasi', 'unit': 'buah'},
    {'key': 'kusen_aluminium', 'label': 'Kusen Aluminium (6m)', 'unit': 'batang'},
    {'key': 'sealant', 'label': 'Sealant Silikon Kusen', 'unit': 'tube'},
    {'key': 'buis_beton', 'label': 'Buis Beton Saluran/Sumur', 'unit': 'buah'},
    {'key': 'plafon_pvc', 'label': 'Papan Plafon PVC (4m)', 'unit': 'lembar'},
    {'key': 'lis_pvc', 'label': 'Lis Profil PVC', 'unit': 'm¹'},
    {'key': 'plint_keramik', 'label': 'Plint Lantai Keramik', 'unit': 'buah'},
    {'key': 'balok_kayu', 'label': 'Kayu Balok Kusen Pintu', 'unit': 'm³'},
    {'key': 'lem_kayu', 'label': 'Lem Kayu Konstruksi', 'unit': 'kg'},
    {'key': 'plat_checker', 'label': 'Plat Besi Checker', 'unit': 'buah'},
    {'key': 'grass_block', 'label': 'Grass Block Paving', 'unit': 'buah'},
    {'key': 'polycarbonate', 'label': 'Atap Polycarbonate', 'unit': 'm²'},
    {'key': 'spandek', 'label': 'Atap Spandek Metal', 'unit': 'm²'},
    {'key': 'pipa_stainless', 'label': 'Pipa Stainless Steel (6m)', 'unit': 'batang'},
    {'key': 'baja_wf150', 'label': 'Struktur Baja WF-150', 'unit': 'batang'},
    {'key': 'baja_wf200', 'label': 'Struktur Baja WF-200', 'unit': 'batang'},
    {'key': 'baja_wf250', 'label': 'Struktur Baja WF-250', 'unit': 'batang'},
    {'key': 'cat_anti_karat', 'label': 'Cat Dasar Anti Karat', 'unit': 'kg'},
    {'key': 'pipa_pvc_aw', 'label': 'Pipa PVC AW Bersih (4m)', 'unit': 'batang'},
    {'key': 'pipa_pvc_d', 'label': 'Pipa PVC D Kotor (4m)', 'unit': 'batang'},
    {'key': 'fitting_pvc', 'label': 'Fitting Aksesoris PVC', 'unit': 'buah'},
    {'key': 'lem_pipa', 'label': 'Lem Pipa PVC Solvent', 'unit': 'tube'},
    {'key': 'seal_tape', 'label': 'Seal Tape Pipa Kran', 'unit': 'roll'},
  ];

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<CalculatorProvider>(context, listen: false);
    for (var field in _priceFields) {
      final key = field['key']!;
      final currentPrice = provider.getPrice(key);
      _controllers[key] = TextEditingController(text: currentPrice.toStringAsFixed(0));
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _savePrices() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = Provider.of<CalculatorProvider>(context, listen: false);
    for (var field in _priceFields) {
      final key = field['key']!;
      final price = double.tryParse(_controllers[key]!.text) ?? 0.0;
      await provider.updatePrice(key, price);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harga material berhasil disimpan!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _resetPrices() async {
    final provider = Provider.of<CalculatorProvider>(context, listen: false);
    await provider.resetPrices();
    
    for (var field in _priceFields) {
      final key = field['key']!;
      final currentPrice = provider.getPrice(key);
      _controllers[key]!.text = currentPrice.toStringAsFixed(0);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harga material dikembalikan ke default.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan Harga'),
        actions: [
          IconButton(
            icon: const Icon(Icons.restore),
            tooltip: 'Reset ke Default',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Reset Harga?'),
                  content: const Text('Semua harga material akan dikembalikan ke nilai standar SNI default.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _resetPrices();
                      },
                      child: const Text('Reset', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _priceFields.length,
                  itemBuilder: (context, index) {
                    final field = _priceFields[index];
                    final key = field['key']!;
                    final label = field['label']!;
                    final unit = field['unit']!;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8.0),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade200),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    label,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    'Satuan: per $unit',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                controller: _controllers[key],
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.right,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Kosong';
                                  }
                                  if (double.tryParse(value) == null) {
                                    return 'Invalid';
                                  }
                                  if (double.parse(value) < 0) {
                                    return 'Negatif';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  prefixText: 'Rp ',
                                  prefixStyle: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  filled: true,
                                  fillColor: Colors.grey.shade500.withValues(alpha: 0.05),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _savePrices,
                    child: const Text('Simpan Perubahan'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
