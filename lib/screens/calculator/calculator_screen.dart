import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../widgets/input_field.dart';
import '../result/result_screen.dart';

class CalculatorScreen extends StatefulWidget {
  final CalculationCategory category;

  const CalculatorScreen({super.key, required this.category});

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

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    switch (widget.category) {
      case CalculationCategory.beton:
        _controllers['volume'] = TextEditingController();
        break;
      case CalculationCategory.pondasi:
        _controllers['panjang'] = TextEditingController();
        _controllers['lebar'] = TextEditingController();
        _controllers['kedalaman'] = TextEditingController();
        break;
      case CalculationCategory.dinding:
        _controllers['panjang'] = TextEditingController();
        _controllers['tinggi'] = TextEditingController();
        break;
      case CalculationCategory.plester:
        _controllers['luas'] = TextEditingController();
        _controllers['tebalPlester'] = TextEditingController(text: '1.5');
        break;
      case CalculationCategory.keramik:
        _controllers['panjang'] = TextEditingController();
        _controllers['lebar'] = TextEditingController();
        break;
      case CalculationCategory.atap:
        _controllers['luas'] = TextEditingController();
        break;
      case CalculationCategory.cat:
        _controllers['luas'] = TextEditingController();
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
      default:
        break;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          category: widget.category,
          inputs: inputs,
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
              value: _selectedMutuBeton,
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
              value: _selectedJenisBata,
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
              value: _selectedUkuranKeramik,
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
              value: _selectedJenisGenteng,
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
              value: _selectedCatLapisan,
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
                          color: Theme.of(context).primaryColor.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Theme.of(context).primaryColor.withOpacity(0.2),
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
