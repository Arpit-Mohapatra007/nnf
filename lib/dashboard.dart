import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nnf/routes/route_names.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
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
              //profile
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
                          color: Colors.black87)),
                        Text(
                          'Badge:', 
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              //calendar
              Card(
                child: ListTile(
                  title: const Text('Longest Streak'),
                  subtitle: const Text('0 days'),
                  leading: const Icon(Icons.calendar_month_outlined),
                ),
              ),
              Card(
                child: ListTile(
                  title: const Text('Current Streak'),
                  subtitle: const Text('0 days'),
                  leading: const Icon(Icons.calendar_today_outlined),
                ),
              ),
              Card(
                child: ListTile(
                  title: const Text('Last Fap'),
                  subtitle: const Text('Never'),
                  leading: const Icon(Icons.history_outlined),
                ),
              ),
              Card(
                child: ListTile(
                  title: const Text('Total Faps this month'),
                  subtitle: const Text('0'),
                  leading: const Icon(Icons.bar_chart_outlined),
                ),
              ),
              Card(
                child: ListTile(
                  title: const Text('Total Faps this year'),
                  subtitle: const Text('0'),
                  leading: const Icon(Icons.show_chart_outlined),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}