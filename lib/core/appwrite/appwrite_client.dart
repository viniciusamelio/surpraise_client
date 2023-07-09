import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' hide File;

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

  Future<String> uploadImage({
    required String bucketId,
    required String fileId,
    required File fileToSave,
  }) async {
    try {
      final storage = Storage(_client);
      await storage.createFile(
        bucketId: bucketId,
        fileId: fileId,
        file: InputFile.fromBytes(
          bytes: fileToSave.readAsBytesSync(),
          filename: fileToSave.path,
        ),
      );
      return fileId;
    } catch (e) {
      rethrow;
    }
  }

  Future<File?> getImage({
    required String bucketId,
    required String fileId,
  }) async {
    try {
      // TODO:
      final storage = Storage(_client);
      final file =
          await storage.getFileView(bucketId: bucketId, fileId: fileId);
      return File.fromRawPath(file);
    } catch (e) {
      rethrow;
    }
  }
}
