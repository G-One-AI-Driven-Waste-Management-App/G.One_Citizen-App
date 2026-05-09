import 'dart:io';
import '../models/report.dart';
import '../services/api_service.dart';

class ReportRepository {
  /// Submit report — with or without photo — to the Spring Boot backend
  Future<void> submitReport(Report report) async {
    if (report.photoPath != null) {
      await ApiService.submitReportWithPhoto(
        description: report.description,
        latitude:    report.latitude,
        longitude:   report.longitude,
        photo:       File(report.photoPath!),
      );
    } else {
      await ApiService.submitReport(
        description: report.description,
        latitude:    report.latitude,
        longitude:   report.longitude,
      );
    }
  }

  /// Fetch all reports for the logged-in user from the backend
  Future<List<Report>> fetchReports() async {
    final list = await ApiService.getReports();
    return list.map((json) {
      final j = json as Map<String, dynamic>;
      return Report(
        id:          j['id']          as String,
        description: j['description'] as String,
        latitude:    (j['latitude']   as num).toDouble(),
        longitude:   (j['longitude']  as num).toDouble(),
        createdAt:   DateTime.parse(j['createdAt'] as String),
        photoPath:   j['photoPath']   as String?,
      );
    }).toList();
  }
}