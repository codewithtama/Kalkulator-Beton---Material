import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../core/constants.dart';
import '../../providers/history_provider.dart';
import '../result/result_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  IconData _getIconData(String categoryStr) {
    try {
      final category = CalculationCategory.values.firstWhere(
        (e) => e.toString().split('.').last == categoryStr,
      );
      switch (category) {
        case CalculationCategory.beton:
          return Icons.opacity;
        case CalculationCategory.pondasi:
          return Icons.foundation;
        case CalculationCategory.dinding:
          return Icons.view_cozy;
        case CalculationCategory.plester:
          return Icons.texture;
        case CalculationCategory.keramik:
          return Icons.grid_on;
        case CalculationCategory.atap:
          return Icons.roofing;
        case CalculationCategory.cat:
          return Icons.format_paint;
      }
    } catch (_) {
      return Icons.construction;
    }
  }

  Color _getCategoryColor(String categoryStr) {
    try {
      final category = CalculationCategory.values.firstWhere(
        (e) => e.toString().split('.').last == categoryStr,
      );
      switch (category) {
        case CalculationCategory.beton:
          return const Color(0xFF78909C);
        case CalculationCategory.pondasi:
          return const Color(0xFF8D6E63);
        case CalculationCategory.dinding:
          return const Color(0xFFE64A19);
        case CalculationCategory.plester:
          return const Color(0xFFFFA000);
        case CalculationCategory.keramik:
          return const Color(0xFF00897B);
        case CalculationCategory.atap:
          return const Color(0xFF5D4037);
        case CalculationCategory.cat:
          return const Color(0xFF8E24AA);
      }
    } catch (_) {
      return Colors.amber;
    }
  }

  @override
  Widget build(BuildContext context) {
    final historyProvider = Provider.of<HistoryProvider>(context);
    final projects = historyProvider.projects;
    
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm', 'id');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Perhitungan'),
        actions: [
          if (projects.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined, color: Colors.redAccent),
              tooltip: 'Hapus Semua',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Hapus Semua Riwayat?'),
                    content: const Text('Tindakan ini akan menghapus permanen seluruh riwayat kalkulasi proyek Anda.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Batal'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          historyProvider.clearHistory();
                        },
                        child: const Text('Hapus Semua', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: SafeArea(
        child: projects.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.history_toggle_off,
                          size: 72,
                          color: Colors.amber.shade700,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Belum Ada Riwayat',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF263238),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Hasil kalkulasi material yang Anda simpan akan muncul di halaman ini.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  final project = projects[index];
                  final catColor = _getCategoryColor(project.category);
                  final catIcon = _getIconData(project.category);

                  // Try resolving category enum
                  late CalculationCategory categoryEnum;
                  try {
                    categoryEnum = CalculationCategory.values.firstWhere(
                      (e) => e.toString().split('.').last == project.category,
                    );
                  } catch (_) {
                    categoryEnum = CalculationCategory.beton;
                  }

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12.0),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: catColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          catIcon,
                          color: catColor,
                          size: 28,
                        ),
                      ),
                      title: Text(
                        project.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            dateFormat.format(project.date),
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            currencyFormat.format(project.totalCost),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Hapus Riwayat?'),
                              content: Text('Apakah Anda yakin ingin menghapus "${project.name}" dari riwayat?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Batal'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    historyProvider.deleteProject(project.id);
                                  },
                                  child: const Text('Hapus', style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResultScreen(
                              category: categoryEnum,
                              inputs: Map<String, String>.from(project.inputs),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
