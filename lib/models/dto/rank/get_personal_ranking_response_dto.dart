import 'package:geumpumta/models/department.dart';

class PersonalRankingDataItem {
  final int userId;
  final int totalMillis;
  final int rank;
  final String? username;
  final String imageUrl;
  final Department department;

  PersonalRankingDataItem({
    required this.userId,
    required this.totalMillis,
    required this.rank,
    this.username,
    required this.imageUrl,
    required this.department,
  });

  factory PersonalRankingDataItem.fromJson(Map<String, dynamic> json) {
    return PersonalRankingDataItem(
      userId: _parseInt(json['userId']),
      totalMillis: _parseInt(json['totalMillis']),
      rank: _parseInt(json['rank']),
      username: json['username']?.toString(),
      imageUrl: json['imageUrl']?.toString() ?? '',
      department: DepartmentParser.fromKorean(json['department']?.toString()),
    );
  }

  static int _parseInt(dynamic value) {
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

class PersonalRankingData {
  final List<PersonalRankingDataItem> topRanks;
  final PersonalRankingDataItem? myRanking;

  PersonalRankingData({required this.topRanks, required this.myRanking});

  factory PersonalRankingData.fromJson(Map<String, dynamic> json) {
    final topRanksRaw = json['topRanks'] as List<dynamic>? ?? const [];
    final topRanks = topRanksRaw
        .whereType<Map<String, dynamic>>()
        .map(PersonalRankingDataItem.fromJson)
        .toList();

    final myRankingRaw = json['myRanking'];
    final myRanking =
        myRankingRaw is Map<String, dynamic>
            ? PersonalRankingDataItem.fromJson(myRankingRaw)
            : null;

    return PersonalRankingData(topRanks: topRanks, myRanking: myRanking);
  }
}

class GetPersonalRankingResponseDto {
  final bool success;
  final PersonalRankingData data;
  final String? message;

  GetPersonalRankingResponseDto({
    required this.success,
    required this.data,
    this.message,
  });

  factory GetPersonalRankingResponseDto.fromJson(Map<String, dynamic> json) {
    return GetPersonalRankingResponseDto(
      success: json['success'] == 'true' || json['success'] == true,
      data: PersonalRankingData.fromJson(
        json['data'] as Map<String, dynamic>? ?? const <String, dynamic>{},
      ),
      message: json['message']?.toString(),
    );
  }
}
