import 'package:geumpumta/models/department.dart';

class DepartmentRankingDataItem {
  final Department departmentName;
  final int totalMillis;
  final int rank;

  DepartmentRankingDataItem({
    required this.departmentName,
    required this.totalMillis,
    required this.rank,
  });

  factory DepartmentRankingDataItem.fromJson(Map<String, dynamic> json) {
    return DepartmentRankingDataItem(
      departmentName: DepartmentParser.fromKorean(
        json['departmentName']?.toString() ?? json['department']?.toString(),
      ),
      totalMillis: _parseInt(json['totalMillis']),
      rank: _parseInt(json['rank']),
    );
  }

  static int _parseInt(dynamic value) {
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

class DepartmentRankingData {
  final List<DepartmentRankingDataItem> topRanks;
  final DepartmentRankingDataItem? myDepartmentRanking;

  DepartmentRankingData({
    required this.topRanks,
    required this.myDepartmentRanking,
  });

  factory DepartmentRankingData.fromJson(Map<String, dynamic> json) {
    final topRanksRaw = json['topRanks'] as List<dynamic>? ?? const [];
    final topRanks = topRanksRaw
        .whereType<Map<String, dynamic>>()
        .map(DepartmentRankingDataItem.fromJson)
        .toList();

    final myDepartmentRankingRaw = json['myDepartmentRanking'];
    final myDepartmentRanking =
        myDepartmentRankingRaw is Map<String, dynamic>
            ? DepartmentRankingDataItem.fromJson(myDepartmentRankingRaw)
            : null;

    return DepartmentRankingData(
      topRanks: topRanks,
      myDepartmentRanking: myDepartmentRanking,
    );
  }
}

class GetDepartmentRankingResponseDto {
  final bool success;
  final DepartmentRankingData data;
  final String? message;

  GetDepartmentRankingResponseDto({
    required this.success,
    required this.data,
    this.message,
  });

  factory GetDepartmentRankingResponseDto.fromJson(Map<String, dynamic> json) {
    return GetDepartmentRankingResponseDto(
      success: json['success'] == 'true' || json['success'] == true,
      data: DepartmentRankingData.fromJson(
        json['data'] as Map<String, dynamic>? ?? const <String, dynamic>{},
      ),
      message: json['message']?.toString(),
    );
  }
}
