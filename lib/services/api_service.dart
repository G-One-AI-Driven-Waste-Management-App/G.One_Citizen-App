import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'https://gonebackend-production.up.railway.app/api';

  static String? _token;
  static String? _userId;
  static String? _username;

  static String? get token => _token;
  static String? get userId => _userId;
  static String? get username => _username;
  static bool get isLoggedIn => _token != null;

  static const Map<String, String> _publicHeaders = {
    'Content-Type': 'application/json',
  };

  static Map<String, String> get _authHeaders => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $_token',
  };

  // ══════════════════════════════════════════════════════════════════════════
  // AUTH
  // ══════════════════════════════════════════════════════════════════════════

  static Future<void> register({
    required String username,
    required String password,
    String? email,
    String? phone,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: _publicHeaders,
      body: jsonEncode({
        'username': username,
        'password': password,
        if (email != null && email.isNotEmpty) 'email': email,
        if (phone != null && phone.isNotEmpty) 'phone': phone,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception(response.body);
    }
  }

  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: _publicHeaders,
      body: jsonEncode({'username': username, 'password': password}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      _token = data['token'] as String;
      _userId = data['userId'] as String;
      _username = data['username'] as String;
      return data;
    }
    throw Exception('Invalid username or password');
  }

  static void logout() {
    _token = null;
    _userId = null;
    _username = null;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // REPORTS
  // ══════════════════════════════════════════════════════════════════════════

  static Future<void> submitReport({
    required String description,
    required double latitude,
    required double longitude,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reports'),
      headers: _authHeaders,
      body: jsonEncode({
        'description': description,
        'latitude': latitude,
        'longitude': longitude,
      }),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to submit report: ${response.body}');
    }
  }

  static Future<void> submitReportWithPhoto({
    required String description,
    required double latitude,
    required double longitude,
    required File photo,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/reports/with-photo'),
    );
    request.headers['Authorization'] = 'Bearer $_token';
    request.fields['description'] = description;
    request.fields['latitude'] = latitude.toString();
    request.fields['longitude'] = longitude.toString();
    request.files.add(await http.MultipartFile.fromPath('photo', photo.path));
    final streamed = await request.send();

    // Accept both 200 and 201
    if (streamed.statusCode != 200 && streamed.statusCode != 201) {
      final body = await streamed.stream.bytesToString();
      throw Exception('Failed to submit report with photo: $body');
    }
  }

  static Future<List<dynamic>> getReports() async {
    final response = await http.get(
      Uri.parse('$baseUrl/reports'),
      headers: _authHeaders,
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    }
    throw Exception('Failed to fetch reports (${response.statusCode})');
  }

  /// Fetch reports for the logged-in user (for work history in profile)
  static Future<List<dynamic>> getUserReports() async {
    final response = await http.get(
      Uri.parse('$baseUrl/user/reports'),
      headers: _authHeaders,
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    }
    throw Exception('Failed to fetch user reports: ${response.body}');
  }

  // ══════════════════════════════════════════════════════════════════════════
  // WASTE CENTERS
  // ══════════════════════════════════════════════════════════════════════════

  static Future<List<dynamic>> getCenters() async {
    final response = await http.get(
      Uri.parse('$baseUrl/centers'),
      headers: _authHeaders,
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    }
    throw Exception('Failed to fetch centers (${response.statusCode})');
  }

  static Future<List<dynamic>> getNearestCenters({
    required double lat,
    required double lng,
    int limit = 10,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/centers/nearest?lat=$lat&lng=$lng&limit=$limit'),
      headers: _authHeaders,
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    }
    throw Exception('Failed to fetch nearest centers');
  }

  // ══════════════════════════════════════════════════════════════════════════
  // LEADERBOARD
  // ══════════════════════════════════════════════════════════════════════════

  static Future<List<dynamic>> getLeaderboard() async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/users'),
      headers: _authHeaders,
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    }
    throw Exception('Failed to fetch leaderboard');
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PICKUP SCHEDULES
  // ══════════════════════════════════════════════════════════════════════════

  static Future<List<dynamic>> getPickups() async {
    final response = await http.get(
      Uri.parse('$baseUrl/pickups'),
      headers: _authHeaders,
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    }
    throw Exception('Failed to fetch pickups (${response.statusCode})');
  }

  static Future<void> bookPickup({
    required String centerName,
    required DateTime pickupDate,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/pickups'),
      headers: _authHeaders,
      body: jsonEncode({
        'centerName': centerName,
        'pickupDate': pickupDate.toIso8601String(),
      }),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to book pickup: ${response.body}');
    }
  }

  static Future<void> updatePickupStatus({
    required String pickupId,
    required String status,
  }) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/pickups/$pickupId/status'),
      headers: _authHeaders,
      body: jsonEncode({'status': status}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update status: ${response.body}');
    }
  }

  static Future<void> deletePickup(String pickupId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/pickups/$pickupId'),
      headers: _authHeaders,
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete pickup: ${response.body}');
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PROFILE
  // ══════════════════════════════════════════════════════════════════════════

  static Future<Map<String, dynamic>> getProfile() async {
    final response = await http.get(
      Uri.parse('$baseUrl/profile'),
      headers: _authHeaders,
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to fetch profile (${response.statusCode})');
  }

  static Future<void> updateProfile({String? email, String? phone}) async {
    final body = <String, String>{};
    if (email != null) body['email'] = email;
    if (phone != null) body['phone'] = phone;
    final response = await http.put(
      Uri.parse('$baseUrl/profile'),
      headers: _authHeaders,
      body: jsonEncode(body),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update profile: ${response.body}');
    }
  }
}
