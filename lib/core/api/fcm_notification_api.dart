import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';

Future<void> sendDirectNotification(
  BuildContext context,
  String targetUserToken,
  String competitionName,
  String competitionId,
  String submissionId,
  String announcementId,
) async {
  try {
    final HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('sendFcmNotification');

    await callable.call(<String, dynamic>{
      'targetToken': targetUserToken,
      'competitionName': competitionName,
      'competitionId': competitionId,
      'submissionId': submissionId,
      'announcementId': announcementId,
    });

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Notifikasi Terkirim ke User!")),
      );
    }
  } catch (e) {
    debugPrint("Error kirim notifikasi: $e");
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal kirim notifikasi: $e")));
    }
  }
}
