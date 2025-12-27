import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trajectoria/core/config/env/env.dart';

Future<String> getAccessToken() async {
  try {
    // 1. Ambil Private Key dan perbaiki format newline
    String privateKeyString = Env.privateKey;
    if (privateKeyString.contains('\\n')) {
      privateKeyString = privateKeyString.replaceAll('\\n', '\n');
    }

    // 2. Buat JWT (JSON Web Token)
    final jwt = JWT({
      "iss": Env.clientEmail,
      "scope": "https://www.googleapis.com/auth/firebase.messaging",
      "aud": "https://oauth2.googleapis.com/token",
      "iat": (DateTime.now().millisecondsSinceEpoch / 1000).round(),
      "exp":
          (DateTime.now()
                      .add(const Duration(minutes: 60))
                      .millisecondsSinceEpoch /
                  1000)
              .round(),
    });

    // 3. Sign JWT menggunakan Private Key (RS256)
    final key = RSAPrivateKey(privateKeyString);
    final signedJwt = jwt.sign(key, algorithm: JWTAlgorithm.RS256);

    // 4. Tukar JWT dengan Google Access Token via HTTP Post
    final response = await http.post(
      Uri.parse('https://oauth2.googleapis.com/token'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'grant_type': 'urn:ietf:params:oauth:grant-type:jwt-bearer',
        'assertion': signedJwt,
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['access_token'];
    } else {
      throw Exception('Gagal mendapatkan token: ${response.body}');
    }
  } catch (e) {
    throw Exception('Error AccessTokenService: $e');
  }
}

Future<void> sendDirectNotification(
  BuildContext context,
  String targetUserToken,
  String competitionName,
  String competitionId,
  String submissionId,
  String announcementId,
) async {
  try {
    // 1. Ambil Token OAuth (Otomatis generate baru)
    final String accessToken = await getAccessToken();

    // 2. URL FCM v1 (Sesuai request Anda)
    const String projectId = 'trajectoria-9023f';
    const String fcmUrl =
        'https://fcm.googleapis.com/v1/projects/$projectId/messages:send';
    String message =
        "Halo, ada pengumuman nih dari kompetisi $competitionName.";

    // 3. Payload Body
    final Map<String, dynamic> body = {
      "message": {
        "token": targetUserToken,
        "notification": {"title": "Update Lamaran", "body": message},
        // Data untuk Navigasi
        "data": {
          "type": "report_submission",
          "competition_id": competitionId,
          "submission_id": submissionId,
          "announcement_id": announcementId,
          "full_body": message,
        },
        "android": {
          "priority": "high",
          "notification": {
            "channel_id": "high_importance_channel",
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
            "icon": "ic_launcher",
          },
        },
      },
    };

    // 4. Kirim Request HTTP POST
    final response = await http.post(
      Uri.parse(fcmUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      debugPrint("Sukses kirim notif: ${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Notifikasi Terkirim ke User A!")),
      );
    } else {
      debugPrint("Gagal kirim: ${response.body}");
      throw Exception("Error FCM: ${response.statusCode}");
    }
  } catch (e) {
    debugPrint("Error: $e");
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Gagal: $e")));
  }
}
