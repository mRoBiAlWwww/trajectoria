import 'package:envied/envied.dart';

part 'env.g.dart';

// All secrets have been migrated to Firebase Cloud Functions.
// This file is retained for any future client-side config needs.
@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'GEMINI_API_KEY', obfuscate: true)
  static final String geminiApiKey = _Env.geminiApiKey;
}
