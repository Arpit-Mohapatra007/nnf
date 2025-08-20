import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nnf/provider/habit_provider.dart';
import 'package:nnf/routes/route_names.dart';
import 'dart:io';

class Dashboard extends ConsumerWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitData = ref.watch(habitProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.emoji_events),
            onPressed: () {
              context.goNamed(AppRouteNames.rewards);
            },
          ),
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              context.goNamed(AppRouteNames.welcome);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Enhanced profile section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 19, 104, 160),
                      const Color.fromARGB(255, 30, 136, 200),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Profile picture
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: habitData.userImagePath != null 
                          ? FileImage(File(habitData.userImagePath!))
                          : const AssetImage('assets/avatar.png') as ImageProvider,
                      backgroundColor: Colors.white,
                    ),
                    const SizedBox(height: 15),
                    
                    // Username
                    Text(
                      habitData.username ?? 'Username', 
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: Text(
                        _getBadgeText(habitData.currentStreak),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              // Stats grid
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: 1.3,
                children: [
                  _buildStatCard(
                    'Current Streak',
                    '${habitData.currentStreak}',
                    'days',
                    Icons.local_fire_department,
                    Colors.orange,
                  ),
                  _buildStatCard(
                    'Longest Streak',
                    '${habitData.longestStreak}',
                    'days',
                    Icons.emoji_events,
                    Colors.amber,
                  ),
                  _buildStatCard(
                    'This Month',
                    '${_getMonthlyCleanDays(habitData.dailyEntries)}',
                    'clean days',
                    Icons.calendar_month,
                    Colors.green,
                  ),
                  _buildStatCard(
                    'Success Rate',
                    '${_getSuccessRate(habitData.dailyEntries)}%',
                    'overall',
                    Icons.trending_up,
                    Colors.blue,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Additional stats
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: const Text(
                    'Last Failure',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    _getLastFailText(habitData.lastFailDate),
                    style: const TextStyle(fontSize: 16),
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.history, color: Colors.red),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Quick actions
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.goNamed(AppRouteNames.rewards);
                      },
                      icon: const Icon(Icons.emoji_events),
                      label: const Text('View Rewards'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.goNamed(AppRouteNames.welcome);
                      },
                      icon: const Icon(Icons.add_task),
                      label: const Text('Daily Check-in'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildStatCard(String title, String value, String subtitle, IconData icon, Color color) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.1),
              color.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  
  String _getBadgeText(int currentStreak) {
    if (currentStreak >= 365) return '🏆 Lifetime Master';
    if (currentStreak >= 180) return '⭐ Hall of Fame';
    if (currentStreak >= 90) return '💎 Platinum Legend';
    if (currentStreak >= 60) return '💍 Diamond Achiever';
    if (currentStreak >= 30) return '🥇 Monthly Master';
    if (currentStreak >= 14) return '🥈 Two Week Titan';
    if (currentStreak >= 7) return '🥉 First Week Champion';
    return '🔰 Beginner';
  }
  
  String _getLastFailText(DateTime? lastFailDate) {
    if (lastFailDate == null) return 'Never';
    
    final now = DateTime.now();
    final difference = now.difference(lastFailDate).inDays;
    
    if (difference == 0) return 'Today';
    if (difference == 1) return 'Yesterday';
    if (difference < 7) return '$difference days ago';
    if (difference < 30) return '${(difference / 7).floor()} weeks ago';
    if (difference < 365) return '${(difference / 30).floor()} months ago';
    return '${(difference / 365).floor()} years ago';
  }
  
  int _getMonthlyCleanDays(Map<DateTime, bool> dailyEntries) {
    final now = DateTime.now();
    
    return dailyEntries.entries
        .where((entry) => 
            entry.key.year == now.year &&
            entry.key.month == now.month &&
            entry.value == true)
        .length;
  }
  
  int _getSuccessRate(Map<DateTime, bool> dailyEntries) {
    if (dailyEntries.isEmpty) return 0;
    
    final totalDays = dailyEntries.length;
    final successfulDays = dailyEntries.values.where((value) => value == true).length;
    
    return ((successfulDays / totalDays) * 100).round();
  }
}