import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'GEMINI_API_KEY', obfuscate: true)
  static final String geminiApiKey = _Env.geminiApiKey;

  @EnviedField(varName: 'SA_TYPE', obfuscate: true)
  static final String type = _Env.type;

  @EnviedField(varName: 'SA_PROJECT_ID', obfuscate: true)
  static final String projectId = _Env.projectId;

  @EnviedField(varName: 'SA_PRIVATE_KEY_ID', obfuscate: true)
  static final String privateKeyId = _Env.privateKeyId;

  @EnviedField(varName: 'SA_PRIVATE_KEY', obfuscate: true)
  static final String privateKey = _Env.privateKey;

  @EnviedField(varName: 'SA_CLIENT_EMAIL', obfuscate: true)
  static final String clientEmail = _Env.clientEmail;

  @EnviedField(varName: 'SA_CLIENT_ID', obfuscate: true)
  static final String clientId = _Env.clientId;

  @EnviedField(varName: 'SA_AUTH_URI', obfuscate: true)
  static final String authUri = _Env.authUri;

  @EnviedField(varName: 'SA_TOKEN_URI', obfuscate: true)
  static final String tokenUri = _Env.tokenUri;

  @EnviedField(varName: 'SA_AUTH_PROVIDER_CERT_URL', obfuscate: true)
  static final String authProviderCertUrl = _Env.authProviderCertUrl;

  @EnviedField(varName: 'SA_CLIENT_CERT_URL', obfuscate: true)
  static final String clientCertUrl = _Env.clientCertUrl;

  @EnviedField(varName: 'SA_UNIVERSE_DOMAIN', obfuscate: true)
  static final String universeDomain = _Env.universeDomain;
}
