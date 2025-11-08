import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../service/dio_client.dart';

final dioProvider = Provider<Dio>((ref) => createDioClient());
