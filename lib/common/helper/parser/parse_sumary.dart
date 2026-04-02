import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trajectoria/features/jobseeker/compete/data/models/insightAI.dart';

/// Parses a comprehensive InsightAI JSON object from Gemini response.
/// Expected structure:
/// {
///   "summary": [{"deskripsi": "..."}],
///   "common_pattern": [{"deskripsi": "..."}],
///   "strengths": [{"deskripsi": "..."}],
///   "weaknesses": [{"deskripsi": "..."}],
///   "improvement_suggestion": "...",
///   "career_match_recommendation": "..."
/// }
InsightAIModel parseInsightAI(String responseText) {
  try {
    final startIndex = responseText.indexOf('{');
    final endIndex = responseText.lastIndexOf('}');
    if (startIndex == -1 || endIndex == -1) {
      return InsightAIModel(commonPattern: [], summary: []);
    }
    final jsonString = responseText.substring(startIndex, endIndex + 1);
    final Map<String, dynamic> json = jsonDecode(jsonString);

    List<String> parseArray(dynamic val) {
      if (val == null) return [];
      if (val is List) {
        return val.map((e) {
          if (e is Map) return (e['deskripsi'] ?? e.values.first).toString();
          return e.toString();
        }).toList();
      }
      return [];
    }

    return InsightAIModel(
      summary: parseArray(json['summary']),
      commonPattern: parseArray(json['common_pattern']),
      strengths: parseArray(json['strengths']),
      weaknesses: parseArray(json['weaknesses']),
      improvementSuggestion: json['improvement_suggestion']?.toString() ?? '',
      careerMatchRecommendation:
          json['career_match_recommendation']?.toString() ?? '',
    );
  } catch (e) {
    debugPrint("Gagal parsing InsightAI JSON: $e");
    return InsightAIModel(commonPattern: [], summary: []);
  }
}

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
