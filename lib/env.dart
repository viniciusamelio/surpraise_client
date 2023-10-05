abstract class Env {
  static const String oneSignalAppId = String.fromEnvironment("ONE_SIGNAL_ID");
  static const String notificatorUrl =
      String.fromEnvironment("NOTIFICATOR_URL");
  static const String awProjectId = String.fromEnvironment("AW_PROJECT");
  static const String baseUrl = String.fromEnvironment("BASE_URL");
  static String sbUrl = const String.fromEnvironment("SB_URL");
  static const String sbKey = String.fromEnvironment("SB_KEY");
  static const String avatarBucket = String.fromEnvironment("AVATAR_BUCKET");
  static const String communitiesBucket =
      String.fromEnvironment("COMMUNITIES_BUCKET");
}
