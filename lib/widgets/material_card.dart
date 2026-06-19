import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/models/calculation_result.dart';

class MaterialCard extends StatelessWidget {
  final MaterialRequirement requirement;

  const MaterialCard({super.key, required this.requirement});

  IconData _getIconForKey(String key) {
    final k = key.toLowerCase();
    if (k.contains('semen')) {
      return Icons.layers;
    } else if (k.contains('pasir')) {
      return Icons.grain;
    } else if (k.contains('kerikil')) {
      return Icons.grid_goldenratio;
    } else if (k.contains('air')) {
      return Icons.water_drop;
    } else if (k.contains('bata') || k.contains('hebel')) {
      return Icons.crop_landscape;
    } else if (k.contains('keramik')) {
      return Icons.dashboard_customize;
    } else if (k.contains('genteng') || k.contains('roof')) {
      return Icons.roofing;
    } else if (k.contains('kayu') || k.contains('usuk') || k.contains('reng')) {
      return Icons.align_vertical_bottom;
    } else if (k.contains('cat')) {
      return Icons.format_paint;
    } else if (k.contains('plywood') || k.contains('multiplex')) {
      return Icons.view_agenda;
    } else if (k.contains('batu_belah')) {
      return Icons.foundation;
    } else if (k.contains('besi')) {
      return Icons.view_headline;
    } else if (k.contains('kawat')) {
      return Icons.cable;
    } else if (k.contains('paku')) {
      return Icons.push_pin;
    } else if (k.contains('baja') || k.contains('sekrup')) {
      return Icons.hardware;
    } else if (k.contains('gypsum')) {
      return Icons.view_quilt;
    } else if (k.contains('hollow') || k.contains('stud') || k.contains('runner')) {
      return Icons.grid_3x3;
    } else if (k.contains('paving')) {
      return Icons.grid_view;
    } else if (k.contains('kanstin')) {
      return Icons.splitscreen;
    } else if (k.contains('panel') || k.contains('precast')) {
      return Icons.view_day;
    } else if (k.contains('waterproofing')) {
      return Icons.water;
    } else if (k.contains('sirtu')) {
      return Icons.landscape;
    } else if (k.contains('compound')) {
      return Icons.cloud;
    } else if (k.contains('tape')) {
      return Icons.linear_scale;
    }
    return Icons.build;
  }

  Color _getColorForKey(String key) {
    final k = key.toLowerCase();
    if (k.contains('semen')) {
      return Colors.blueGrey;
    } else if (k.contains('pasir')) {
      return Colors.amber.shade700;
    } else if (k.contains('kerikil')) {
      return Colors.grey.shade600;
    } else if (k.contains('air')) {
      return Colors.blue;
    } else if (k.contains('bata') || k.contains('hebel')) {
      return Colors.deepOrange;
    } else if (k.contains('keramik')) {
      return Colors.teal;
    } else if (k.contains('genteng')) {
      return Colors.brown;
    } else if (k.contains('kayu')) {
      return Colors.orange.shade800;
    } else if (k.contains('cat')) {
      return Colors.purple;
    } else if (k.contains('batu_belah')) {
      return Colors.brown.shade700;
    } else if (k.contains('besi')) {
      return Colors.blueGrey.shade800;
    } else if (k.contains('kawat') || k.contains('paku')) {
      return Colors.grey.shade700;
    } else if (k.contains('baja') || k.contains('sekrup')) {
      return Colors.cyan.shade800;
    } else if (k.contains('gypsum')) {
      return Colors.teal.shade700;
    } else if (k.contains('hollow') || k.contains('stud') || k.contains('runner')) {
      return Colors.blueGrey.shade700;
    } else if (k.contains('paving')) {
      return Colors.indigo.shade400;
    } else if (k.contains('kanstin')) {
      return Colors.grey.shade700;
    } else if (k.contains('panel') || k.contains('precast')) {
      return Colors.blueGrey.shade600;
    } else if (k.contains('waterproofing')) {
      return Colors.indigo.shade600;
    } else if (k.contains('sirtu')) {
      return Colors.brown.shade400;
    } else if (k.contains('compound')) {
      return Colors.grey.shade400;
    } else if (k.contains('tape')) {
      return Colors.teal.shade300;
    }
    return Colors.amber;
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    final itemIcon = _getIconForKey(requirement.key);
    final themeColor = _getColorForKey(requirement.key);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: themeColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                itemIcon,
                color: themeColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    requirement.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF263238),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${requirement.quantity} ${requirement.unit}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  if (requirement.unitPrice > 0) ...[
                    const SizedBox(height: 4),
                    Text(
                      '@ ${currencyFormat.format(requirement.unitPrice)} / ${requirement.unit}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (requirement.unitPrice > 0)
              Text(
                currencyFormat.format(requirement.totalPrice),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF263238),
                ),
              )
            else
              Text(
                'Estimasi',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
