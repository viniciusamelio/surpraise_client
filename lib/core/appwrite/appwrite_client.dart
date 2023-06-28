import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

import '../../env.dart';

class AppWriteService {
  static final Client client = Client();

  Client get _client => AppWriteService.client;

  static Future<void> init() async {
    client
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject(Env.awProjectId)
        .setSelfSigned(
          status: true,
        );
  }

  Future<User> signUp({
    required String email,
    required String password,
    required String userId,
  }) async {
    final account = Account(_client);
    final result = await account.create(
      userId: userId,
      email: email,
      password: password,
    );
    await signIn(email: email, password: password);
    return result;
  }

  Future<String> signIn({
    required email,
    required password,
  }) async {
    final account = Account(_client);
    final result = await account.createEmailSession(
      email: email,
      password: password,
    );
    return result.userId;
  }

  Future<void> logout() async {
    final account = Account(_client);
    final sessions = await account.listSessions();
    if (sessions.sessions.isEmpty) {
      return;
    }
    await account.deleteSessions();
  }
}
