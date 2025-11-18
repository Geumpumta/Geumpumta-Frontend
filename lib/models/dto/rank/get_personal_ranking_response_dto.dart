class PersonalRankingDataItem {
  final int userId;
  final int totalMillis;
  final int rank;
  final String? username;

  PersonalRankingDataItem({
    required this.userId,
    required this.totalMillis,
    required this.rank,
    this.username,
  });

  factory PersonalRankingDataItem.fromJson(Map<String, dynamic> json) =>
      PersonalRankingDataItem(
        userId: json['userId'] as int,
        totalMillis: json['totalMillis'] as int,
        rank: json['rank'] as int,
        username: json['username'],
      );
}

class PersonalRankingData {
  final List<PersonalRankingDataItem> topRanks;
  final PersonalRankingDataItem myRanking;

  PersonalRankingData({required this.topRanks, required this.myRanking});

  factory PersonalRankingData.fromJson(Map<String, dynamic> json) =>
      PersonalRankingData(
        topRanks: (json['topRanks'] as List<dynamic>)
            .map((item) => PersonalRankingDataItem.fromJson(item))
            .toList(),
        myRanking: PersonalRankingDataItem.fromJson(json['myRanking']),
      );
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

  factory GetPersonalRankingResponseDto.fromJson(Map<String, dynamic> json) =>
      GetPersonalRankingResponseDto(
        success: json['success'] == 'true' || json['success'] == true,
        data: PersonalRankingData.fromJson(json['data']),
        message: json['message'],
      );
}
