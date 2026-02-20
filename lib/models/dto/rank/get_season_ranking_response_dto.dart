class SeasonRankingItem {
  final int userId;
  final int totalMillis;
  final int rank;
  final String username;
  final String imageUrl;
  final String department;

  SeasonRankingItem({
    required this.userId,
    required this.totalMillis,
    required this.rank,
    required this.username,
    required this.imageUrl,
    required this.department,
  });

  factory SeasonRankingItem.fromJson(Map<String, dynamic> json) =>
      SeasonRankingItem(
        userId: json['userId'] as int,
        totalMillis: json['totalMillis'] as int,
        rank: json['rank'] as int,
        username: json['username'] as String? ?? '',
        imageUrl: json['imageUrl'] as String? ?? '',
        department: json['department'] as String? ?? '',
      );
}

class SeasonRankingData {
  final int seasonId;
  final String seasonName;
  final String startDate;
  final String endDate;
  final List<SeasonRankingItem> rankings;

  SeasonRankingData({
    required this.seasonId,
    required this.seasonName,
    required this.startDate,
    required this.endDate,
    required this.rankings,
  });

  factory SeasonRankingData.fromJson(Map<String, dynamic> json) =>
      SeasonRankingData(
        seasonId: json['seasonId'] as int,
        seasonName: json['seasonName'] as String? ?? '',
        startDate: json['startDate'] as String? ?? '',
        endDate: json['endDate'] as String? ?? '',
        rankings: (json['rankings'] as List<dynamic>? ?? [])
            .map((item) => SeasonRankingItem.fromJson(item))
            .toList(),
      );
}

class GetSeasonRankingResponseDto {
  final bool success;
  final SeasonRankingData data;
  final String? message;

  GetSeasonRankingResponseDto({
    required this.success,
    required this.data,
    this.message,
  });

  factory GetSeasonRankingResponseDto.fromJson(Map<String, dynamic> json) =>
      GetSeasonRankingResponseDto(
        success: json['success'] == 'true' || json['success'] == true,
        data: SeasonRankingData.fromJson(json['data']),
        message: json['message'] as String?,
      );
}
