import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import 'dashboard_page.dart';
 
class LoginPage extends StatefulWidget {
  static const routeName = '/login';
  @override
  _LoginPageState createState() => _LoginPageState();
}
 
class _LoginPageState extends State<LoginPage> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();
 
  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }
 
  void _onLoginPressed() {
    final username = _userController.text.trim();
    final pass = _passController.text.trim();
    if (username.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please enter credentials')));
      return;
    }
    context.read<AuthBloc>().add(LoginRequested(username, pass));
  }
 
  // ── NEW: Register dialog ─────────────────────────────────────────────────
  void _showRegisterDialog(BuildContext context) {
    final userCtrl  = TextEditingController();
    final passCtrl  = TextEditingController();
    final emailCtrl = TextEditingController();
    final primary   = Theme.of(context).colorScheme.primary;
 
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.person_add, color: primary),
            SizedBox(width: 8),
            Text('Create Account',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                SizedBox(height: 8),
                          Text(' (Minimum 6 digit password)',
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 13),
                              textAlign: TextAlign.center),
                          SizedBox(height: 18),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: userCtrl,
              decoration: InputDecoration(
                labelText: 'Username',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: emailCtrl,
              decoration: InputDecoration(
                labelText: 'Email (optional)',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 10),
            TextField(
              controller: passCtrl,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final u = userCtrl.text.trim();
              final p = passCtrl.text.trim();
              if (u.isEmpty || p.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Username and password are required')));
                return;
              }
              Navigator.pop(context);
              context.read<AuthBloc>().add(RegisterRequested(
                username: u,
                password: p,
                email: emailCtrl.text.trim(),
              ));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('Register',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
  // ────────────────────────────────────────────────────────────────────────
 
  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.pushReplacementNamed(context, DashboardPage.routeName);
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
 
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 8)
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: primary,
                          child: Icon(Icons.eco, color: Colors.white, size: 28),
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('G.One',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700)),
                            Text('Waste Management',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[700])),
                          ],
                        )
                      ],
                    ),
                  ),
 
                  SizedBox(height: 28),
 
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    child: Padding(
                      padding: const EdgeInsets.all(22.0),
                      child: Column(
                        children: [
                          Text('Welcome',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text('Sign in to manage waste',
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 13),
                              textAlign: TextAlign.center),
                          SizedBox(height: 18),
 
                          // ── Username field ──────────────────────────────
                          TextField(
                            controller: _userController,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                          SizedBox(height: 12),
 
                          // ── Password field ──────────────────────────────
                          TextField(
                            controller: _passController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            obscureText: true,
                          ),
                          SizedBox(height: 18),
 
                          // ── LOGIN button ────────────────────────────────
                          BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              final loading = state is AuthLoading;
                              return SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed:
                                      loading ? null : _onLoginPressed,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12.0),
                                    child: loading
                                        ? SizedBox(
                                            height: 18,
                                            width: 18,
                                            child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2))
                                        : Text('LOGIN',
                                            style: TextStyle(
                                                color: Colors.white)),
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 10),
 
                          // ── Forgot password ─────────────────────────────
                          TextButton(
                            onPressed: () => ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                                    content:
                                        Text('Please Register Again'))),
                            child: Text('Forgot password?',
                                style: TextStyle(color: primary)),
                          ),
 
                          // ── NEW: Register button ────────────────────────
                          Divider(height: 20, thickness: 0.8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Don't have an account?",
                                  style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 13)),
                              TextButton(
                                onPressed: () =>
                                    _showRegisterDialog(context),
                                child: Text('Register here',
                                    style: TextStyle(
                                        color: primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13)),
                              ),
                            ],
                          ),
                          // ───────────────────────────────────────────────
 
                        ],
                      ),
                    ),
                  ),
 
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
 
