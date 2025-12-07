import 'package:flutter/foundation.dart';

import '../data/health_record_db.dart';
import '../models/health_record.dart';

class HealthRecordProvider extends ChangeNotifier {
  final HealthRecordDb _db = HealthRecordDb.instance;

  List<HealthRecord> _records = [];
  String _searchQuery = '';
  bool _isLoading = false;

  List<HealthRecord> get records {
    if (_searchQuery.isEmpty) return _records;
    return _records.where((r) => r.date.contains(_searchQuery)).toList();
  }

  bool get isLoading => _isLoading;

  Future<void> loadRecords() async {
    _isLoading = true;
    notifyListeners();

    _records = await _db.getAllRecords();

    _isLoading = false;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> addRecord(HealthRecord record) async {
    await _db.insertRecord(record);
    await loadRecords();
  }

  Future<void> updateRecord(HealthRecord record) async {
    if (record.id == null) return;
    await _db.updateRecord(record);
    await loadRecords();
  }

  Future<void> deleteRecord(int id) async {
    await _db.deleteRecord(id);
    await loadRecords();
  }

  int totalWaterForDate(String date) {
    return _records
        .where((r) => r.date == date)
        .fold(0, (sum, r) => sum + r.water);
  }

  int totalStepsForDate(String date) {
    return _records
        .where((r) => r.date == date)
        .fold(0, (sum, r) => sum + r.steps);
  }

  int totalCaloriesForDate(String date) {
    return _records
        .where((r) => r.date == date)
        .fold(0, (sum, r) => sum + r.calories);
  }
}
