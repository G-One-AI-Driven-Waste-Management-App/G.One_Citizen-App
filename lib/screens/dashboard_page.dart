// dashboard_page.dart - FULL UPDATED FILE
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import '../services/api_service.dart';
import 'login_page.dart';
import 'profile_page.dart';
import 'report_page.dart';
import 'scanner_page.dart';
import 'training_page.dart';
import 'schedule_page.dart';
import 'nearest_centers_page.dart';

class DashboardContent extends StatefulWidget {
  const DashboardContent({Key? key}) : super(key: key);

  @override
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  List<dynamic> _leaderboard = [];
  bool _loadingLeaderboard = true;

  @override
  void initState() {
    super.initState();
    _loadLeaderboard();
  }

  Future<void> _loadLeaderboard() async {
    try {
      final data = await ApiService.getLeaderboard();
      // Sort by points descending
      data.sort((a, b) => (b['points'] as int).compareTo(a['points'] as int));
      setState(() {
        _leaderboard = data.take(3).toList();
        _loadingLeaderboard = false;
      });
    } catch (e) {
      setState(() => _loadingLeaderboard = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String username = 'Guest';
        if (state is Authenticated) username = state.username;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Card
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Icon(Icons.local_shipping_rounded, size: 44, color: primary),
                      ),
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Welcome, $username',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                          SizedBox(height: 6),
                          Text(
                              'Report dumping, schedule pickups, and climb the leaderboard by recycling.',
                              style: TextStyle(color: Colors.grey[700])),
                          SizedBox(height: 10),
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 4.0,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () =>
                                    Navigator.pushNamed(context, ReportPage.routeName),
                                icon: Icon(Icons.report_gmailerrorred),
                                label: Text('Report Dumping',
                                    style: TextStyle(color: Colors.white)),
                                style: ElevatedButton.styleFrom(
                                    minimumSize: Size(140, 40)),
                              ),
                              OutlinedButton.icon(
                                onPressed: () =>
                                    Navigator.pushNamed(context, SchedulePage.routeName),
                                icon: Icon(Icons.calendar_today_outlined),
                                label: Text('Schedule Pickup'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: primary,
                                  side: BorderSide(color: primary.withOpacity(0.18)),
                                  minimumSize: Size(140, 40),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 16),

              // Leaderboard
              Text('Leaderboard',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  child: _loadingLeaderboard
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : _leaderboard.isEmpty
                          ? Padding(
                              padding: EdgeInsets.all(16),
                              child: Text('No leaderboard data yet'),
                            )
                          : Column(
                              children: [
                                for (int i = 0; i < _leaderboard.length; i++) ...[
                                  _leaderRow(
                                    i + 1,
                                    _leaderboard[i]['username'] as String,
                                    _leaderboard[i]['points'] as int,
                                    [Colors.deepPurple, Colors.grey, Colors.orange][i],
                                  ),
                                  if (i < _leaderboard.length - 1) Divider(),
                                ],
                                SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () =>
                                        ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'These are the top scorers')),
                                    ),
                                    child: Text('📊'),
                                  ),
                                )
                              ],
                            ),
                ),
              ),
              SizedBox(height: 16),

              // Tips & Guides
              Text('Tips & Guides',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Waste Management Tips',
                          style: TextStyle(fontWeight: FontWeight.w700)),
                      SizedBox(height: 8),
                      Text(
                          'Sort wet and dry at source. Compost wet waste. Drop recyclables at nearby centers. Earn points for compliance.',
                          style: TextStyle(color: Colors.grey[700])),
                      SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const TrainingPage()),
                              );
                            },
                            child: const Text(
                              'Start Training',
                              style: TextStyle(
                                  color: Color.fromRGBO(255, 255, 255, 1.0)),
                            ),
                          ),
                          SizedBox(width: 12),
                          OutlinedButton.icon(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const NearestCentersPage()),
                            ),
                            icon: Icon(Icons.location_on_outlined),
                            label: Text('Nearest centers'),
                            style: OutlinedButton.styleFrom(
                                foregroundColor: primary),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _leaderRow(int rank, String name, int points, Color medalColor) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: medalColor,
          child: Text(rank.toString(),
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        SizedBox(width: 12),
        Expanded(
            child: Text(name, style: TextStyle(fontWeight: FontWeight.w600))),
        Text('$points pts',
            style: TextStyle(
                color: Colors.grey[700], fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class DashboardPage extends StatefulWidget {
  static const routeName = '/dashboard';

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    DashboardContent(),
    ScannerPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('G.One'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
              Navigator.pushReplacementNamed(context, LoginPage.routeName);
            },
          )
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_scanner), label: 'Scanner'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}