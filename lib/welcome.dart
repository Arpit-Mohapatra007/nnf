import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nnf/popups/fail.dart';
import 'package:nnf/popups/success.dart';
import 'package:nnf/provider/habit_provider.dart';
import 'package:nnf/routes/route_names.dart';
import 'dart:io';

class Welcome extends ConsumerWidget {
  const Welcome({super.key});

  @override 
  Widget build(BuildContext context, WidgetRef ref) {
    final habitData = ref.watch(habitProvider);
    final today = DateTime.now();
    final todayKey = DateTime(today.year, today.month, today.day);
    final hasAnsweredToday = habitData.dailyEntries.containsKey(todayKey);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Check-in'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.dashboard),
            onPressed: () {
              context.goNamed(AppRouteNames.dashboard);
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // User profile picture
              if (habitData.userImagePath != null)
                CircleAvatar(
                  radius: 60,
                  backgroundImage: FileImage(File(habitData.userImagePath!)),
                ),
              const SizedBox(height: 20),
              
              // Greeting with username
              Text(
                'Hello, ${habitData.username ?? 'User'}!',
                style: const TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 10),
              
              // Current streak display
              if (habitData.currentStreak > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Text(
                    '🔥 ${habitData.currentStreak} Day Streak!',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const SizedBox(height: 30),
              
              // Question
              Text(
                hasAnsweredToday 
                    ? 'You\'ve already checked in today!'
                    : 'Did you stay clean today?',
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.w500
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              
              if (!hasAnsweredToday) ...[
                // Answer buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        showSuccessPopup(context: context, ref: ref);
                      },
                      icon: const Icon(Icons.check_circle, color: Colors.white),
                      label: const Text(
                        'Yes, I stayed clean!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        showFailPopup(context: context, ref: ref);
                      },
                      icon: const Icon(Icons.cancel, color: Colors.white),
                      label: const Text(
                        'No, I failed',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                // Already answered today
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.blue),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        habitData.dailyEntries[todayKey] == true 
                            ? Icons.check_circle 
                            : Icons.cancel,
                        size: 50,
                        color: habitData.dailyEntries[todayKey] == true 
                            ? Colors.green 
                            : Colors.red,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        habitData.dailyEntries[todayKey] == true 
                            ? 'Great job staying clean today!'
                            : 'Tomorrow is a new opportunity',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: () {
                          context.goNamed(AppRouteNames.dashboard);
                        },
                        child: const Text('Go to Dashboard'),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}