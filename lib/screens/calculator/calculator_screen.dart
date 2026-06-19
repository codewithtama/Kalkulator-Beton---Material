import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../widgets/input_field.dart';
import '../result/result_screen.dart';

class CalculatorScreen extends StatefulWidget {
  final CalculationCategory category;
  final String? projectId;
  final Map<String, String>? initialInputs;

  const CalculatorScreen({
    super.key,
    required this.category,
    this.projectId,
    this.initialInputs,
  });

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final _formKey = GlobalKey<FormState>();

  // Text Controllers
  final Map<String, TextEditingController> _controllers = {};

  // Dropdown States
  String _selectedMutuBeton = 'K-175';
  String _selectedJenisBata = 'Merah';
  String _selectedUkuranKeramik = '30x30';
  String _selectedJenisGenteng = 'Tanah';
  int _selectedCatLapisan = 2;

  // New Dropdown States
  String _selectedAdukanPondasi = '1:4';
  int _selectedBesiUtama = 10;
  int _selectedJumlahUtama = 4;
  int _selectedBesiBegel = 6;
  bool _isBekistingEnabled = true;
  String _selectedMutuBetonStruktur = 'K-225';

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    final initVal = widget.initialInputs;
    
    // Helper to get initial values
    String txt(String key, {String def = ''}) {
      return initVal?[key] ?? def;
    }

    switch (widget.category) {
      case CalculationCategory.beton:
        _controllers['volume'] = TextEditingController(text: txt('volume'));
        _selectedMutuBeton = txt('mutu', def: 'K-175');
        break;
      case CalculationCategory.pondasi:
        _controllers['panjang'] = TextEditingController(text: txt('panjang'));
        _controllers['lebar'] = TextEditingController(text: txt('lebar'));
        _controllers['kedalaman'] = TextEditingController(text: txt('kedalaman'));
        break;
      case CalculationCategory.dinding:
        _controllers['panjang'] = TextEditingController(text: txt('panjang'));
        _controllers['tinggi'] = TextEditingController(text: txt('tinggi'));
        _selectedJenisBata = txt('jenisBata', def: 'Merah');
        break;
      case CalculationCategory.plester:
        _controllers['luas'] = TextEditingController(text: txt('luas'));
        _controllers['tebalPlester'] = TextEditingController(text: txt('tebalPlester', def: '1.5'));
        break;
      case CalculationCategory.keramik:
        _controllers['panjang'] = TextEditingController(text: txt('panjang'));
        _controllers['lebar'] = TextEditingController(text: txt('lebar'));
        _selectedUkuranKeramik = txt('ukuran', def: '30x30');
        break;
      case CalculationCategory.atap:
        _controllers['luas'] = TextEditingController(text: txt('luas'));
        _selectedJenisGenteng = txt('jenisGenteng', def: 'Tanah');
        break;
      case CalculationCategory.cat:
        _controllers['luas'] = TextEditingController(text: txt('luas'));
        _selectedCatLapisan = int.tryParse(txt('lapisan', def: '2')) ?? 2;
        break;
      case CalculationCategory.pondasiBatuKali:
        _controllers['panjang'] = TextEditingController(text: txt('panjang'));
        _controllers['lebarAtas'] = TextEditingController(text: txt('lebarAtas', def: '0.3'));
        _controllers['lebarBawah'] = TextEditingController(text: txt('lebarBawah', def: '0.6'));
        _controllers['tinggi'] = TextEditingController(text: txt('tinggi', def: '0.8'));
        _selectedAdukanPondasi = txt('adukan', def: '1:4');
        break;
      case CalculationCategory.kolomBalok:
        _controllers['panjang'] = TextEditingController(text: txt('panjang'));
        _controllers['lebar'] = TextEditingController(text: txt('lebar', def: '15'));
        _controllers['tinggi'] = TextEditingController(text: txt('tinggi', def: '15'));
        _selectedBesiUtama = int.tryParse(txt('diameterUtama', def: '10')) ?? 10;
        _selectedJumlahUtama = int.tryParse(txt('jumlahUtama', def: '4')) ?? 4;
        _selectedBesiBegel = int.tryParse(txt('diameterBegel', def: '6')) ?? 6;
        _controllers['jarakBegel'] = TextEditingController(text: txt('jarakBegel', def: '15'));
        _isBekistingEnabled = txt('bekisting', def: 'true') == 'true';
        _selectedMutuBetonStruktur = txt('mutuBeton', def: 'K-225');
        break;
      case CalculationCategory.bajaRingan:
        _controllers['luasAtap'] = TextEditingController(text: txt('luasAtap'));
        break;
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _submitCalculation() {
    if (!_formKey.currentState!.validate()) return;

    // Build inputs map
    final Map<String, String> inputs = {};
    _controllers.forEach((key, controller) {
      inputs[key] = controller.text;
    });

    // Add selected dropdown values to inputs
    switch (widget.category) {
      case CalculationCategory.beton:
        inputs['mutu'] = _selectedMutuBeton;
        break;
      case CalculationCategory.dinding:
        inputs['jenisBata'] = _selectedJenisBata;
        break;
      case CalculationCategory.keramik:
        inputs['ukuran'] = _selectedUkuranKeramik;
        break;
      case CalculationCategory.atap:
        inputs['jenisGenteng'] = _selectedJenisGenteng;
        break;
      case CalculationCategory.cat:
        inputs['lapisan'] = _selectedCatLapisan.toString();
        break;
      case CalculationCategory.pondasiBatuKali:
        inputs['adukan'] = _selectedAdukanPondasi;
        break;
      case CalculationCategory.kolomBalok:
        inputs['diameterUtama'] = _selectedBesiUtama.toString();
        inputs['jumlahUtama'] = _selectedJumlahUtama.toString();
        inputs['diameterBegel'] = _selectedBesiBegel.toString();
        inputs['bekisting'] = _isBekistingEnabled.toString();
        inputs['mutuBeton'] = _selectedMutuBetonStruktur;
        break;
      default:
        break;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          category: widget.category,
          inputs: inputs,
          projectId: widget.projectId,
        ),
      ),
    );
  }

  Widget _buildCategoryInputs() {
    switch (widget.category) {
      case CalculationCategory.beton:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomInputField(
              controller: _controllers['volume']!,
              labelText: 'Volume Beton',
              suffixText: 'm³',
              hintText: 'Contoh: 5.5',
            ),
            const SizedBox(height: 8),
            const Text(
              'Mutu Beton (SNI)',
              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF263238)),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _selectedMutuBeton,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              items: ['K-175', 'K-225', 'K-250', 'K-300'].map((String val) {
                return DropdownMenuItem<String>(
                  value: val,
                  child: Text(val, style: const TextStyle(fontWeight: FontWeight.bold)),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() => _selectedMutuBeton = val);
                }
              },
            ),
          ],
        );

      case CalculationCategory.pondasi:
        return Column(
          children: [
            CustomInputField(
              controller: _controllers['panjang']!,
              labelText: 'Panjang Pondasi',
              suffixText: 'm',
              hintText: 'Contoh: 12.0',
            ),
            CustomInputField(
              controller: _controllers['lebar']!,
              labelText: 'Lebar Pondasi / Galian',
              suffixText: 'm',
              hintText: 'Contoh: 0.6',
            ),
            CustomInputField(
              controller: _controllers['kedalaman']!,
              labelText: 'Kedalaman Galian',
              suffixText: 'm',
              hintText: 'Contoh: 0.8',
            ),
          ],
        );

      case CalculationCategory.dinding:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomInputField(
              controller: _controllers['panjang']!,
              labelText: 'Panjang Dinding',
              suffixText: 'm',
              hintText: 'Contoh: 15.0',
            ),
            CustomInputField(
              controller: _controllers['tinggi']!,
              labelText: 'Tinggi Dinding',
              suffixText: 'm',
              hintText: 'Contoh: 3.2',
            ),
            const SizedBox(height: 8),
            const Text(
              'Jenis Bata',
              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF263238)),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _selectedJenisBata,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              items: ['Merah', 'Hebel'].map((String val) {
                return DropdownMenuItem<String>(
                  value: val,
                  child: Text(val == 'Merah' ? 'Bata Merah (Tradisional)' : 'Bata Ringan (Hebel) 10cm',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() => _selectedJenisBata = val);
                }
              },
            ),
          ],
        );

      case CalculationCategory.plester:
        return Column(
          children: [
            CustomInputField(
              controller: _controllers['luas']!,
              labelText: 'Luas Dinding',
              suffixText: 'm²',
              hintText: 'Contoh: 48.0',
            ),
            CustomInputField(
              controller: _controllers['tebalPlester']!,
              labelText: 'Ketebalan Plester',
              suffixText: 'cm',
              hintText: 'Default: 1.5',
            ),
          ],
        );

      case CalculationCategory.keramik:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomInputField(
              controller: _controllers['panjang']!,
              labelText: 'Panjang Ruangan',
              suffixText: 'm',
              hintText: 'Contoh: 4.0',
            ),
            CustomInputField(
              controller: _controllers['lebar']!,
              labelText: 'Lebar Ruangan',
              suffixText: 'm',
              hintText: 'Contoh: 3.0',
            ),
            const SizedBox(height: 8),
            const Text(
              'Ukuran Keramik',
              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF263238)),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _selectedUkuranKeramik,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              items: ['30x30', '40x40', '60x60', '80x80'].map((String val) {
                return DropdownMenuItem<String>(
                  value: val,
                  child: Text('$val cm', style: const TextStyle(fontWeight: FontWeight.bold)),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() => _selectedUkuranKeramik = val);
                }
              },
            ),
          ],
        );

      case CalculationCategory.atap:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomInputField(
              controller: _controllers['luas']!,
              labelText: 'Luas Atap',
              suffixText: 'm²',
              hintText: 'Contoh: 120.0',
            ),
            const SizedBox(height: 8),
            const Text(
              'Jenis Penutup Atap (Genteng)',
              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF263238)),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _selectedJenisGenteng,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              items: ['Tanah', 'Metal', 'Aspal'].map((String val) {
                return DropdownMenuItem<String>(
                  value: val,
                  child: Text(
                    val == 'Tanah'
                        ? 'Genteng Tanah Liat'
                        : val == 'Metal'
                            ? 'Genteng Metal Sheet'
                            : 'Genteng Aspal (Shingle)',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() => _selectedJenisGenteng = val);
                }
              },
            ),
          ],
        );

      case CalculationCategory.cat:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomInputField(
              controller: _controllers['luas']!,
              labelText: 'Luas Dinding',
              suffixText: 'm²',
              hintText: 'Contoh: 60.0',
            ),
            const SizedBox(height: 8),
            const Text(
              'Jumlah Lapisan Cat',
              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF263238)),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              initialValue: _selectedCatLapisan,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              items: [1, 2, 3, 4].map((int val) {
                return DropdownMenuItem<int>(
                  value: val,
                  child: Text('$val Lapis ${val == 2 ? "(Rekomendasi)" : ""}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() => _selectedCatLapisan = val);
                }
              },
            ),
          ],
        );

      case CalculationCategory.pondasiBatuKali:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomInputField(
              controller: _controllers['panjang']!,
              labelText: 'Panjang Pondasi',
              suffixText: 'm',
              hintText: 'Contoh: 12.0',
            ),
            CustomInputField(
              controller: _controllers['lebarAtas']!,
              labelText: 'Lebar Atas Pondasi',
              suffixText: 'm',
              hintText: 'Contoh: 0.3',
            ),
            CustomInputField(
              controller: _controllers['lebarBawah']!,
              labelText: 'Lebar Bawah Pondasi',
              suffixText: 'm',
              hintText: 'Contoh: 0.6',
            ),
            CustomInputField(
              controller: _controllers['tinggi']!,
              labelText: 'Tinggi Pondasi / Kedalaman',
              suffixText: 'm',
              hintText: 'Contoh: 0.8',
            ),
            const SizedBox(height: 8),
            const Text(
              'Perbandingan Campuran Semen & Pasir (SNI)',
              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF263238)),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _selectedAdukanPondasi,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              items: ['1:3', '1:4', '1:5', '1:6'].map((String val) {
                return DropdownMenuItem<String>(
                  value: val,
                  child: Text('Campuran $val', style: const TextStyle(fontWeight: FontWeight.bold)),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() => _selectedAdukanPondasi = val);
                }
              },
            ),
          ],
        );

      case CalculationCategory.kolomBalok:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomInputField(
              controller: _controllers['panjang']!,
              labelText: 'Panjang Total Struktur (Kolom/Balok/Sloof)',
              suffixText: 'm',
              hintText: 'Contoh: 12.0',
            ),
            Row(
              children: [
                Expanded(
                  child: CustomInputField(
                    controller: _controllers['lebar']!,
                    labelText: 'Lebar Penampang',
                    suffixText: 'cm',
                    hintText: '15',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomInputField(
                    controller: _controllers['tinggi']!,
                    labelText: 'Tinggi Penampang',
                    suffixText: 'cm',
                    hintText: '15',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Besi Utama',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF263238)),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<int>(
                        initialValue: _selectedBesiUtama,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                        ),
                        items: [8, 10, 12, 16].map((int val) {
                          return DropdownMenuItem<int>(
                            value: val,
                            child: Text('Ø $val mm', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedBesiUtama = val);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Jumlah Batang',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF263238)),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<int>(
                        initialValue: _selectedJumlahUtama,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                        ),
                        items: [4, 6].map((int val) {
                          return DropdownMenuItem<int>(
                            value: val,
                            child: Text('$val bh', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedJumlahUtama = val);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Besi Begel',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF263238)),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<int>(
                        initialValue: _selectedBesiBegel,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                        ),
                        items: [6, 8].map((int val) {
                          return DropdownMenuItem<int>(
                            value: val,
                            child: Text('Ø $val mm', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedBesiBegel = val);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomInputField(
                    controller: _controllers['jarakBegel']!,
                    labelText: 'Jarak Begel',
                    suffixText: 'cm',
                    hintText: '15',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Mutu Beton Struktur (SNI)',
              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF263238)),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _selectedMutuBetonStruktur,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              items: ['K-175', 'K-225', 'K-250', 'K-300'].map((String val) {
                return DropdownMenuItem<String>(
                  value: val,
                  child: Text(val, style: const TextStyle(fontWeight: FontWeight.bold)),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() => _selectedMutuBetonStruktur = val);
                }
              },
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SwitchListTile(
                title: const Text('Gunakan Bekisting', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: const Text('Hitung triplek 9mm, kaso 5x7, & paku', style: TextStyle(fontSize: 11)),
                value: _isBekistingEnabled,
                activeThumbColor: Theme.of(context).primaryColor,
                onChanged: (val) {
                  setState(() => _isBekistingEnabled = val);
                },
              ),
            ),
          ],
        );

      case CalculationCategory.bajaRingan:
        return Column(
          children: [
            CustomInputField(
              controller: _controllers['luasAtap']!,
              labelText: 'Luas Atap',
              suffixText: 'm²',
              hintText: 'Contoh: 120.0',
            ),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hitung ${widget.category.nameIndo}'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Instructions banner
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: Theme.of(context).primaryColor, size: 24),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'Masukkan dimensi yang akurat. Kalkulator menggunakan standard koefisien SNI Indonesia.',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF37474F),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildCategoryInputs(),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _submitCalculation,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calculate),
                      SizedBox(width: 10),
                      Text('Hitung Kebutuhan Material'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
