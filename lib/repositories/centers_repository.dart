import '../models/center.dart';
import '../services/api_service.dart';

class CentersRepository {
  CentersRepository._internal();
  static final CentersRepository _instance = CentersRepository._internal();
  factory CentersRepository() => _instance;
  static CentersRepository get instance => _instance;

  /// Fetch all active centers from the Spring Boot backend
  Future<List<CenterModel>> fetchCenters() async {
    final list = await ApiService.getCenters();
    return _mapList(list);
  }

  /// Fetch centers sorted by nearest GPS distance (server-side sort)
  Future<List<CenterModel>> fetchNearestCenters({
    required double lat,
    required double lng,
    int limit = 10,
  }) async {
    final list = await ApiService.getNearestCenters(
      lat: lat, lng: lng, limit: limit,
    );
    return _mapList(list);
  }

  Future<CenterModel?> getById(String id) async {
    final all = await fetchCenters();
    try {
      return all.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  List<CenterModel> _mapList(List<dynamic> list) {
    return list.map((json) {
      final j = json as Map<String, dynamic>;
      return CenterModel(
        id:        j['id']       as String,
        name:      j['name']     as String,
        type:      (j['type']    as String?) ?? 'General',
        address:   (j['address'] as String?) ?? '',
        latitude:  (j['latitude']  as num).toDouble(),
        longitude: (j['longitude'] as num).toDouble(),
        phone:     (j['phone']  as String?) ?? '',
      );
    }).toList();
  }
}
