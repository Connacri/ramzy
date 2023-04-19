// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:firebase_messaging/firebase_messaging.dart';
//
// Future<String?> getFcmToken() async {
//   if (Platform.isIOS) {
//     String? fcmKey = await FirebaseMessaging.instance.getToken();
//     return fcmKey;
//   }
//   // NotificationSettings settings =
//   //     await FirebaseMessaging.instance.requestPermission(
//   //   alert: true,
//   //   announcement: false,
//   //   badge: true,
//   //   carPlay: false,
//   //   criticalAlert: false,
//   //   provisional: false,
//   //   sound: true,
//   // );
//   // if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//   //   print('User granted permission');
//   // } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
//   //   print('User granted provisional permission');
//   // } else {
//   //   print('User declined or has not accepted permission');
//   // }
//   String? fcmKey = await FirebaseMessaging.instance.getToken();
//   return fcmKey;
// }
//
// Future<void> sendNotification(String token, String title, String body) async {
//   var url = Uri.parse('https://fcm.googleapis.com/fcm/send');
//   var headers = {
//     'Content-Type': 'application/json',
//     'Authorization':
//         'key=<AAAA_qha6Ys:APA91bHh68pCpFLaHB4yFkC1AQVzD3s_oofX38k2ynSkqLuh2w_RnJ9P2wp8K8xJ2E0rBRXXSZcxO2cfgsktQnRQbTwLvD_wjRmh64gHMHLPrq8MC42kyY-Vn7_7Z2SbyYs66A4eNIjI>'
//   };
//   var payload = {
//     'notification': {'title': title, 'body': body},
//     'to': token
//   };
//   var response =
//       await http.post(url, headers: headers, body: jsonEncode(payload));
//   if (response.statusCode == 200) {
//     print('Notification sent successfully');
//   } else {
//     print('Failed to send notification: ${response.statusCode}');
//   }
// }
