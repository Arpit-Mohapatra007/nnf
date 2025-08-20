class HabitData {
  final int currentStreak;
  final int longestStreak;
  final Map<DateTime, bool> dailyEntries;
  final DateTime? lastFailDate;
  final String? username;
  final String? userImagePath;
  final String? successImagePath;
  final String? failureImagePath;
  final bool isRegistered;
  
  HabitData({
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.dailyEntries = const {},
    this.lastFailDate,
    this.username,
    this.userImagePath,
    this.successImagePath,
    this.failureImagePath,
    this.isRegistered = false,
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
    String? username,
    String? userImagePath,
    String? successImagePath,
    String? failureImagePath,
    bool? isRegistered,
  }) {
    return HabitData(
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      dailyEntries: dailyEntries ?? this.dailyEntries,
      lastFailDate: lastFailDate ?? this.lastFailDate,
      username: username ?? this.username,
      userImagePath: userImagePath ?? this.userImagePath,
      successImagePath: successImagePath ?? this.successImagePath,
      failureImagePath: failureImagePath ?? this.failureImagePath,
      isRegistered: isRegistered ?? this.isRegistered,
    );
  }
}
