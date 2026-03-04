class MaintenanceStatusData {
  final String status;
  final String? message;

  const MaintenanceStatusData({required this.status, this.message});

  bool get isMaintenance => status.toUpperCase() != 'NORMAL';

  factory MaintenanceStatusData.fromJson(Map<String, dynamic> json) {
    return MaintenanceStatusData(
      status: (json['status'] as String?) ?? 'NORMAL',
      message: json['message'] as String?,
    );
  }
}

class MaintenanceStatusResponseDto {
  final bool success;
  final MaintenanceStatusData data;

  const MaintenanceStatusResponseDto({
    required this.success,
    required this.data,
  });

  factory MaintenanceStatusResponseDto.fromJson(Map<String, dynamic> json) {
    return MaintenanceStatusResponseDto(
      success: json['success'] == true || json['success'] == 'true',
      data: MaintenanceStatusData.fromJson(
        (json['data'] as Map<String, dynamic>?) ?? <String, dynamic>{},
      ),
    );
  }
}
