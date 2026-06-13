import 'package:hive/hive.dart';

part 'project.g.dart';

@HiveType(typeId: 0)
class Project extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  final String category; // 'beton', 'pondasi', etc.

  @HiveField(4)
  final Map<String, String> inputs;

  @HiveField(5)
  final List<Map<dynamic, dynamic>> requirementsData;

  @HiveField(6)
  final double totalCost;

  Project({
    required this.id,
    required this.name,
    required this.date,
    required this.category,
    required this.inputs,
    required this.requirementsData,
    required this.totalCost,
  });
}
