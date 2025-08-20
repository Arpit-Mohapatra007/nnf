import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nnf/routes/route_names.dart';

class Rewards extends StatelessWidget {
  const Rewards({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.goNamed(AppRouteNames.dashboard),
        ),
        title: const Text('Rewards'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // 7-Day Streak
            Card(
              elevation: 4,
              child: ListTile(
                title: const Text('7-Day Streak'),
                subtitle: const Text('First Week Champion - Bronze Shield Badge'),
                leading: Icon(
                  Icons.shield,
                  color: Colors.brown[600],
                  size: 30,
                ),
              ),
            ),
            const SizedBox(height: 8),
            
            // 14-Day Streak
            Card(
              elevation: 4,
              child: ListTile(
                title: const Text('14-Day Streak'),
                subtitle: const Text('Two Week Titan - Silver Crown Badge'),
                leading: Icon(
                  Icons.workspace_premium,
                  color: Colors.grey[400],
                  size: 30,
                ),
              ),
            ),
            const SizedBox(height: 8),
            
            // 1-Month Streak
            Card(
              elevation: 4,
              child: ListTile(
                title: const Text('1-Month Streak'),
                subtitle: const Text('Monthly Master - Gold Trophy Badge'),
                leading: const Icon(
                  Icons.emoji_events,
                  color: Colors.amber,
                  size: 30,
                ),
              ),
            ),
            const SizedBox(height: 8),
            
            // 60-Day Streak
            Card(
              elevation: 4,
              child: ListTile(
                title: const Text('60-Day Streak'),
                subtitle: const Text('Diamond Achiever - Advanced Insights'),
                leading: Icon(
                  Icons.diamond,
                  color: Colors.cyan[300],
                  size: 30,
                ),
              ),
            ),
            const SizedBox(height: 8),
            
            // 90-Day Streak
            Card(
              elevation: 4,
              child: ListTile(
                title: const Text('90-Day Streak'),
                subtitle: const Text('Platinum Legend - Sharing Unlocked'),
                leading: Icon(
                  Icons.military_tech,
                  color: Colors.blueGrey[300],
                  size: 30,
                ),
              ),
            ),
            const SizedBox(height: 8),
            
            // 6-Month Streak
            Card(
              elevation: 4,
              child: ListTile(
                title: const Text('6-Month Streak'),
                subtitle: const Text('Hall of Fame - Ultimate Recognition'),
                leading: const Icon(
                  Icons.stars,
                  color: Colors.purple,
                  size: 30,
                ),
              ),
            ),
            const SizedBox(height: 8),
            
            // 1-Year Streak
            Card(
              elevation: 4,
              child: ListTile(
                title: const Text('1-Year Streak'),
                subtitle: const Text('Lifetime Achievement - Master Status'),
                leading: const Icon(
                  Icons.auto_awesome,
                  color: Colors.deepPurple,
                  size: 30,
                ),
               ),
            ),
          ],
        ),
      ),
    );
  }
}
