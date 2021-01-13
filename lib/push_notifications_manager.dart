import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationsManager {
  String _token;
  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance =
      PushNotificationsManager._();

  String get token {
    return _token;
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;

  Future<void> init() async {
    if (!_initialized) {
      // For iOS request permission first.
      _firebaseMessaging.requestNotificationPermissions();
      //_firebaseMessaging.configure();
      _firebaseMessaging.configure(onMessage: (msg) {
        print(msg);
        return;
      }, onLaunch: (msg) {
        print(msg);
        return;
      }, onResume: (msg) {
        print(msg);
        return;
      });
      _firebaseMessaging.subscribeToTopic('chat');

      // For testing purposes print the Firebase Messaging token
      _token = await _firebaseMessaging.getToken();
      print('token is : $_token');
      _initialized = true;
    }
  }
}
