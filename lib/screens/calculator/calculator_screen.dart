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

  // 10 New Category Dropdown & Toggle States
  int _selectedTanggaBesiUtama = 10;
  int _selectedTanggaBesiBagi = 8;
  String _selectedTanggaMutuBeton = 'K-225';
  bool _isTanggaBekisting = true;
  int _selectedBoreUtamaDiameter = 12;
  int _selectedBoreUtamaJumlah = 6;
  int _selectedBoreSpiralDiameter = 8;
  String _selectedBoreMutuBeton = 'K-225';
  int _selectedBegelSpiralDiameter = 8;

  // 20 Newer Calculator States
  String _selectedWiremeshType = 'M8';
  int _selectedLayer = 1;
  String _selectedCompactorTanah = 'Biasa';
  String _selectedRetainingWallCampuran = '1:4';
  String _selectedBatakoCampuran = '1:4';
  String _selectedGlassBlockSize = '20x20';
  String _selectedAluminiumProfile = '3 inch';
  String _selectedFloorScreedCampuran = '1:4';
  String _selectedPlintUkuran = '10x40';
  String _selectedKanopiAtapType = 'Polycarbonate';
  String _selectedBajaTipeWF = 'WF 200';
  String _selectedPlumbingDiameter = '1/2"';

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
      case CalculationCategory.plafon:
        _controllers['luas'] = TextEditingController(text: txt('luas'));
        break;
      case CalculationCategory.tangga:
        _controllers['anakTangga'] = TextEditingController(text: txt('anakTangga', def: '15'));
        _controllers['lebar'] = TextEditingController(text: txt('lebar', def: '1.2'));
        _controllers['tinggiAnak'] = TextEditingController(text: txt('tinggiAnak', def: '18'));
        _controllers['lebarAlas'] = TextEditingController(text: txt('lebarAlas', def: '27'));
        _controllers['tebalPlat'] = TextEditingController(text: txt('tebalPlat', def: '12'));
        _controllers['panjangBordes'] = TextEditingController(text: txt('panjangBordes', def: '1.2'));
        _controllers['lebarBordes'] = TextEditingController(text: txt('lebarBordes', def: '1.2'));
        _controllers['tebalBordes'] = TextEditingController(text: txt('tebalBordes', def: '15'));
        _controllers['jarakUtama'] = TextEditingController(text: txt('jarakUtama', def: '15'));
        _controllers['jarakBagi'] = TextEditingController(text: txt('jarakBagi', def: '20'));
        _selectedTanggaBesiUtama = int.tryParse(txt('diameterUtama', def: '10')) ?? 10;
        _selectedTanggaBesiBagi = int.tryParse(txt('diameterBagi', def: '8')) ?? 8;
        _selectedTanggaMutuBeton = txt('mutuBeton', def: 'K-225');
        _isTanggaBekisting = txt('bekisting', def: 'true') == 'true';
        break;
      case CalculationCategory.paving:
        _controllers['luas'] = TextEditingController(text: txt('luas'));
        _controllers['panjangKanstin'] = TextEditingController(text: txt('panjangKanstin', def: '0.0'));
        break;
      case CalculationCategory.partisiGypsum:
        _controllers['luas'] = TextEditingController(text: txt('luas'));
        break;
      case CalculationCategory.pagarPanel:
        _controllers['panjang'] = TextEditingController(text: txt('panjang'));
        _controllers['tinggi'] = TextEditingController(text: txt('tinggi', def: '2.0'));
        break;
      case CalculationCategory.borePile:
        _controllers['titik'] = TextEditingController(text: txt('titik', def: '1'));
        _controllers['diameter'] = TextEditingController(text: txt('diameter', def: '30'));
        _controllers['kedalaman'] = TextEditingController(text: txt('kedalaman', def: '6.0'));
        _controllers['jarakSpiral'] = TextEditingController(text: txt('jarakSpiral', def: '15'));
        _selectedBoreUtamaDiameter = int.tryParse(txt('diameterUtama', def: '12')) ?? 12;
        _selectedBoreUtamaJumlah = int.tryParse(txt('jumlahUtama', def: '6')) ?? 6;
        _selectedBoreSpiralDiameter = int.tryParse(txt('diameterSpiral', def: '8')) ?? 8;
        _selectedBoreMutuBeton = txt('mutuBeton', def: 'K-225');
        break;
      case CalculationCategory.keramikDinding:
        _controllers['luas'] = TextEditingController(text: txt('luas'));
        break;
      case CalculationCategory.waterproofing:
        _controllers['luas'] = TextEditingController(text: txt('luas'));
        break;
      case CalculationCategory.begelSpiral:
        _controllers['titik'] = TextEditingController(text: txt('titik', def: '1'));
        _controllers['tinggi'] = TextEditingController(text: txt('tinggi', def: '4.0'));
        _controllers['diameter'] = TextEditingController(text: txt('diameter', def: '30'));
        _controllers['jarakSpiral'] = TextEditingController(text: txt('jarakSpiral', def: '15'));
        _selectedBegelSpiralDiameter = int.tryParse(txt('diameterSpiral', def: '8')) ?? 8;
        break;
      case CalculationCategory.uruganSirtu:
        _controllers['panjang'] = TextEditingController(text: txt('panjang'));
        _controllers['lebar'] = TextEditingController(text: txt('lebar'));
        _controllers['tebal'] = TextEditingController(text: txt('tebal', def: '10'));
        break;
      case CalculationCategory.cakarAyam:
        _controllers['panjang'] = TextEditingController(text: txt('panjang', def: '1.0'));
        _controllers['lebar'] = TextEditingController(text: txt('lebar', def: '1.0'));
        _controllers['tebal'] = TextEditingController(text: txt('tebal', def: '0.25'));
        _controllers['jarakBesi'] = TextEditingController(text: txt('jarakBesi', def: '15'));
        _selectedBesiUtama = int.tryParse(txt('diameterUtama', def: '10')) ?? 10;
        _selectedMutuBetonStruktur = txt('mutuBeton', def: 'K-225');
        break;
      case CalculationCategory.floordeck:
      case CalculationCategory.platSlab:
        _controllers['panjang'] = TextEditingController(text: txt('panjang', def: '6.0'));
        _controllers['lebar'] = TextEditingController(text: txt('lebar', def: '4.0'));
        _controllers['tebal'] = TextEditingController(text: txt('tebal', def: '0.12'));
        _selectedWiremeshType = txt('tipeWiremesh', def: 'M8');
        _selectedLayer = int.tryParse(txt('layer', def: '1')) ?? 1;
        break;
      case CalculationCategory.cutFill:
        _controllers['panjang'] = TextEditingController(text: txt('panjang', def: '10.0'));
        _controllers['lebar'] = TextEditingController(text: txt('lebar', def: '5.0'));
        _controllers['tebal'] = TextEditingController(text: txt('tebal', def: '50'));
        _selectedCompactorTanah = txt('jenisTanah', def: 'Biasa');
        break;
      case CalculationCategory.retainingWall:
        _controllers['panjang'] = TextEditingController(text: txt('panjang', def: '10.0'));
        _controllers['tinggi'] = TextEditingController(text: txt('tinggi', def: '2.0'));
        _controllers['lebarAtas'] = TextEditingController(text: txt('lebarAtas', def: '0.3'));
        _controllers['lebarBawah'] = TextEditingController(text: txt('lebarBawah', def: '0.8'));
        _selectedRetainingWallCampuran = txt('campuran', def: '1:4');
        break;
      case CalculationCategory.septicTank:
        _controllers['panjang'] = TextEditingController(text: txt('panjang', def: '2.0'));
        _controllers['lebar'] = TextEditingController(text: txt('lebar', def: '1.5'));
        _controllers['tinggi'] = TextEditingController(text: txt('tinggi', def: '1.5'));
        break;
      case CalculationCategory.batako:
        _controllers['panjang'] = TextEditingController(text: txt('panjang', def: '10.0'));
        _controllers['tinggi'] = TextEditingController(text: txt('tinggi', def: '3.0'));
        _selectedBatakoCampuran = txt('campuran', def: '1:4');
        break;
      case CalculationCategory.glassBlock:
        _controllers['panjang'] = TextEditingController(text: txt('panjang', def: '3.0'));
        _controllers['tinggi'] = TextEditingController(text: txt('tinggi', def: '2.0'));
        _selectedGlassBlockSize = txt('ukuran', def: '20x20');
        break;
      case CalculationCategory.kusenAluminium:
        _controllers['lebar'] = TextEditingController(text: txt('lebar', def: '0.9'));
        _controllers['tinggi'] = TextEditingController(text: txt('tinggi', def: '2.1'));
        _selectedAluminiumProfile = txt('profile', def: '3 inch');
        break;
      case CalculationCategory.floorScreed:
        _controllers['luas'] = TextEditingController(text: txt('luas', def: '24.0'));
        _controllers['tebal'] = TextEditingController(text: txt('tebal', def: '3.0'));
        _selectedFloorScreedCampuran = txt('campuran', def: '1:4');
        break;
      case CalculationCategory.pondasiSumuran:
        _controllers['diameter'] = TextEditingController(text: txt('diameter', def: '80'));
        _controllers['kedalaman'] = TextEditingController(text: txt('kedalaman', def: '3.0'));
        _controllers['jumlahTitik'] = TextEditingController(text: txt('jumlahTitik', def: '4'));
        break;
      case CalculationCategory.plafonPvc:
        _controllers['panjang'] = TextEditingController(text: txt('panjang', def: '4.0'));
        _controllers['lebar'] = TextEditingController(text: txt('lebar', def: '3.0'));
        break;
      case CalculationCategory.plintLantai:
        _controllers['keliling'] = TextEditingController(text: txt('keliling', def: '14.0'));
        _selectedPlintUkuran = txt('ukuran', def: '10x40');
        break;
      case CalculationCategory.kusenKayu:
        _controllers['lebar'] = TextEditingController(text: txt('lebar', def: '0.9'));
        _controllers['tinggi'] = TextEditingController(text: txt('tinggi', def: '2.1'));
        break;
      case CalculationCategory.bakKontrol:
        _controllers['panjang'] = TextEditingController(text: txt('panjang', def: '0.5'));
        _controllers['lebar'] = TextEditingController(text: txt('lebar', def: '0.5'));
        _controllers['tinggi'] = TextEditingController(text: txt('tinggi', def: '0.5'));
        _controllers['jumlah'] = TextEditingController(text: txt('jumlah', def: '1'));
        break;
      case CalculationCategory.grassBlock:
        _controllers['luas'] = TextEditingController(text: txt('luas', def: '20.0'));
        break;
      case CalculationCategory.kanopi:
        _controllers['panjang'] = TextEditingController(text: txt('panjang', def: '5.0'));
        _controllers['lebar'] = TextEditingController(text: txt('lebar', def: '3.0'));
        _selectedKanopiAtapType = txt('atapType', def: 'Polycarbonate');
        break;
      case CalculationCategory.railing:
        _controllers['panjang'] = TextEditingController(text: txt('panjang', def: '6.0'));
        _controllers['tinggi'] = TextEditingController(text: txt('tinggi', def: '0.9'));
        break;
      case CalculationCategory.bajaWf:
        _controllers['panjang'] = TextEditingController(text: txt('panjang', def: '12.0'));
        _selectedBajaTipeWF = txt('tipeWF', def: 'WF 200');
        break;
      case CalculationCategory.plumbing:
        _controllers['panjang'] = TextEditingController(text: txt('panjang', def: '20.0'));
        _selectedPlumbingDiameter = txt('diameter', def: '1/2"');
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
      case CalculationCategory.tangga:
        inputs['diameterUtama'] = _selectedTanggaBesiUtama.toString();
        inputs['diameterBagi'] = _selectedTanggaBesiBagi.toString();
        inputs['mutuBeton'] = _selectedTanggaMutuBeton;
        inputs['bekisting'] = _isTanggaBekisting.toString();
        break;
      case CalculationCategory.borePile:
        inputs['diameterUtama'] = _selectedBoreUtamaDiameter.toString();
        inputs['jumlahUtama'] = _selectedBoreUtamaJumlah.toString();
        inputs['diameterSpiral'] = _selectedBoreSpiralDiameter.toString();
        inputs['mutuBeton'] = _selectedBoreMutuBeton;
        break;
      case CalculationCategory.begelSpiral:
        inputs['diameterSpiral'] = _selectedBegelSpiralDiameter.toString();
        break;
      case CalculationCategory.cakarAyam:
        inputs['diameterUtama'] = _selectedBesiUtama.toString();
        inputs['mutuBeton'] = _selectedMutuBetonStruktur;
        break;
      case CalculationCategory.floordeck:
      case CalculationCategory.platSlab:
        inputs['tipeWiremesh'] = _selectedWiremeshType;
        inputs['layer'] = _selectedLayer.toString();
        break;
      case CalculationCategory.cutFill:
        inputs['jenisTanah'] = _selectedCompactorTanah;
        break;
      case CalculationCategory.retainingWall:
        inputs['campuran'] = _selectedRetainingWallCampuran;
        break;
      case CalculationCategory.batako:
        inputs['campuran'] = _selectedBatakoCampuran;
        break;
      case CalculationCategory.glassBlock:
        inputs['ukuran'] = _selectedGlassBlockSize;
        break;
      case CalculationCategory.kusenAluminium:
        inputs['profile'] = _selectedAluminiumProfile;
        break;
      case CalculationCategory.floorScreed:
        inputs['campuran'] = _selectedFloorScreedCampuran;
        break;
      case CalculationCategory.plintLantai:
        inputs['ukuran'] = _selectedPlintUkuran;
        break;
      case CalculationCategory.kanopi:
        inputs['atapType'] = _selectedKanopiAtapType;
        break;
      case CalculationCategory.bajaWf:
        inputs['tipeWF'] = _selectedBajaTipeWF;
        break;
      case CalculationCategory.plumbing:
        inputs['diameter'] = _selectedPlumbingDiameter;
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
      case CalculationCategory.plafon:
        return Column(
          children: [
            CustomInputField(
              controller: _controllers['luas']!,
              labelText: 'Luas Plafon',
              suffixText: 'm²',
              hintText: 'Contoh: 36.0',
            ),
          ],
        );
      case CalculationCategory.tangga:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomInputField(
              controller: _controllers['anakTangga']!,
              labelText: 'Jumlah Anak Tangga',
              suffixText: 'anak',
              hintText: 'Contoh: 15',
            ),
            CustomInputField(
              controller: _controllers['lebar']!,
              labelText: 'Lebar Tangga',
              suffixText: 'm',
              hintText: 'Contoh: 1.2',
            ),
            Row(
              children: [
                Expanded(
                  child: CustomInputField(
                    controller: _controllers['tinggiAnak']!,
                    labelText: 'Tinggi Anak (Riser)',
                    suffixText: 'cm',
                    hintText: 'Contoh: 18',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomInputField(
                    controller: _controllers['lebarAlas']!,
                    labelText: 'Lebar Alas (Tread)',
                    suffixText: 'cm',
                    hintText: 'Contoh: 27',
                  ),
                ),
              ],
            ),
            CustomInputField(
              controller: _controllers['tebalPlat']!,
              labelText: 'Tebal Plat Tangga',
              suffixText: 'cm',
              hintText: 'Contoh: 12',
            ),
            Row(
              children: [
                Expanded(
                  child: CustomInputField(
                    controller: _controllers['panjangBordes']!,
                    labelText: 'Panjang Bordes',
                    suffixText: 'm',
                    hintText: 'Contoh: 1.2',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomInputField(
                    controller: _controllers['lebarBordes']!,
                    labelText: 'Lebar Bordes',
                    suffixText: 'm',
                    hintText: 'Contoh: 1.2',
                  ),
                ),
              ],
            ),
            CustomInputField(
              controller: _controllers['tebalBordes']!,
              labelText: 'Tebal Bordes',
              suffixText: 'cm',
              hintText: 'Contoh: 15',
            ),
            const SizedBox(height: 8),
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
                        initialValue: _selectedTanggaBesiUtama,
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
                          if (val != null) setState(() => _selectedTanggaBesiUtama = val);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomInputField(
                    controller: _controllers['jarakUtama']!,
                    labelText: 'Jarak Besi Utama',
                    suffixText: 'cm',
                    hintText: 'Contoh: 15',
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
                        'Besi Bagi',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF263238)),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<int>(
                        initialValue: _selectedTanggaBesiBagi,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                        ),
                        items: [6, 8, 10, 12].map((int val) {
                          return DropdownMenuItem<int>(
                            value: val,
                            child: Text('Ø $val mm', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedTanggaBesiBagi = val);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomInputField(
                    controller: _controllers['jarakBagi']!,
                    labelText: 'Jarak Besi Bagi',
                    suffixText: 'cm',
                    hintText: 'Contoh: 20',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Mutu Beton Tangga (SNI)',
              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF263238)),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _selectedTanggaMutuBeton,
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
                  setState(() => _selectedTanggaMutuBeton = val);
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
                value: _isTanggaBekisting,
                activeThumbColor: Theme.of(context).primaryColor,
                onChanged: (val) {
                  setState(() => _isTanggaBekisting = val);
                },
              ),
            ),
          ],
        );
      case CalculationCategory.paving:
        return Column(
          children: [
            CustomInputField(
              controller: _controllers['luas']!,
              labelText: 'Luas Area Paving',
              suffixText: 'm²',
              hintText: 'Contoh: 50.0',
            ),
            CustomInputField(
              controller: _controllers['panjangKanstin']!,
              labelText: 'Panjang Kanstin Beton',
              suffixText: 'm',
              hintText: 'Contoh: 15.0',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Panjang Kanstin tidak boleh kosong';
                }
                if (double.tryParse(value) == null) {
                  return 'Masukkan angka yang valid';
                }
                if (double.parse(value) < 0) {
                  return 'Nilai tidak boleh negatif';
                }
                return null;
              },
            ),
          ],
        );
      case CalculationCategory.partisiGypsum:
        return Column(
          children: [
            CustomInputField(
              controller: _controllers['luas']!,
              labelText: 'Luas Dinding Partisi (2 Sisi)',
              suffixText: 'm²',
              hintText: 'Contoh: 24.0',
            ),
          ],
        );
      case CalculationCategory.pagarPanel:
        return Column(
          children: [
            CustomInputField(
              controller: _controllers['panjang']!,
              labelText: 'Panjang Pagar Panel',
              suffixText: 'm',
              hintText: 'Contoh: 48.0',
            ),
            CustomInputField(
              controller: _controllers['tinggi']!,
              labelText: 'Tinggi Pagar Panel',
              suffixText: 'm',
              hintText: 'Contoh: 2.0 (kelipatan 0.4m)',
            ),
          ],
        );
      case CalculationCategory.borePile:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomInputField(
              controller: _controllers['titik']!,
              labelText: 'Jumlah Titik Pondasi',
              suffixText: 'titik',
              hintText: 'Contoh: 8',
            ),
            Row(
              children: [
                Expanded(
                  child: CustomInputField(
                    controller: _controllers['diameter']!,
                    labelText: 'Diameter Pile',
                    suffixText: 'cm',
                    hintText: 'Contoh: 30',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomInputField(
                    controller: _controllers['kedalaman']!,
                    labelText: 'Kedalaman Galian',
                    suffixText: 'm',
                    hintText: 'Contoh: 6.0',
                  ),
                ),
              ],
            ),
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
                        initialValue: _selectedBoreUtamaDiameter,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                        ),
                        items: [10, 12, 16].map((int val) {
                          return DropdownMenuItem<int>(
                            value: val,
                            child: Text('Ø $val mm', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedBoreUtamaDiameter = val);
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
                        initialValue: _selectedBoreUtamaJumlah,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                        ),
                        items: [4, 6, 8].map((int val) {
                          return DropdownMenuItem<int>(
                            value: val,
                            child: Text('$val batang', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedBoreUtamaJumlah = val);
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
                        'Besi Begel Spiral',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF263238)),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<int>(
                        initialValue: _selectedBoreSpiralDiameter,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                        ),
                        items: [6, 8, 10].map((int val) {
                          return DropdownMenuItem<int>(
                            value: val,
                            child: Text('Ø $val mm', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedBoreSpiralDiameter = val);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomInputField(
                    controller: _controllers['jarakSpiral']!,
                    labelText: 'Jarak Begel Spiral',
                    suffixText: 'cm',
                    hintText: 'Contoh: 15',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Mutu Beton Cor Bore Pile (SNI)',
              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF263238)),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _selectedBoreMutuBeton,
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
                  setState(() => _selectedBoreMutuBeton = val);
                }
              },
            ),
          ],
        );
      case CalculationCategory.keramikDinding:
        return Column(
          children: [
            CustomInputField(
              controller: _controllers['luas']!,
              labelText: 'Luas Keramik Dinding',
              suffixText: 'm²',
              hintText: 'Contoh: 18.0',
            ),
          ],
        );
      case CalculationCategory.waterproofing:
        return Column(
          children: [
            CustomInputField(
              controller: _controllers['luas']!,
              labelText: 'Luas Dak Beton',
              suffixText: 'm²',
              hintText: 'Contoh: 40.0',
            ),
          ],
        );
      case CalculationCategory.begelSpiral:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomInputField(
              controller: _controllers['titik']!,
              labelText: 'Jumlah Titik Kolom',
              suffixText: 'titik',
              hintText: 'Contoh: 6',
            ),
            CustomInputField(
              controller: _controllers['tinggi']!,
              labelText: 'Tinggi Kolom Silinder',
              suffixText: 'm',
              hintText: 'Contoh: 4.0',
            ),
            CustomInputField(
              controller: _controllers['diameter']!,
              labelText: 'Diameter Kolom Silinder',
              suffixText: 'cm',
              hintText: 'Contoh: 30',
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Besi Begel Spiral',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF263238)),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<int>(
                        initialValue: _selectedBegelSpiralDiameter,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                        ),
                        items: [6, 8, 10].map((int val) {
                          return DropdownMenuItem<int>(
                            value: val,
                            child: Text('Ø $val mm', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedBegelSpiralDiameter = val);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomInputField(
                    controller: _controllers['jarakSpiral']!,
                    labelText: 'Jarak Begel Spiral',
                    suffixText: 'cm',
                    hintText: 'Contoh: 15',
                  ),
                ),
              ],
            ),
          ],
        );
      case CalculationCategory.uruganSirtu:
        return Column(
          children: [
            CustomInputField(
              controller: _controllers['panjang']!,
              labelText: 'Panjang Lahan',
              suffixText: 'm',
              hintText: 'Contoh: 10.0',
            ),
            CustomInputField(
              controller: _controllers['lebar']!,
              labelText: 'Lebar Lahan',
              suffixText: 'm',
              hintText: 'Contoh: 5.0',
            ),
            CustomInputField(
              controller: _controllers['tebal']!,
              labelText: 'Tebal Urugan',
              suffixText: 'cm',
              hintText: 'Contoh: 10',
            ),
          ],
        );
      case CalculationCategory.cakarAyam:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomInputField(controller: _controllers['panjang']!, labelText: 'Panjang Tapak', suffixText: 'm', hintText: 'Contoh: 1.0'),
            CustomInputField(controller: _controllers['lebar']!, labelText: 'Lebar Tapak', suffixText: 'm', hintText: 'Contoh: 1.0'),
            CustomInputField(controller: _controllers['tebal']!, labelText: 'Tebal Tapak', suffixText: 'm', hintText: 'Contoh: 0.25'),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Besi Utama', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<int>(
                        initialValue: _selectedBesiUtama,
                        items: [8, 10, 12, 16].map((e) => DropdownMenuItem(value: e, child: Text('Ø $e mm'))).toList(),
                        onChanged: (val) { if (val != null) setState(() => _selectedBesiUtama = val); },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomInputField(controller: _controllers['jarakBesi']!, labelText: 'Jarak Besi', suffixText: 'cm', hintText: 'Contoh: 15'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text('Mutu Beton (SNI)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: _selectedMutuBetonStruktur,
              items: ['K-175', 'K-225', 'K-250', 'K-300'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) { if (val != null) setState(() => _selectedMutuBetonStruktur = val); },
            ),
          ],
        );
      case CalculationCategory.floordeck:
      case CalculationCategory.platSlab:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomInputField(controller: _controllers['panjang']!, labelText: 'Panjang Plat', suffixText: 'm', hintText: 'Contoh: 6.0'),
            CustomInputField(controller: _controllers['lebar']!, labelText: 'Lebar Plat', suffixText: 'm', hintText: 'Contoh: 4.0'),
            CustomInputField(controller: _controllers['tebal']!, labelText: 'Tebal Plat', suffixText: 'm', hintText: 'Contoh: 0.12'),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Tipe Wiremesh', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedWiremeshType,
                        items: ['M6', 'M8', 'M10'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                        onChanged: (val) { if (val != null) setState(() => _selectedWiremeshType = val); },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Jumlah Layer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<int>(
                        initialValue: _selectedLayer,
                        items: [1, 2].map((e) => DropdownMenuItem(value: e, child: Text('$e Layer'))).toList(),
                        onChanged: (val) { if (val != null) setState(() => _selectedLayer = val); },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      case CalculationCategory.cutFill:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomInputField(controller: _controllers['panjang']!, labelText: 'Panjang Area', suffixText: 'm', hintText: 'Contoh: 10.0'),
            CustomInputField(controller: _controllers['lebar']!, labelText: 'Lebar Area', suffixText: 'm', hintText: 'Contoh: 5.0'),
            CustomInputField(controller: _controllers['tebal']!, labelText: 'Tebal Urugan', suffixText: 'cm', hintText: 'Contoh: 50'),
            const Text('Jenis Tanah Urug', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: _selectedCompactorTanah,
              items: ['Biasa', 'Kohesif Padat'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) { if (val != null) setState(() => _selectedCompactorTanah = val); },
            ),
          ],
        );
      case CalculationCategory.retainingWall:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomInputField(controller: _controllers['panjang']!, labelText: 'Panjang Dinding', suffixText: 'm', hintText: 'Contoh: 10.0'),
            CustomInputField(controller: _controllers['tinggi']!, labelText: 'Tinggi Dinding', suffixText: 'm', hintText: 'Contoh: 2.0'),
            CustomInputField(controller: _controllers['lebarAtas']!, labelText: 'Lebar Atas', suffixText: 'm', hintText: 'Contoh: 0.3'),
            CustomInputField(controller: _controllers['lebarBawah']!, labelText: 'Lebar Bawah', suffixText: 'm', hintText: 'Contoh: 0.8'),
            const Text('Campuran Adukan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: _selectedRetainingWallCampuran,
              items: ['1:3', '1:4', '1:5'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) { if (val != null) setState(() => _selectedRetainingWallCampuran = val); },
            ),
          ],
        );
      case CalculationCategory.septicTank:
        return Column(
          children: [
            CustomInputField(controller: _controllers['panjang']!, labelText: 'Panjang Tank', suffixText: 'm', hintText: 'Contoh: 2.0'),
            CustomInputField(controller: _controllers['lebar']!, labelText: 'Lebar Tank', suffixText: 'm', hintText: 'Contoh: 1.5'),
            CustomInputField(controller: _controllers['tinggi']!, labelText: 'Tinggi Tank', suffixText: 'm', hintText: 'Contoh: 1.5'),
          ],
        );
      case CalculationCategory.batako:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomInputField(controller: _controllers['panjang']!, labelText: 'Panjang Dinding', suffixText: 'm', hintText: 'Contoh: 10.0'),
            CustomInputField(controller: _controllers['tinggi']!, labelText: 'Tinggi Dinding', suffixText: 'm', hintText: 'Contoh: 3.0'),
            const Text('Campuran Adukan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: _selectedBatakoCampuran,
              items: ['1:3', '1:4', '1:5'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) { if (val != null) setState(() => _selectedBatakoCampuran = val); },
            ),
          ],
        );
      case CalculationCategory.glassBlock:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomInputField(controller: _controllers['panjang']!, labelText: 'Panjang Area', suffixText: 'm', hintText: 'Contoh: 3.0'),
            CustomInputField(controller: _controllers['tinggi']!, labelText: 'Tinggi Area', suffixText: 'm', hintText: 'Contoh: 2.0'),
            const Text('Ukuran Glass Block', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: _selectedGlassBlockSize,
              items: ['20x20', '19x19'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) { if (val != null) setState(() => _selectedGlassBlockSize = val); },
            ),
          ],
        );
      case CalculationCategory.kusenAluminium:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomInputField(controller: _controllers['lebar']!, labelText: 'Lebar Kusen', suffixText: 'm', hintText: 'Contoh: 0.9'),
            CustomInputField(controller: _controllers['tinggi']!, labelText: 'Tinggi Kusen', suffixText: 'm', hintText: 'Contoh: 2.1'),
            const Text('Profil Aluminium', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: _selectedAluminiumProfile,
              items: ['3 inch', '4 inch'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) { if (val != null) setState(() => _selectedAluminiumProfile = val); },
            ),
          ],
        );
      case CalculationCategory.floorScreed:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomInputField(controller: _controllers['luas']!, labelText: 'Luas Screed', suffixText: 'm²', hintText: 'Contoh: 24.0'),
            CustomInputField(controller: _controllers['tebal']!, labelText: 'Tebal Screed', suffixText: 'cm', hintText: 'Contoh: 3.0'),
            const Text('Campuran Screed', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: _selectedFloorScreedCampuran,
              items: ['1:3', '1:4', '1:5'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) { if (val != null) setState(() => _selectedFloorScreedCampuran = val); },
            ),
          ],
        );
      case CalculationCategory.pondasiSumuran:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomInputField(controller: _controllers['diameter']!, labelText: 'Diameter Buis', suffixText: 'cm', hintText: 'Contoh: 80'),
            CustomInputField(controller: _controllers['kedalaman']!, labelText: 'Kedalaman Sumuran', suffixText: 'm', hintText: 'Contoh: 3.0'),
            CustomInputField(controller: _controllers['jumlahTitik']!, labelText: 'Jumlah Titik', suffixText: 'titik', hintText: 'Contoh: 4'),
          ],
        );
      case CalculationCategory.plafonPvc:
        return Column(
          children: [
            CustomInputField(controller: _controllers['panjang']!, labelText: 'Panjang Ruangan', suffixText: 'm', hintText: 'Contoh: 4.0'),
            CustomInputField(controller: _controllers['lebar']!, labelText: 'Lebar Ruangan', suffixText: 'm', hintText: 'Contoh: 3.0'),
          ],
        );
      case CalculationCategory.plintLantai:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomInputField(controller: _controllers['keliling']!, labelText: 'Keliling Ruangan', suffixText: 'm', hintText: 'Contoh: 14.0'),
            const Text('Ukuran Plint', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: _selectedPlintUkuran,
              items: ['10x30', '10x40', '10x60'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) { if (val != null) setState(() => _selectedPlintUkuran = val); },
            ),
          ],
        );
      case CalculationCategory.kusenKayu:
        return Column(
          children: [
            CustomInputField(controller: _controllers['lebar']!, labelText: 'Lebar Kusen', suffixText: 'm', hintText: 'Contoh: 0.9'),
            CustomInputField(controller: _controllers['tinggi']!, labelText: 'Tinggi Kusen', suffixText: 'm', hintText: 'Contoh: 2.1'),
          ],
        );
      case CalculationCategory.bakKontrol:
        return Column(
          children: [
            CustomInputField(controller: _controllers['panjang']!, labelText: 'Panjang Bak', suffixText: 'm', hintText: 'Contoh: 0.5'),
            CustomInputField(controller: _controllers['lebar']!, labelText: 'Lebar Bak', suffixText: 'm', hintText: 'Contoh: 0.5'),
            CustomInputField(controller: _controllers['tinggi']!, labelText: 'Tinggi Bak', suffixText: 'm', hintText: 'Contoh: 0.5'),
            CustomInputField(controller: _controllers['jumlah']!, labelText: 'Jumlah Bak', suffixText: 'bh', hintText: 'Contoh: 1'),
          ],
        );
      case CalculationCategory.grassBlock:
        return Column(
          children: [
            CustomInputField(controller: _controllers['luas']!, labelText: 'Luas Grass Block', suffixText: 'm²', hintText: 'Contoh: 20.0'),
          ],
        );
      case CalculationCategory.kanopi:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomInputField(controller: _controllers['panjang']!, labelText: 'Panjang Kanopi', suffixText: 'm', hintText: 'Contoh: 5.0'),
            CustomInputField(controller: _controllers['lebar']!, labelText: 'Lebar Kanopi', suffixText: 'm', hintText: 'Contoh: 3.0'),
            const Text('Jenis Atap Kanopi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: _selectedKanopiAtapType,
              items: ['Polycarbonate', 'Spandek'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) { if (val != null) setState(() => _selectedKanopiAtapType = val); },
            ),
          ],
        );
      case CalculationCategory.railing:
        return Column(
          children: [
            CustomInputField(controller: _controllers['panjang']!, labelText: 'Panjang Railing', suffixText: 'm', hintText: 'Contoh: 6.0'),
            CustomInputField(controller: _controllers['tinggi']!, labelText: 'Tinggi Railing', suffixText: 'm', hintText: 'Contoh: 0.9'),
          ],
        );
      case CalculationCategory.bajaWf:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomInputField(controller: _controllers['panjang']!, labelText: 'Panjang Profil WF', suffixText: 'm', hintText: 'Contoh: 12.0'),
            const Text('Profil Baja WF', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: _selectedBajaTipeWF,
              items: ['WF 150', 'WF 200', 'WF 250'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) { if (val != null) setState(() => _selectedBajaTipeWF = val); },
            ),
          ],
        );
      case CalculationCategory.plumbing:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomInputField(controller: _controllers['panjang']!, labelText: 'Panjang Pipa', suffixText: 'm', hintText: 'Contoh: 20.0'),
            const Text('Diameter Pipa PVC', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: _selectedPlumbingDiameter,
              items: ['1/2"', '3/4"', '2"', '3"', '4"'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) { if (val != null) setState(() => _selectedPlumbingDiameter = val); },
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
