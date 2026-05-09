import '../models/pickup_schedule.dart';
import '../services/api_service.dart';

class PickupRepository {
  PickupRepository._internal();
  static final PickupRepository _instance = PickupRepository._internal();
  factory PickupRepository() => _instance;
  static PickupRepository get instance => _instance;

  /// Get all pickups for the logged-in user from the backend
  Future<List<PickupSchedule>> getSchedules() async {
    final list = await ApiService.getPickups();
    return list.map((json) {
      final j = json as Map<String, dynamic>;
      return PickupSchedule(
        id:         j['id']         as String,
        centerName: j['centerName'] as String,
        pickupDate: DateTime.parse(j['pickupDate'] as String),
        status:     (j['status']    as String?) ?? 'Scheduled',
      );
    }).toList();
  }

  /// Book a new pickup on the backend
  Future<void> addSchedule(PickupSchedule schedule) async {
    await ApiService.bookPickup(
      centerName: schedule.centerName,
      pickupDate: schedule.pickupDate,
    );
  }

  /// Cancel a pickup — sends PATCH /api/pickups/{id}/status with Cancelled
  Future<void> removeSchedule(String id) async {
    await ApiService.updatePickupStatus(pickupId: id, status: 'Cancelled');
  }

  /// Mark a pickup as completed — sends PATCH /api/pickups/{id}/status
  Future<void> markCompleted(String id) async {
    await ApiService.updatePickupStatus(pickupId: id, status: 'Completed');
  }
}
