import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ProfilePage extends StatefulWidget {
  static const routeName = '/Profile';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = "";
  String email = "";
  int points = 0;
  int level = 1;
  int streak = 0;
  List<dynamic> workHistory = [];
  bool _loading = true;

  final List<Map<String, String>> badges = [
    {"name": "Recycling Novice", "icon": "♻️"},
    {"name": "Plastic Hero", "icon": "🛍️"},
    {"name": "Eco Warrior", "icon": "🌱"},
  ];

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    try {
      // Fetch profile and reports in parallel
      final results = await Future.wait([
        ApiService.getProfile(),
        ApiService.getUserReports(),
      ]);

      final profile = results[0] as Map<String, dynamic>;
      final reports = results[1] as List<dynamic>;

      setState(() {
        username = profile['username'] ?? 'User';
        email = profile['email'] ?? '';
        points = profile['points'] ?? 0;
        level = profile['level'] ?? 1;
        streak = profile['streak'] ?? 0;
        // Sort reports newest first
        workHistory = reports
          ..sort((a, b) => DateTime.parse(b['createdAt'])
              .compareTo(DateTime.parse(a['createdAt'])));
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Points needed for next level (every 200 pts = 1 level)
    final int pointsInCurrentLevel = points % 200;
    final int pointsToNextLevel = 200 - pointsInCurrentLevel;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Gamification'),
        centerTitle: true,
        backgroundColor: Colors.green[700],
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadAll,
              child: SafeArea(
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 16,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // ── User Info ──────────────────────────────
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.green,
                            child: Text(
                              username.isNotEmpty
                                  ? username[0].toUpperCase()
                                  : '?',
                              style: TextStyle(
                                  fontSize: 36,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(username,
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 2),
                              Text(email,
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[600])),
                              const SizedBox(height: 4),
                              Text("Level $level",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.green[700],
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // ── Points Card ────────────────────────────
                      Card(
                        color: Colors.green[700],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _statBox('Total Points', '$points', Icons.star_rounded),
                              _divider(),
                              _statBox('Level', '$level', Icons.trending_up_rounded),
                              _divider(),
                              _statBox('Streak', '$streak days', Icons.local_fire_department_rounded),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ── Progress to Next Level ─────────────────
                      Text("Progress to Next Level",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: pointsInCurrentLevel / 200,
                          backgroundColor: Colors.grey[300],
                          color: Colors.green,
                          minHeight: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$pointsInCurrentLevel / 200 pts  •  $pointsToNextLevel pts to Level ${level + 1}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 24),

                      // ── Badges ─────────────────────────────────
                      Text("Achievements / Badges",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: badges.length,
                          itemBuilder: (context, index) {
                            final badge = badges[index];
                            return Container(
                              margin: EdgeInsets.only(right: 12),
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.green[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(badge["icon"]!,
                                      style: TextStyle(fontSize: 28)),
                                  const SizedBox(height: 4),
                                  Text(badge["name"]!,
                                      style: TextStyle(fontSize: 12)),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ── Work History (real reports) ────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Work History",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          Text('${workHistory.length} reports',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[600])),
                        ],
                      ),
                      const SizedBox(height: 8),
                      workHistory.isEmpty
                          ? Card(
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Center(
                                    child: Text('No reports submitted yet',
                                        style: TextStyle(
                                            color: Colors.grey[600]))),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: workHistory.length,
                              itemBuilder: (context, index) {
                                final item =
                                    workHistory[index] as Map<String, dynamic>;
                                final date = DateTime.tryParse(
                                        item['createdAt'] ?? '') ??
                                    DateTime.now();
                                final status =
                                    item['status'] as String? ?? 'Pending';
                                final isCompleted = status == 'Completed';

                                return Card(
                                  margin: EdgeInsets.only(bottom: 8),
                                  child: ListTile(
                                    leading: Icon(
                                      isCompleted
                                          ? Icons.check_circle
                                          : Icons.hourglass_empty,
                                      color: isCompleted
                                          ? Colors.green
                                          : Colors.orange,
                                    ),
                                    title: Text(
                                      item['description'] as String? ??
                                          'Report',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: Text(
                                      '${date.day}/${date.month}/${date.year}  •  $status',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    trailing: item['points'] != null
                                        ? Text(
                                            '+${item['points']} pts',
                                            style: TextStyle(
                                                color: Colors.green[700],
                                                fontWeight: FontWeight.w600),
                                          )
                                        : null,
                                  ),
                                );
                              },
                            ),
                      const SizedBox(height: 24),

                      // ── Settings ───────────────────────────────
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Settings tapped")),
                            );
                          },
                          icon: Icon(Icons.settings),
                          label: Text("Settings",
                              style: TextStyle(
                                  color: Color.fromRGBO(255, 255, 255, 1.0))),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _statBox(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 22),
        const SizedBox(height: 4),
        Text(value,
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        Text(label,
            style: TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }

  Widget _divider() {
    return Container(
        height: 40, width: 1, color: Colors.white.withOpacity(0.3));
  }
}