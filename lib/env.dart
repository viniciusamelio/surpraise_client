abstract class Env {
  static const String awProjectId = String.fromEnvironment("AW_PROJECT");
  static const String baseUrl = String.fromEnvironment("BASE_URL");
  static String sbUrl = const String.fromEnvironment("SB_URL");
  static const String sbKey = String.fromEnvironment("SB_KEY");
  static const String avatarBucket = String.fromEnvironment("AVATAR_BUCKET");
  static const String communitiesBucket =
      String.fromEnvironment("COMMUNITIES_BUCKET");
}
