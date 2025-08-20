class HabitData {
  final int currentStreak;
  final int longestStreak;
  final Map<DateTime, bool> dailyEntries; 
  final DateTime? lastFailDate;
  
  HabitData({
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.dailyEntries = const {},
    this.lastFailDate,
  });
  
  static DateTime todayKey() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }
  
   HabitData copyWith({
    int? currentStreak,
    int? longestStreak,
    Map<DateTime, bool>? dailyEntries,
    DateTime? lastFailDate,
  }) {
    return HabitData(
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      dailyEntries: dailyEntries ?? this.dailyEntries,
      lastFailDate: lastFailDate ?? this.lastFailDate,
    );
  }
}
