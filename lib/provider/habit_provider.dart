import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/habit_data.dart';

class HabitNotifier extends StateNotifier<HabitData> {
  HabitNotifier() : super(HabitData());
  
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
  }
}

final habitProvider = StateNotifierProvider<HabitNotifier, HabitData>((ref) {
  return HabitNotifier();
});
