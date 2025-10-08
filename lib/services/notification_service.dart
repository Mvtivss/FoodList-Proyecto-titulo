import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_application_1/domain/entities/kitchen_ingredient.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  // Inicializar el servicio de notificaciones
  Future<void> initialize() async {
    if (_initialized) return;

    // Inicializar timezone
    tzdata.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('America/Santiago'));

    // Configuración para Android
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // Configuración para iOS
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    await _requestPermissions();
    _initialized = true;
  }

  Future<bool> _requestPermissions() async {
    if (await Permission.notification.isDenied) {
      final status = await Permission.notification.request();
      if (!status.isGranted) return false;
    }

    // Solo para Android 12+
    if (await Permission.scheduleExactAlarm.isDenied) {
      await Permission.scheduleExactAlarm.request();
    }

    return true;
  }

  void _onNotificationTapped(NotificationResponse response) {
    print('Notificación tocada: ${response.payload}');
  }

  // ==================== NOTIFICACIONES DE COMIDAS ====================
  
  Future<void> scheduleMealNotification({
    required int id,
    required String mealType,
    required String mealName,
    required String day,
    required String time,
  }) async {
    try {
      final timeParts = time.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      final now = DateTime.now();
      int targetWeekday = _getDayNumber(day);

      DateTime scheduledDate = DateTime(
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );

      int daysToAdd = (targetWeekday - now.weekday + 7) % 7;
      if (daysToAdd == 0 && scheduledDate.isBefore(now)) {
        daysToAdd = 7;
      }
      scheduledDate = scheduledDate.add(Duration(days: daysToAdd));

      final scheduledTz = tz.TZDateTime.from(scheduledDate, tz.local);

      final androidDetails = AndroidNotificationDetails(
        'meal_reminders',
        'Recordatorios de Comidas',
        channelDescription: 'Notificaciones para recordar las comidas programadas',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        enableVibration: true,
        playSound: true,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      final notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.zonedSchedule(
        id,
        '${_getMealEmoji(mealType)} ${_getMealTitle(mealType)}',
        'Es hora de: $mealName',
        scheduledTz,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    } catch (e) {
      print('Error al programar notificación de comida: $e');
    }
  }

  // ==================== NOTIFICACIONES DE ALIMENTOS POR VENCER ====================

  /// Verificar alimentos y programar notificaciones
  Future<void> checkExpiringIngredients(List<KitchenIngredient> ingredients) async {
    await cancelExpiringNotifications();

    for (var ingredient in ingredients) {
      if (ingredient.expirationDate == null) continue;

      final daysUntilExpiration = 
          ingredient.expirationDate!.difference(DateTime.now()).inDays;

      // Notificar si vence en 3 días
      if (daysUntilExpiration == 3) {
        await _scheduleExpiringNotification(
          ingredient: ingredient,
          daysLeft: 3,
        );
      }

      // Notificar si vence mañana
      if (daysUntilExpiration == 1) {
        await _scheduleExpiringNotification(
          ingredient: ingredient,
          daysLeft: 1,
        );
      }

      // Notificar si vence hoy
      if (daysUntilExpiration == 0) {
        await showExpiringTodayNotification(ingredient);
      }

      // Notificar si ya venció
      if (daysUntilExpiration < 0) {
        await showExpiredNotification(ingredient);
      }
    }
  }

  Future<void> _scheduleExpiringNotification({
    required KitchenIngredient ingredient,
    required int daysLeft,
  }) async {
    final id = _generateExpiringId(ingredient.name, daysLeft);
    
    // Programar para las 9 AM
    final now = DateTime.now();
    DateTime scheduledDate = DateTime(now.year, now.month, now.day, 9, 0);
    
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    final scheduledTz = tz.TZDateTime.from(scheduledDate, tz.local);

    final androidDetails = AndroidNotificationDetails(
      'expiring_food',
      'Alimentos por Vencer',
      channelDescription: 'Alertas sobre alimentos próximos a vencer',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      enableVibration: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final title = daysLeft == 1
        ? '⚠️ Alimento vence mañana'
        : '⏰ Alimento vence en $daysLeft días';

    await _notifications.zonedSchedule(
      id,
      title,
      '${ingredient.name} (${ingredient.location}) - Úsalo pronto',
      scheduledTz,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      
    );
  }

  /// Mostrar notificación inmediata para alimento que vence hoy
  Future<void> showExpiringTodayNotification(KitchenIngredient ingredient) async {
    final id = _generateExpiringId(ingredient.name, 0);

    const androidDetails = AndroidNotificationDetails(
      'expiring_today',
      'Vencen Hoy',
      channelDescription: 'Alimentos que vencen hoy',
      importance: Importance.max,
      priority: Priority.max,
      icon: '@mipmap/ic_launcher',
      enableVibration: true,
      playSound: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      id,
      '🚨 ¡Alimento vence HOY!',
      '${ingredient.name} (${ingredient.location}) - Úsalo hoy',
      notificationDetails,
    );
  }

  /// Mostrar notificación para alimento vencido
  Future<void> showExpiredNotification(KitchenIngredient ingredient) async {
    final id = _generateExpiringId(ingredient.name, -1);

    const androidDetails = AndroidNotificationDetails(
      'expired_food',
      'Alimentos Vencidos',
      channelDescription: 'Alimentos que ya vencieron',
      importance: Importance.max,
      priority: Priority.max,
      icon: '@mipmap/ic_launcher',
      enableVibration: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      id,
      '❌ Alimento vencido',
      '${ingredient.name} (${ingredient.location}) - Retíralo de tu despensa',
      notificationDetails,
    );
  }

  // ==================== NOTIFICACIÓN INMEDIATA ====================

  Future<void> showImmediateNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'general_notifications',
      'Notificaciones Generales',
      channelDescription: 'Notificaciones de la aplicación',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(id, title, body, notificationDetails, payload: payload);
  }

  // ==================== GESTIÓN DE NOTIFICACIONES ====================

  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  Future<void> cancelExpiringNotifications() async {
    final pending = await _notifications.pendingNotificationRequests();
    for (var notification in pending) {
      // Cancelar solo notificaciones de alimentos (ID > 10000)
      if (notification.id >= 10000) {
        await _notifications.cancel(notification.id);
      }
    }
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  // ==================== HELPERS ====================

  int _getDayNumber(String day) {
    const days = {
      'Lunes': 1,
      'Martes': 2,
      'Miércoles': 3,
      'Jueves': 4,
      'Viernes': 5,
      'Sábado': 6,
      'Domingo': 7,
    };
    return days[day] ?? 1;
  }

  String _getMealEmoji(String mealType) {
    switch (mealType) {
      case 'Desayuno':
        return '☀️';
      case 'Almuerzo':
        return '🍽️';
      case 'Cena':
        return '🌙';
      case 'Snack':
        return '🍪';
      default:
        return '🍴';
    }
  }

  String _getMealTitle(String mealType) {
    switch (mealType) {
      case 'Desayuno':
        return 'Hora del Desayuno';
      case 'Almuerzo':
        return 'Hora del Almuerzo';
      case 'Cena':
        return 'Hora de la Cena';
      case 'Snack':
        return 'Hora del Snack';
      default:
        return 'Recordatorio de Comida';
    }
  }

  int _generateExpiringId(String ingredientName, int daysLeft) {
    // IDs >= 10000 para notificaciones de alimentos
    return 10000 + ingredientName.hashCode.abs() % 10000 + daysLeft;
  }

  static int generateNotificationId(String day, String mealType) {
    // IDs < 10000 para notificaciones de comidas
    final dayHash = day.hashCode.abs() % 100;
    final mealHash = mealType.hashCode.abs() % 100;
    return dayHash * 100 + mealHash;
  }
}