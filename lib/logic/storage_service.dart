import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/daily_plan.dart';
import '../models/regen_usage.dart';
import '../models/user_profile.dart';

class StorageService {
  static const _disclaimerSeenKey = 'disclaimer_seen';
  static const _userProfileKey = 'user_profile';
  static const _historyIndexKey = 'history_index';
  static const _dailyPlanPrefix = 'daily_plan_';
  static const _regenUsagePrefix = 'regen_usage_';

  final SharedPreferences _prefs;

  StorageService._(this._prefs);

  static Future<StorageService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService._(prefs);
  }

  bool get disclaimerSeen => _prefs.getBool(_disclaimerSeenKey) ?? false;

  Future<void> setDisclaimerSeen() => _prefs.setBool(_disclaimerSeenKey, true);

  UserProfile? get userProfile {
    final raw = _prefs.getString(_userProfileKey);
    if (raw == null) return null;
    return UserProfile.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> saveUserProfile(UserProfile profile) =>
      _prefs.setString(_userProfileKey, jsonEncode(profile.toJson()));

  DailyPlan? dailyPlan(String dateKey) {
    final raw = _prefs.getString('$_dailyPlanPrefix$dateKey');
    if (raw == null) return null;
    return DailyPlan.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> saveDailyPlan(String dateKey, DailyPlan plan) =>
      _prefs.setString('$_dailyPlanPrefix$dateKey', jsonEncode(plan.toJson()));

  RegenUsage regenUsage(String dateKey) {
    final raw = _prefs.getString('$_regenUsagePrefix$dateKey');
    if (raw == null) return const RegenUsage();
    return RegenUsage.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> saveRegenUsage(String dateKey, RegenUsage usage) =>
      _prefs.setString('$_regenUsagePrefix$dateKey', jsonEncode(usage.toJson()));

  List<String> get historyIndex =>
      _prefs.getStringList(_historyIndexKey) ?? const [];

  Future<void> saveHistoryIndex(List<String> dates) =>
      _prefs.setStringList(_historyIndexKey, dates);

  Future<void> addToHistoryIndex(String dateKey) async {
    final current = List<String>.from(historyIndex);
    if (current.contains(dateKey)) return;
    current.insert(0, dateKey);
    await saveHistoryIndex(current);
  }
}
