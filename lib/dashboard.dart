import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nnf/provider/habit_provider.dart';
import 'package:nnf/routes/route_names.dart';

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
            icon: const Icon(Icons.warning_amber_outlined),
            onPressed: () {
              context.goNamed(AppRouteNames.rewards);
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Profile section
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 19, 104, 160),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/avatar.png'),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('Username', style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        )),
                        Text(
                          'Badge:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // Dynamic data cards
              Card(
                child: ListTile(
                  title: const Text('Longest Streak'),
                  subtitle: Text('${habitData.longestStreak} days'),
                  leading: const Icon(Icons.calendar_month_outlined),
                ),
              ),
              Card(
                child: ListTile(
                  title: const Text('Current Streak'),
                  subtitle: Text('${habitData.currentStreak} days'),
                  leading: const Icon(Icons.calendar_today_outlined),
                ),
              ),
              Card(
                child: ListTile(
                  title: const Text('Last Fap'),
                  subtitle: Text(_getLastFailText(habitData.lastFailDate)),
                  leading: const Icon(Icons.history_outlined),
                ),
              ),
              Card(
                child: ListTile(
                  title: const Text('Total Faps this month'),
                  subtitle: Text('${_getMonthlyFapCount(habitData.dailyEntries)}'),
                  leading: const Icon(Icons.bar_chart_outlined),
                ),
              ),
              Card(
                child: ListTile(
                  title: const Text('Total Faps this year'),
                  subtitle: Text('${_getYearlyFapCount(habitData.dailyEntries)}'),
                  leading: const Icon(Icons.show_chart_outlined),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  String _getLastFailText(DateTime? lastFailDate) {
    if (lastFailDate == null) return 'Never';
    
    final now = DateTime.now();
    final difference = now.difference(lastFailDate).inDays;
    
    if (difference == 0) return 'Today';
    if (difference == 1) return 'Yesterday';
    return '$difference days ago';
  }
  
  int _getMonthlyFapCount(Map<DateTime, bool> dailyEntries) {
    final now = DateTime.now();
    
    return dailyEntries.entries
        .where((entry) => 
            entry.key.year == now.year &&
            entry.key.month == now.month &&
            entry.value == false)
        .length;
  }
  
  int _getYearlyFapCount(Map<DateTime, bool> dailyEntries) {
    final now = DateTime.now();
    
    return dailyEntries.entries
        .where((entry) => 
            entry.key.year == now.year &&
            entry.value == false)
        .length;
  }
}
