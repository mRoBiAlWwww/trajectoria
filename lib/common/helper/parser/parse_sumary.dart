import 'dart:convert';

import 'package:flutter/material.dart';

List<String> parseSummary(String responseText) {
  try {
    // 1. Cari posisi kurung siku pembuka '[' pertama
    int startIndex = responseText.indexOf('[');

    // 2. Cari posisi kurung siku penutup ']' terakhir
    int endIndex = responseText.lastIndexOf(']');

    // Jika tidak ditemukan array valid, return kosong
    if (startIndex == -1 || endIndex == -1) {
      return [];
    }

    // 3. POTONG string hanya mengambil dari '[' sampai ']'
    // Ini otomatis membuang teks "Tentu berikut...", "```json", dll.
    String jsonString = responseText.substring(startIndex, endIndex + 1);

    // 4. Decode JSON menjadi List object
    List<dynamic> jsonList = jsonDecode(jsonString);

    // 5. Ambil hanya value dari key "deskripsi"
    // Hasilnya adalah List<String> di mana setiap string berdiri sendiri
    List<String> descriptions = jsonList.map((item) {
      return item['deskripsi'].toString();
    }).toList();

    return descriptions;
  } catch (e) {
    debugPrint("Gagal parsing JSON: $e");
    return [];
  }
}
