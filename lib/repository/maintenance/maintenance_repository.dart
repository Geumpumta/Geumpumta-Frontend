import 'package:geumpumta/models/dto/maintenance/maintenance_status_response_dto.dart';
import 'package:geumpumta/service/retrofit/maintenance_api.dart';
import 'package:flutter/foundation.dart';

class MaintenanceRepository {
  final MaintenanceApi _api;

  MaintenanceRepository(this._api);

  Future<MaintenanceStatusData> getMaintenanceStatus() async {
    try {
      final response = await _api.getMaintenanceStatus();
      if (!response.success) {
        throw Exception('점검 상태 조회 실패');
      }
      return response.data;
    } catch (e, st) {
      debugPrint('[MaintenanceRepository] 오류 발생: $e\n$st');
      rethrow;
    }
  }
}
