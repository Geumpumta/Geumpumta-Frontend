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

  factory DepartmentRankingDataItem.fromJson(Map<String, dynamic> json) =>
      DepartmentRankingDataItem(
        departmentName: DepartmentParser.fromKorean(json['department']),
        totalMillis: json['totalMillis'] as int,
        rank: json['rank'] as int,
      );
}

class DepartmentRankingData {
  final List<DepartmentRankingDataItem> topRanks;
  final DepartmentRankingDataItem myDepartmentRanking;

  DepartmentRankingData({
    required this.topRanks,
    required this.myDepartmentRanking,
  });

  factory DepartmentRankingData.fromJson(Map<String, dynamic> json) =>
      DepartmentRankingData(
        topRanks: (json['topRanks'] as List<dynamic>)
            .map((item) => DepartmentRankingDataItem.fromJson(item))
            .toList(),
        myDepartmentRanking:
        DepartmentRankingDataItem.fromJson(json['myDepartmentRanking']),
      );
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

  factory GetDepartmentRankingResponseDto.fromJson(Map<String, dynamic> json) =>
      GetDepartmentRankingResponseDto(
        success: json['success'] == 'true' || json['success'] == true,
        data: DepartmentRankingData.fromJson(json['data']),
        message: json['message'],
      );
}
