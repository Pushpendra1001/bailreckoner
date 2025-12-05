import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/notification_model.dart';
import 'package:uuid/uuid.dart';

class NotificationService {
  static const String _keyNotifications = 'notifications';

  Future<List<NotificationModel>> getAllNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final notificationsJson = prefs.getStringList(_keyNotifications) ?? [];
    return notificationsJson
        .map((json) => NotificationModel.fromJson(jsonDecode(json)))
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  Future<void> addNotification(NotificationModel notification) async {
    final prefs = await SharedPreferences.getInstance();
    final notifications = await getAllNotifications();
    notifications.insert(0, notification);
    final notificationsJson = notifications
        .map((n) => jsonEncode(n.toJson()))
        .toList();
    await prefs.setStringList(_keyNotifications, notificationsJson);
  }

  Future<void> markAsRead(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final notifications = await getAllNotifications();
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      final updated = NotificationModel(
        id: notifications[index].id,
        title: notifications[index].title,
        message: notifications[index].message,
        timestamp: notifications[index].timestamp,
        type: notifications[index].type,
        isRead: true,
      );
      notifications[index] = updated;
      final notificationsJson = notifications
          .map((n) => jsonEncode(n.toJson()))
          .toList();
      await prefs.setStringList(_keyNotifications, notificationsJson);
    }
  }

  Future<int> getUnreadCount() async {
    final notifications = await getAllNotifications();
    return notifications.where((n) => !n.isRead).length;
  }

  Future<void> createCaseNotification(String caseNumber, String status) async {
    String title = '';
    String message = '';

    switch (status) {
      case 'submitted':
        title = 'Application Submitted';
        message =
            'Your bail application for case $caseNumber has been submitted successfully.';
        break;
      case 'under_review':
        title = 'Under Review';
        message = 'Case $caseNumber is now under judicial review.';
        break;
      case 'approved':
        title = 'Bail Approved';
        message = 'Bail has been approved for case $caseNumber.';
        break;
      case 'rejected':
        title = 'Application Rejected';
        message = 'Bail application for case $caseNumber has been rejected.';
        break;
      default:
        title = 'Case Update';
        message = 'Status updated for case $caseNumber.';
    }

    final notification = NotificationModel(
      id: const Uuid().v4(),
      title: title,
      message: message,
      timestamp: DateTime.now(),
      type: status,
    );

    await addNotification(notification);
  }
}
