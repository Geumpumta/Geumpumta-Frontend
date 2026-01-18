import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:geumpumta/models/department.dart';
import 'package:geumpumta/models/dto/common/common_dto.dart';
import 'package:geumpumta/models/dto/user/complete_registration_request_dto.dart';
import 'package:geumpumta/repository/auth/auth_repository.dart';

import '../../models/dto/user/complete_registration_response_dto.dart';
import '../../models/entity/user/user.dart';
import '../../service/retrofit/user_api.dart';

class UserRepository {
  final UserApi _api;
  final AuthRepository _authRepository;

  UserRepository(this._api, this._authRepository);

  Future<User> getUserProfile() async {
    try {
      final response = await _api.getUserProfile();
      final dto = response.data;

      return User(
        name: dto.name,
        nickName: dto.nickName,
        email: dto.email,
        schoolEmail: dto.schoolEmail,
        userRole: dto.userRole,
        profileImage: dto.profilePictureUrl,
        oAuthProvider: dto.OAuthProvider,
        studentId: dto.studentId,
        department: DepartmentParser.fromKorean(dto.department),
      );
    } on DioException catch (e) {
      // 회원탈퇴 관련 에러 코드 확인
      final data = e.response?.data;
      final errorCode = data?['code'];
      if (errorCode != null) {
        throw UserProfileException(
          code: errorCode,
          message: data?['message'] ?? '사용자 정보를 불러올 수 없습니다.',
        );
      }
      rethrow;
    } catch (e, st) {
      rethrow;
    }
  }

  Future<CompleteRegistrationResponseDto> completeRegistration(
    String email,
    String studentId,
    String department,
  ) async {
    try {
      final response = await _api.completeRegistration(
        CompleteRegistrationRequestDto(
          email: email,
          studentId: studentId,
          department: department,
        ),
      );

      _authRepository.updateTokens(
        response.data?.accessToken ?? '',
        response.data?.refreshToken ?? '',
      );
      return response;
    } on DioException catch (e) {
      final data = e.response?.data;
      return CompleteRegistrationResponseDto(
        success: false,
        data: null,
        code: data?['code'],
        msg: data?['msg'],
      );
    }
  }

  Future<CommonDto> withdrawUser() async {
    try {
      debugPrint('withdrawUser API 호출 시작');
      final response = await _api.withdrawUser();
      debugPrint('withdrawUser API 응답: success=${response.success}, message=${response.message}');
      return response;
    } on DioException catch (e) {
      debugPrint('withdrawUser DioException 발생: ${e.response?.statusCode}');
      debugPrint('응답 데이터: ${e.response?.data}');
      final data = e.response?.data;
      // 에러 응답도 CommonDto로 파싱 시도
      if (data != null && data is Map<String, dynamic>) {
        try {
          return CommonDto.fromJson(data);
        } catch (_) {
          // 파싱 실패 시 기본 에러 메시지
        }
      }
      return CommonDto(
        success: false,
        message: data?['message'] ?? data?['msg'] ?? '회원탈퇴 중 오류가 발생했습니다.',
      );
    } catch (e, stackTrace) {
      debugPrint('withdrawUser 예외 발생: $e');
      debugPrint('스택 트레이스: $stackTrace');
      return CommonDto(
        success: false,
        message: '회원탈퇴 중 오류가 발생했습니다: $e',
      );
    }
  }

  Future<CompleteRegistrationResponseDto> restoreUser() async {
    try {
      debugPrint('restoreUser API 호출 시작');
      final response = await _api.restoreUser();
      debugPrint('restoreUser API 응답 받음: success=${response.success}');
      
      // 성공 시 토큰 업데이트
      if (response.success && response.data != null) {
        debugPrint('토큰 업데이트 시작');
        _authRepository.updateTokens(
          response.data!.accessToken,
          response.data!.refreshToken,
        );
        debugPrint('토큰 업데이트 완료');
      }
      
      return response;
    } on DioException catch (e) {
      debugPrint('restoreUser DioException 발생: ${e.response?.statusCode}');
      debugPrint('응답 데이터: ${e.response?.data}');
      final data = e.response?.data;
      return CompleteRegistrationResponseDto(
        success: false,
        data: null,
        code: data?['code'],
        msg: data?['message'] ?? data?['msg'] ?? '계정 복구 중 오류가 발생했습니다.',
      );
    } catch (e, stackTrace) {
      debugPrint('restoreUser 예외 발생: $e');
      debugPrint('스택 트레이스: $stackTrace');
      return CompleteRegistrationResponseDto(
        success: false,
        data: null,
        code: null,
        msg: '계정 복구 중 오류가 발생했습니다: $e',
      );
    }
  }
}

class UserProfileException implements Exception {
  final String code;
  final String message;

  UserProfileException({required this.code, required this.message});

  @override
  String toString() => message;
}
