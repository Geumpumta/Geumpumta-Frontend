import 'package:dio/dio.dart';
import 'package:geumpumta/models/dto/maintenance/maintenance_status_response_dto.dart';
import 'package:retrofit/retrofit.dart';

part 'maintenance_api.g.dart';

@RestApi()
abstract class MaintenanceApi {
  factory MaintenanceApi(Dio dio, {String baseUrl}) = _MaintenanceApi;

  @GET('/api/v1/maintenance/status')
  Future<MaintenanceStatusResponseDto> getMaintenanceStatus();
}
