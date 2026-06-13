import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants.dart';
import '../models/project.dart';

class ProjectRepository {
  late Box<Project> _projectBox;
  late Box _settingsBox;

  Future<void> init() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ProjectAdapter());
    }
    _projectBox = await Hive.openBox<Project>(BoxNames.projects);
    _settingsBox = await Hive.openBox(BoxNames.settings);
  }

  // --- Project CRUD ---

  List<Project> getAllProjects() {
    return _projectBox.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // Newest first
  }

  Future<void> saveProject(Project project) async {
    await _projectBox.put(project.id, project);
  }

  Future<void> deleteProject(String id) async {
    await _projectBox.delete(id);
  }

  Future<void> clearAllProjects() async {
    await _projectBox.clear();
  }

  // --- Prices Settings ---

  Map<String, double> getCustomPrices() {
    final stored = _settingsBox.get(SettingKeys.materialPrices);
    if (stored == null) return {};
    
    // Hive maps might be Map<dynamic, dynamic>
    final Map<dynamic, dynamic> rawMap = stored as Map;
    final Map<String, double> prices = {};
    rawMap.forEach((key, value) {
      prices[key.toString()] = (value as num).toDouble();
    });
    return prices;
  }

  Future<void> saveCustomPrices(Map<String, double> prices) async {
    await _settingsBox.put(SettingKeys.materialPrices, prices);
  }
}
