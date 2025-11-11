import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../service/retrofit/user_api.dart';
import 'dio_provider.dart';

final userApiProvider = Provider<UserApi>((ref) {
  final dio = ref.watch(dioProvider);
  return UserApi(dio);
});
