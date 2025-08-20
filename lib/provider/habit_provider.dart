import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nnf/launcher/whatsapp_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/habit_data.dart';

class HabitNotifier extends StateNotifier<HabitData> {
  HabitNotifier() : super(HabitData()) {
    _loadUserData(); // Load data when provider initializes
  }

  // Load user data from persistent storage
  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final username = prefs.getString('username');
      final phoneNumber = prefs.getString('phoneNumber');
      final userImagePath = prefs.getString('userImagePath');
      final successImagePath = prefs.getString('successImagePath');
      final failureImagePath = prefs.getString('failureImagePath');
      final isRegistered = prefs.getBool('isRegistered') ?? false;
      final currentStreak = prefs.getInt('currentStreak') ?? 0;
      final longestStreak = prefs.getInt('longestStreak') ?? 0;
      
      // Load last fail date
      final lastFailDateString = prefs.getString('lastFailDate');
      DateTime? lastFailDate;
      if (lastFailDateString != null) {
        lastFailDate = DateTime.tryParse(lastFailDateString);
      }
      
      // Load daily entries
      final dailyEntriesKeys = prefs.getStringList('dailyEntriesKeys') ?? [];
      final dailyEntriesValues = prefs.getStringList('dailyEntriesValues') ?? [];
      final Map<DateTime, bool> dailyEntries = {};
      
      for (int i = 0; i < dailyEntriesKeys.length && i < dailyEntriesValues.length; i++) {
        final date = DateTime.tryParse(dailyEntriesKeys[i]);
        final value = dailyEntriesValues[i] == 'true';
        if (date != null) {
          dailyEntries[date] = value;
        }
      }
      
      // Always update the state with loaded data
      state = state.copyWith(
        username: username,
        phoneNumber: phoneNumber,
        userImagePath: userImagePath,
        successImagePath: successImagePath,
        failureImagePath: failureImagePath,
        isRegistered: isRegistered,
        currentStreak: currentStreak,
        longestStreak: longestStreak,
        lastFailDate: lastFailDate,
        dailyEntries: dailyEntries,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Save user data to persistent storage
  Future<void> _saveUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setString('username', state.username ?? '');
      await prefs.setString('phoneNumber', state.phoneNumber ?? '');
      await prefs.setString('userImagePath', state.userImagePath ?? '');
      await prefs.setString('successImagePath', state.successImagePath ?? '');
      await prefs.setString('failureImagePath', state.failureImagePath ?? '');
      await prefs.setBool('isRegistered', state.isRegistered);
      await prefs.setInt('currentStreak', state.currentStreak);
      await prefs.setInt('longestStreak', state.longestStreak);
      
      if (state.lastFailDate != null) {
        await prefs.setString('lastFailDate', state.lastFailDate!.toIso8601String());
      }
      
      // Save daily entries
      final keys = state.dailyEntries.keys.map((date) => date.toIso8601String()).toList();
      final values = state.dailyEntries.values.map((value) => value.toString()).toList();
      await prefs.setStringList('dailyEntriesKeys', keys);
      await prefs.setStringList('dailyEntriesValues', values);
    } catch (e) {
      rethrow;
    }
  }
  
  void registerUser({
    required String username,
    required String phoneNumber,
    required String userImagePath,
    required String successImagePath,
    required String failureImagePath,
  }) {
    state = state.copyWith(
      username: username,
      phoneNumber: phoneNumber,
      userImagePath: userImagePath,
      successImagePath: successImagePath,
      failureImagePath: failureImagePath,
      isRegistered: true,
    );
    _saveUserData(); // Persist the data
  }
  
  void recordSuccess() {
    final today = HabitData.todayKey();
    final newCurrentStreak = state.currentStreak + 1;
    final newLongestStreak = newCurrentStreak > state.longestStreak 
        ? newCurrentStreak 
        : state.longestStreak;
    
    final updatedEntries = Map<DateTime, bool>.from(state.dailyEntries);
    updatedEntries[today] = true;
    
    state = state.copyWith(
      currentStreak: newCurrentStreak,
      longestStreak: newLongestStreak,
      dailyEntries: updatedEntries,
    );
    _saveUserData();
    
    // Send WhatsApp message using user's registered phone number
    if (state.phoneNumber != null && state.phoneNumber!.isNotEmpty) {
      sendWhatsAppMessage(
        state.phoneNumber!, 
        "Hi ${state.username ?? 'friend'}! I stayed strong today and didn't give in. Current streak: $newCurrentStreak days!"
      );
    }
  }
  
  void recordFailure() {
    final today = HabitData.todayKey();
    
    final updatedEntries = Map<DateTime, bool>.from(state.dailyEntries);
    updatedEntries[today] = false;
    
    state = state.copyWith(
      currentStreak: 0,
      dailyEntries: updatedEntries,
      lastFailDate: today,
    );
    _saveUserData();
    
    // Send WhatsApp message using user's registered phone number
    if (state.phoneNumber != null && state.phoneNumber!.isNotEmpty) {
      sendWhatsAppMessage(
        state.phoneNumber!, 
        "Hi, this is ${state.username ?? 'someone'}. I failed today and broke my streak. My longest streak was ${state.longestStreak} days. I need your support to get back on track."
      );
    }
  }

  // Method to reset all data (for testing or account reset)
  Future<void> resetUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      state = HabitData(); // Reset to initial state
    } catch (e) {
      rethrow;
    }
  }
}

// Create a FutureProvider that waits for the data to load
final habitDataLoaderProvider = FutureProvider<bool>((ref) async {
  final notifier = ref.watch(habitProvider.notifier);
  await notifier._loadUserData();
  return true;
});

final habitProvider = StateNotifierProvider<HabitNotifier, HabitData>((ref) {
  return HabitNotifier();
});