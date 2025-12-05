import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/notification_model.dart';
import '../services/notification_service.dart';

final notificationServiceProvider = Provider<NotificationService>(
  (ref) => NotificationService(),
);

final notificationsProvider = FutureProvider<List<NotificationModel>>((
  ref,
) async {
  final notificationService = ref.watch(notificationServiceProvider);
  return await notificationService.getAllNotifications();
});

final unreadCountProvider = FutureProvider<int>((ref) async {
  final notificationService = ref.watch(notificationServiceProvider);
  return await notificationService.getUnreadCount();
});
