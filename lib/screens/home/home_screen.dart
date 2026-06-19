import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../calculator/calculator_screen.dart';
import '../history/history_screen.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  IconData _getIconData(CalculationCategory category) {
    switch (category) {
      case CalculationCategory.beton:
        return Icons.opacity; // Water/Liquid Concrete blend
      case CalculationCategory.pondasi:
        return Icons.layers; // Concrete/Subbase foundation
      case CalculationCategory.dinding:
        return Icons.view_cozy; // Brickwork
      case CalculationCategory.plester:
        return Icons.texture; // Texture/Plaster
      case CalculationCategory.keramik:
        return Icons.grid_on; // Floor tiling
      case CalculationCategory.atap:
        return Icons.roofing; // Roof
      case CalculationCategory.cat:
        return Icons.format_paint; // Paint brush
      case CalculationCategory.pondasiBatuKali:
        return Icons.foundation; // Stone foundation
      case CalculationCategory.kolomBalok:
        return Icons.view_week; // Reinforced concrete columns/beams
      case CalculationCategory.bajaRingan:
        return Icons.architecture; // Lightweight steel truss
    }
  }

  Color _getCategoryColor(CalculationCategory category) {
    switch (category) {
      case CalculationCategory.beton:
        return const Color(0xFF78909C);
      case CalculationCategory.pondasi:
        return const Color(0xFF607D8B);
      case CalculationCategory.dinding:
        return const Color(0xFFE64A19);
      case CalculationCategory.plester:
        return const Color(0xFFFFA000);
      case CalculationCategory.keramik:
        return const Color(0xFF00897B);
      case CalculationCategory.atap:
        return const Color(0xFF795548);
      case CalculationCategory.cat:
        return const Color(0xFF8E24AA);
      case CalculationCategory.pondasiBatuKali:
        return const Color(0xFF5D4037);
      case CalculationCategory.kolomBalok:
        return const Color(0xFF1E88E5);
      case CalculationCategory.bajaRingan:
        return const Color(0xFF00ACC1);
    }
  }

  String _getCategoryDesc(CalculationCategory category) {
    switch (category) {
      case CalculationCategory.beton:
        return 'Semen, pasir, & kerikil';
      case CalculationCategory.pondasi:
        return 'Galian, beton, & pasir urug';
      case CalculationCategory.dinding:
        return 'Bata merah & hebel';
      case CalculationCategory.plester:
        return 'Plesteran & acian semen';
      case CalculationCategory.keramik:
        return 'Keramik & adukan semen';
      case CalculationCategory.atap:
        return 'Genteng & struktur kayu';
      case CalculationCategory.cat:
        return 'Kebutuhan volume cat';
      case CalculationCategory.pondasiBatuKali:
        return 'Batu belah, semen, & pasir';
      case CalculationCategory.kolomBalok:
        return 'Beton, pembesian, & bekisting';
      case CalculationCategory.bajaRingan:
        return 'Kanal C, reng, & sekrup rangka';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Elegant Header Section
          SliverAppBar(
            expandedHeight: 180.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'HitungBangun',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF263238),
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFFF8E1), Color(0xFFFFE082)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -20,
                      bottom: -20,
                      child: Icon(
                        Icons.construction,
                        size: 180,
                        color: const Color(0xFFFFD54F).withValues(alpha: 0.4),
                      ),
                    ),
                    Positioned(
                      left: 20,
                      top: 60,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            'Kalkulator Material Konstruksi SNI',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.blueGrey.shade800,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.history_outlined, size: 28),
                tooltip: 'Riwayat',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HistoryScreen()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined, size: 28),
                tooltip: 'Pengaturan',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsScreen()),
                  );
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
          
          // Selection Grid
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.95,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final category = CalculationCategory.values[index];
                  final color = _getCategoryColor(category);
                  final icon = _getIconData(category);

                  return Card(
                    elevation: 1.5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.grey.shade100, width: 1),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CalculatorScreen(category: category),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                icon,
                                color: color,
                                size: 30,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              category.nameIndo,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFF263238),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _getCategoryDesc(category),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blueGrey.shade600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount: CalculationCategory.values.length,
              ),
            ),
          ),
          
          // History quick card
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                color: const Color(0xFF263238),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HistoryScreen()),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                    child: Row(
                      children: [
                        Icon(Icons.history, color: Colors.white, size: 28),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Lihat Riwayat Perhitungan',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                'Akses data kalkulasi yang pernah disimpan',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
