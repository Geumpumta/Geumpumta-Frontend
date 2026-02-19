import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../core/api/fcm_api.dart';
import '../../core/notifications/fcm_service.dart';
import '../../core/notifications/local_notification_service.dart';
import '../dio_provider.dart';

final flutterLocalNotificationsPluginProvider =
Provider<FlutterLocalNotificationsPlugin>((ref) {
  return FlutterLocalNotificationsPlugin();
});

final localNotificationServiceProvider = Provider<LocalNotificationService>((ref) {
  final plugin = ref.watch(flutterLocalNotificationsPluginProvider);
  return LocalNotificationService(plugin);
});

final fcmApiProvider = Provider<FcmApi>((ref) {
  final dio = ref.watch(dioProvider);
  return FcmApi(dio);
});

final fcmServiceProvider = Provider<FcmService>((ref) {
  return FcmService(
    fcmApi: ref.watch(fcmApiProvider),
    localNoti: ref.watch(localNotificationServiceProvider),
    ref: ref,
  );
});
