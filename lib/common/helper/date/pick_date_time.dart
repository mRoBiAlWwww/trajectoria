import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<Timestamp?> pickDateTime(BuildContext context) async {
  // Pilih tanggal
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
    initialDate: DateTime.now(),
  );

  if (pickedDate == null) return null;

  // Pilih jam
  final TimeOfDay? pickedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );

  if (pickedTime == null) return null;

  // Gabungkan date + time
  final combined = DateTime(
    pickedDate.year,
    pickedDate.month,
    pickedDate.day,
    pickedTime.hour,
    pickedTime.minute,
  );

  // Convert jadi Timestamp
  return Timestamp.fromDate(combined);
}
