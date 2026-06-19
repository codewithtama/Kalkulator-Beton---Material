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
      case CalculationCategory.plafon:
        return Icons.border_all;
      case CalculationCategory.tangga:
        return Icons.stairs;
      case CalculationCategory.paving:
        return Icons.grid_view;
      case CalculationCategory.partisiGypsum:
        return Icons.view_day;
      case CalculationCategory.pagarPanel:
        return Icons.view_column;
      case CalculationCategory.borePile:
        return Icons.download;
      case CalculationCategory.keramikDinding:
        return Icons.border_outer;
      case CalculationCategory.waterproofing:
        return Icons.water;
      case CalculationCategory.begelSpiral:
        return Icons.refresh;
      case CalculationCategory.uruganSirtu:
        return Icons.landscape;
      // 20 New Categories
      case CalculationCategory.cakarAyam:
        return Icons.grid_3x3;
      case CalculationCategory.floordeck:
        return Icons.view_quilt;
      case CalculationCategory.platSlab:
        return Icons.table_rows;
      case CalculationCategory.cutFill:
        return Icons.align_vertical_bottom;
      case CalculationCategory.retainingWall:
        return Icons.reorder;
      case CalculationCategory.septicTank:
        return Icons.waves;
      case CalculationCategory.batako:
        return Icons.view_in_ar;
      case CalculationCategory.glassBlock:
        return Icons.widgets;
      case CalculationCategory.kusenAluminium:
        return Icons.crop_square;
      case CalculationCategory.floorScreed:
        return Icons.line_style;
      case CalculationCategory.pondasiSumuran:
        return Icons.adjust;
      case CalculationCategory.plafonPvc:
        return Icons.border_style;
      case CalculationCategory.plintLantai:
        return Icons.border_bottom;
      case CalculationCategory.kusenKayu:
        return Icons.meeting_room;
      case CalculationCategory.bakKontrol:
        return Icons.inbox;
      case CalculationCategory.grassBlock:
        return Icons.eco;
      case CalculationCategory.kanopi:
        return Icons.umbrella;
      case CalculationCategory.railing:
        return Icons.fence;
      case CalculationCategory.bajaWf:
        return Icons.view_headline;
      case CalculationCategory.plumbing:
        return Icons.plumbing;
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
      case CalculationCategory.plafon:
        return const Color(0xFF00796B);
      case CalculationCategory.tangga:
        return const Color(0xFFE65100);
      case CalculationCategory.paving:
        return const Color(0xFF388E3C);
      case CalculationCategory.partisiGypsum:
        return const Color(0xFF455A64);
      case CalculationCategory.pagarPanel:
        return const Color(0xFF512DA8);
      case CalculationCategory.borePile:
        return const Color(0xFFD84315);
      case CalculationCategory.keramikDinding:
        return const Color(0xFF00ACC1);
      case CalculationCategory.waterproofing:
        return const Color(0xFF0288D1);
      case CalculationCategory.begelSpiral:
        return const Color(0xFFC2185B);
      case CalculationCategory.uruganSirtu:
        return const Color(0xFF795548);
      // 20 New Categories
      case CalculationCategory.cakarAyam:
        return const Color(0xFFD84315);
      case CalculationCategory.floordeck:
        return const Color(0xFF1565C0);
      case CalculationCategory.platSlab:
        return const Color(0xFF2E7D32);
      case CalculationCategory.cutFill:
        return const Color(0xFF8D6E63);
      case CalculationCategory.retainingWall:
        return const Color(0xFF4E342E);
      case CalculationCategory.septicTank:
        return const Color(0xFF0277BD);
      case CalculationCategory.batako:
        return const Color(0xFF558B2F);
      case CalculationCategory.glassBlock:
        return const Color(0xFF00ACC1);
      case CalculationCategory.kusenAluminium:
        return const Color(0xFF00838F);
      case CalculationCategory.floorScreed:
        return const Color(0xFF78909C);
      case CalculationCategory.pondasiSumuran:
        return const Color(0xFF37474F);
      case CalculationCategory.plafonPvc:
        return const Color(0xFF8E24AA);
      case CalculationCategory.plintLantai:
        return const Color(0xFF009688);
      case CalculationCategory.kusenKayu:
        return const Color(0xFFD84315);
      case CalculationCategory.bakKontrol:
        return const Color(0xFF455A64);
      case CalculationCategory.grassBlock:
        return const Color(0xFF2E7D32);
      case CalculationCategory.kanopi:
        return const Color(0xFFAD1457);
      case CalculationCategory.railing:
        return const Color(0xFF6A1B9A);
      case CalculationCategory.bajaWf:
        return const Color(0xFF303F9F);
      case CalculationCategory.plumbing:
        return const Color(0xFF00796B);
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
      case CalculationCategory.plafon:
        return 'Gypsum, hollow 4x4, 2x4, & compound';
      case CalculationCategory.tangga:
        return 'Volume cor tangga & tulangan beton';
      case CalculationCategory.paving:
        return 'Paving block, pasir urug, & kanstin';
      case CalculationCategory.partisiGypsum:
        return 'Rangka metal stud, gypsum, & sekrup';
      case CalculationCategory.pagarPanel:
        return 'Daun precast & tiang kolom precast';
      case CalculationCategory.borePile:
        return 'Volume cor bore pile & besi tulangan';
      case CalculationCategory.keramikDinding:
        return 'Keramik dinding, semen instan & nat';
      case CalculationCategory.waterproofing:
        return 'Cairan pelapis anti bocor dak';
      case CalculationCategory.begelSpiral:
        return 'Besi begel spiral kolom bulat';
      case CalculationCategory.uruganSirtu:
        return 'Volume pasir batu & faktor susut';
      // 20 New Categories
      case CalculationCategory.cakarAyam:
        return 'Pondasi tapak cakar ayam & besi';
      case CalculationCategory.floordeck:
        return 'Plat lantai bondex & wiremesh';
      case CalculationCategory.platSlab:
        return 'Slab beton bertulang wiremesh';
      case CalculationCategory.cutFill:
        return 'Tanah urug merah & pemadatan';
      case CalculationCategory.retainingWall:
        return 'Batu belah, adukan & pvc suling';
      case CalculationCategory.septicTank:
        return 'Bata merah, ijuk, kerikil filter & pipa';
      case CalculationCategory.batako:
        return 'Pasangan batako, semen & pasir';
      case CalculationCategory.glassBlock:
        return 'Glass block, perekat mortar & angkur';
      case CalculationCategory.kusenAluminium:
        return 'Batang kusen, sealant silikon & baut';
      case CalculationCategory.floorScreed:
        return 'Screeding lantai, semen & pasir';
      case CalculationCategory.pondasiSumuran:
        return 'Buis beton & cor pengisi';
      case CalculationCategory.plafonPvc:
        return 'Plafon PVC, rangka hollow & lis';
      case CalculationCategory.plintLantai:
        return 'Plint keramik lantai & adukan';
      case CalculationCategory.kusenKayu:
        return 'Kusen pintu kayu, lem & paku';
      case CalculationCategory.bakKontrol:
        return 'Bata merah bak kontrol & plat besi';
      case CalculationCategory.grassBlock:
        return 'Grass block paving, humus & rumput';
      case CalculationCategory.kanopi:
        return 'Rangka hollow minimalis & atap';
      case CalculationCategory.railing:
        return 'Pipa stainless & hollow vertical';
      case CalculationCategory.bajaWf:
        return 'Struktur baja WF-beam & gusset';
      case CalculationCategory.plumbing:
        return 'Pipa PVC AW/D, fitting & solvent';
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
