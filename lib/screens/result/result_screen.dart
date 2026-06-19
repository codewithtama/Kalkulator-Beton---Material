import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:printing/printing.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../core/constants.dart';
import '../../core/pdf_helper.dart';
import '../../data/models/calculation_result.dart';
import '../../providers/calculator_provider.dart';
import '../../providers/history_provider.dart';
import '../../widgets/material_card.dart';
import '../../widgets/summary_card.dart';
import '../calculator/calculator_screen.dart';

class ResultScreen extends StatefulWidget {
  final CalculationCategory category;
  final Map<String, String> inputs;
  final String? initialProjectName;
  final String? projectId;

  const ResultScreen({
    super.key,
    required this.category,
    required this.inputs,
    this.initialProjectName,
    this.projectId,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final TextEditingController _projectNameController = TextEditingController();
  late CalculationResult _result;
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _projectNameController.text = widget.initialProjectName ?? 'Proyek ${widget.category.nameIndo}';
    _isSaved = widget.projectId != null;

    _projectNameController.addListener(() {
      if (_isSaved) {
        setState(() {
          _isSaved = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _projectNameController.dispose();
    super.dispose();
  }

  Color _getColorForIndex(int index) {
    final colors = [
      Colors.blueGrey,
      Colors.amber.shade700,
      Colors.grey.shade600,
      Colors.blue,
      Colors.deepOrange,
      Colors.teal,
      Colors.brown,
      Colors.orange.shade800,
      Colors.purple,
    ];
    return colors[index % colors.length];
  }

  Future<void> _saveProject() async {
    if (_projectNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama proyek tidak boleh kosong!'), backgroundColor: Colors.red),
      );
      return;
    }

    final historyProvider = Provider.of<HistoryProvider>(context, listen: false);
    
    // Serialize material list to List<Map>
    final serializedData = _result.requirements.map((req) => req.toJson()).toList();

    await historyProvider.saveProject(
      id: widget.projectId,
      name: _projectNameController.text.trim(),
      category: widget.category.toString().split('.').last,
      inputs: widget.inputs,
      requirementsData: serializedData,
      totalCost: _result.totalCost,
    );

    setState(() {
      _isSaved = true;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.projectId != null
              ? 'Kalkulasi berhasil diperbarui!'
              : 'Kalkulasi berhasil disimpan ke Riwayat!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _exportPdf() async {
    final pdfBytes = await PdfHelper.generateProjectPdf(
      projectName: _projectNameController.text.trim(),
      category: widget.category.toString().split('.').last,
      date: DateTime.now(),
      inputs: widget.inputs,
      requirements: _result.requirements,
      totalCost: _result.totalCost,
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdfBytes,
      name: _projectNameController.text.trim(),
    );
  }

  void _shareResults() {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    final buffer = StringBuffer();
    buffer.writeln('=== Laporan HitungBangun ===');
    buffer.writeln('Proyek: ${_projectNameController.text}');
    buffer.writeln('Kategori: ${widget.category.nameIndo}');
    buffer.writeln('Tanggal: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}');
    buffer.writeln('\n--- Parameter Input ---');
    widget.inputs.forEach((key, val) {
      buffer.writeln('- $key: $val');
    });
    buffer.writeln('\n--- Rincian Kebutuhan Material ---');
    for (var req in _result.requirements) {
      final priceStr = req.unitPrice > 0 ? ' (${currencyFormat.format(req.totalPrice)})' : '';
      buffer.writeln('- ${req.name}: ${req.quantity} ${req.unit}$priceStr');
    }
    buffer.writeln('\n------------------------');
    buffer.writeln('Total Estimasi Biaya: ${currencyFormat.format(_result.totalCost)}');
    buffer.writeln('========================');
    buffer.writeln('Dihitung via aplikasi HitungBangun.');

    Share.share(buffer.toString(), subject: 'Estimasi Material - ${_projectNameController.text}');
  }

  @override
  Widget build(BuildContext context) {
    final calcProvider = Provider.of<CalculatorProvider>(context);
    
    // Calculate results using latest prices
    _result = calcProvider.performCalculation(
      category: widget.category,
      inputs: widget.inputs,
    );

    // Prepare chart sections (only for items with price > 0)
    final purchasableItems = _result.requirements.where((item) => item.totalPrice > 0).toList();
    final List<PieChartSectionData> chartSections = [];
    
    for (var i = 0; i < purchasableItems.length; i++) {
      final item = purchasableItems[i];
      final percentage = _result.totalCost > 0 ? (item.totalPrice / _result.totalCost) * 100 : 0.0;
      
      chartSections.add(
        PieChartSectionData(
          color: _getColorForIndex(i),
          value: item.totalPrice,
          title: percentage >= 8 ? '${percentage.toStringAsFixed(0)}%' : '',
          radius: 50,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Perhitungan'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary card
              SummaryCard(
                totalCost: _result.totalCost,
                materialCount: _result.requirements.where((r) => r.key != 'galian').length,
              ),
              const SizedBox(height: 24),

              // Project naming form
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Nama Simpanan Proyek',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _projectNameController,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          hintText: 'Masukkan nama proyek',
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Pie chart breakdown if totalCost > 0
              if (_result.totalCost > 0 && chartSections.isNotEmpty) ...[
                const Text(
                  'Proporsi Distribusi Biaya',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 12),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 180,
                          child: PieChart(
                            PieChartData(
                              sectionsSpace: 2,
                              centerSpaceRadius: 40,
                              sections: chartSections,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Legend
                        Wrap(
                          spacing: 12,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: List.generate(purchasableItems.length, (index) {
                            final item = purchasableItems[index];
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: _getColorForIndex(index),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  item.name,
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                ),
                              ],
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Material Cards
              const Text(
                'Rincian Kebutuhan Material',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _result.requirements.length,
                itemBuilder: (context, index) {
                  return MaterialCard(requirement: _result.requirements[index]);
                },
              ),
              const SizedBox(height: 20),

              // Action Buttons Row
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _exportPdf,
                      icon: const Icon(Icons.picture_as_pdf),
                      label: const Text('PDF'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _shareResults,
                      icon: const Icon(Icons.share),
                      label: const Text('Bagikan'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (widget.projectId != null) ...[
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CalculatorScreen(
                            category: widget.category,
                            projectId: widget.projectId,
                            initialInputs: widget.inputs,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit_note),
                    label: const Text('Edit Parameter Perhitungan'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _isSaved ? null : _saveProject,
                  icon: Icon(_isSaved ? Icons.check : (widget.projectId != null ? Icons.update : Icons.save)),
                  label: Text(_isSaved
                      ? (widget.projectId != null ? 'Perubahan Diperbarui' : 'Tersimpan ke Riwayat')
                      : (widget.projectId != null ? 'Perbarui Perhitungan' : 'Simpan Perhitungan')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isSaved ? Colors.grey : Theme.of(context).primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
