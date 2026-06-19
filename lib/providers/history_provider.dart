import 'package:flutter/material.dart';
import '../data/models/project.dart';
import '../data/repos/project_repo.dart';

class HistoryProvider with ChangeNotifier {
  final ProjectRepository _repo;
  List<Project> _projects = [];

  HistoryProvider(this._repo) {
    loadProjects();
  }

  List<Project> get projects => _projects;

  void loadProjects() {
    _projects = _repo.getAllProjects();
    notifyListeners();
  }

  Future<void> saveProject({
    required String name,
    required String category,
    required Map<String, String> inputs,
    required List<Map<dynamic, dynamic>> requirementsData,
    required double totalCost,
    String? id,
  }) async {
    final project = Project(
      id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      date: DateTime.now(),
      category: category,
      inputs: inputs,
      requirementsData: requirementsData,
      totalCost: totalCost,
    );
    await _repo.saveProject(project);
    loadProjects();
  }

  Future<void> renameProject(String id, String newName) async {
    try {
      final existing = _projects.firstWhere((p) => p.id == id);
      final updatedProject = Project(
        id: existing.id,
        name: newName,
        date: existing.date,
        category: existing.category,
        inputs: existing.inputs,
        requirementsData: existing.requirementsData,
        totalCost: existing.totalCost,
      );
      await _repo.saveProject(updatedProject);
      loadProjects();
    } catch (_) {}
  }

  Future<void> deleteProject(String id) async {
    await _repo.deleteProject(id);
    loadProjects();
  }

  Future<void> clearHistory() async {
    await _repo.clearAllProjects();
    loadProjects();
  }
}
