import 'package:flutter/foundation.dart';

import '../api/api_config.dart';
import '../api/meal_plan_api_client.dart';
import '../models/daily_plan.dart';
import '../models/regen_usage.dart';
import '../models/user_profile.dart';
import 'date_keys.dart';
import 'storage_service.dart';

enum AppPhase { loading, disclaimer, onboarding, home }

enum RemoveFoodOutcome { swapped, removedNoCredits, failed }

enum ProfileSaveOutcome { saved, savedWithBonus, blocked, failed }

class AppService extends ChangeNotifier {
  final StorageService _storage;
  final MealPlanApiClient _apiClient;

  AppService({required StorageService storage, MealPlanApiClient? apiClient})
      : _storage = storage,
        _apiClient = apiClient ?? createMealPlanApiClient();

  bool _loading = true;
  bool _disclaimerSeen = false;
  UserProfile? _profile;
  DailyPlan? _todayPlan;
  RegenUsage _todayUsage = const RegenUsage();
  List<String> _historyIndex = const [];
  bool _busy = false;
  String? _errorMessage;

  bool get busy => _busy;
  String? get errorMessage => _errorMessage;
  UserProfile? get profile => _profile;
  DailyPlan? get todayPlan => _todayPlan;
  RegenUsage get todayUsage => _todayUsage;
  List<String> get historyIndex => _historyIndex;

  AppPhase get phase {
    if (_loading) return AppPhase.loading;
    if (!_disclaimerSeen) return AppPhase.disclaimer;
    if (_profile == null) return AppPhase.onboarding;
    return AppPhase.home;
  }

  int get creditsRemaining => _todayUsage.creditsRemaining;
  bool get canRegenerate => _todayUsage.hasCredits;
  bool get profileSaveBlocked => !_todayUsage.hasCredits && _todayUsage.profileBonusUsed;
  bool get profileSaveUsesBonus => !_todayUsage.hasCredits && !_todayUsage.profileBonusUsed;

  static Future<AppService> bootstrap() async {
    final storage = await StorageService.create();
    final service = AppService(storage: storage);
    await service.init();
    return service;
  }

  void clearError() {
    if (_errorMessage == null) return;
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> init() async {
    _disclaimerSeen = _storage.disclaimerSeen;
    _profile = _storage.userProfile;
    _historyIndex = _storage.historyIndex;

    if (_profile != null) {
      await _rolloverIfNeeded();
      _todayUsage = _storage.regenUsage(todayKey());
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> _rolloverIfNeeded() async {
    final today = todayKey();
    final existing = _storage.dailyPlan(today);
    if (existing != null) {
      _todayPlan = existing;
      return;
    }

    final yesterday = yesterdayKey();
    final yesterdayPlan = _storage.dailyPlan(yesterday);
    if (yesterdayPlan != null && !_historyIndex.contains(yesterday)) {
      await _storage.addToHistoryIndex(yesterday);
      _historyIndex = _storage.historyIndex;
    }

    final profile = _profile;
    if (profile == null) return;
    try {
      final plan = await _apiClient.generatePlan(profile);
      await _storage.saveDailyPlan(today, plan);
      _todayPlan = plan;
    } catch (e) {
      _errorMessage = "Couldn't generate today's plan: $e";
    }
  }

  /// Retries generating today's plan after [_rolloverIfNeeded] failed
  /// (e.g. no network at launch). Called from the Home screen's error state.
  Future<void> retryTodayPlan() async {
    if (_profile == null || _todayPlan != null || _busy) return;
    _busy = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final plan = await _apiClient.generatePlan(_profile!);
      await _storage.saveDailyPlan(todayKey(), plan);
      _todayPlan = plan;
    } catch (e) {
      _errorMessage = "Couldn't generate today's plan: $e";
    } finally {
      _busy = false;
      notifyListeners();
    }
  }

  Future<void> acceptDisclaimer() async {
    await _storage.setDisclaimerSeen();
    _disclaimerSeen = true;
    notifyListeners();
  }

  /// Returns true on success. Profile is only persisted and onboarding
  /// only considered complete once the first plan actually generates.
  Future<bool> completeOnboarding(UserProfile profile) async {
    _busy = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final plan = await _apiClient.generatePlan(profile);
      await _storage.saveUserProfile(profile);
      await _storage.saveDailyPlan(todayKey(), plan);
      _todayUsage = const RegenUsage();
      await _storage.saveRegenUsage(todayKey(), _todayUsage);
      _profile = profile;
      _todayPlan = plan;
      return true;
    } catch (e) {
      _errorMessage = "Couldn't generate your plan: $e";
      return false;
    } finally {
      _busy = false;
      notifyListeners();
    }
  }

  Future<bool> regenerateToday() async {
    if (!canRegenerate || _profile == null || _busy) return false;
    _busy = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final plan = await _apiClient.generateFullPlan(_profile!);
      _todayUsage = _todayUsage.copyWith(creditsUsed: _todayUsage.creditsUsed + 1);
      await _storage.saveDailyPlan(todayKey(), plan);
      await _storage.saveRegenUsage(todayKey(), _todayUsage);
      _todayPlan = plan;
      return true;
    } catch (e) {
      _errorMessage = "Couldn't regenerate your plan: $e";
      return false;
    } finally {
      _busy = false;
      notifyListeners();
    }
  }

  Future<RemoveFoodOutcome> removeFood(int mealIndex, int foodIndex) async {
    final plan = _todayPlan;
    final profile = _profile;
    if (plan == null || profile == null) return RemoveFoodOutcome.failed;

    _busy = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final schedule = List<MealEntry>.from(plan.schedule);
      final meal = schedule[mealIndex];
      final foods = List<FoodItem>.from(meal.foods);

      if (_todayUsage.hasCredits) {
        final replacement = await _apiClient.swapFood(SwapFoodContext(
          profile: profile,
          currentPlan: plan,
          mealIndex: mealIndex,
          foodIndex: foodIndex,
        ));
        foods[foodIndex] = replacement;
        schedule[mealIndex] = meal.copyWith(foods: foods);
        _todayUsage = _todayUsage.copyWith(creditsUsed: _todayUsage.creditsUsed + 1);
        await _storage.saveRegenUsage(todayKey(), _todayUsage);
        _todayPlan = plan.copyWith(schedule: schedule);
        await _storage.saveDailyPlan(todayKey(), _todayPlan!);
        return RemoveFoodOutcome.swapped;
      } else {
        foods.removeAt(foodIndex);
        schedule[mealIndex] = meal.copyWith(foods: foods);
        _todayPlan = plan.copyWith(schedule: schedule);
        await _storage.saveDailyPlan(todayKey(), _todayPlan!);
        return RemoveFoodOutcome.removedNoCredits;
      }
    } catch (e) {
      _errorMessage = "Couldn't swap that food: $e";
      return RemoveFoodOutcome.failed;
    } finally {
      _busy = false;
      notifyListeners();
    }
  }

  Future<ProfileSaveOutcome> updateProfile(UserProfile newProfile) async {
    if (profileSaveBlocked || _busy) return ProfileSaveOutcome.blocked;

    _busy = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final usesBonus = profileSaveUsesBonus;
      final plan = await _apiClient.generateFullPlan(newProfile);

      await _storage.saveUserProfile(newProfile);
      await _storage.saveDailyPlan(todayKey(), plan);
      if (usesBonus) {
        _todayUsage = _todayUsage.copyWith(profileBonusUsed: true);
      } else {
        _todayUsage = _todayUsage.copyWith(creditsUsed: _todayUsage.creditsUsed + 1);
      }
      await _storage.saveRegenUsage(todayKey(), _todayUsage);

      _profile = newProfile;
      _todayPlan = plan;
      return usesBonus ? ProfileSaveOutcome.savedWithBonus : ProfileSaveOutcome.saved;
    } catch (e) {
      _errorMessage = "Couldn't save your profile: $e";
      return ProfileSaveOutcome.failed;
    } finally {
      _busy = false;
      notifyListeners();
    }
  }

  Future<DailyPlan?> loadHistoryDetail(String dateKey) async {
    return _storage.dailyPlan(dateKey);
  }

  /// Index of the meal whose time is the latest one at or before now (i.e.
  /// the most recently started meal) — the smallest non-negative time diff,
  /// not the largest.
  int currentMealIndex(DailyPlan plan) {
    final now = DateTime.now();
    final nowMinutes = now.hour * 60 + now.minute;
    var bestIndex = 0;
    int? bestDiff;
    for (var i = 0; i < plan.schedule.length; i++) {
      final parts = plan.schedule[i].time.split(':');
      final minutes = int.parse(parts[0]) * 60 + int.parse(parts[1]);
      final diff = nowMinutes - minutes;
      if (diff >= 0 && (bestDiff == null || diff < bestDiff)) {
        bestDiff = diff;
        bestIndex = i;
      }
    }
    return bestIndex;
  }
}
