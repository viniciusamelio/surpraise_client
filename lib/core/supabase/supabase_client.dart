import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../env.dart';
import 'exception.dart';

class SupabaseCloudClient {
  const SupabaseCloudClient({
    required this.supabase,
  });
  static Future<void> init() async {
    await Supabase.initialize(
      url: Env.sbUrl,
      anonKey: Env.sbKey,
    );
  }

  final SupabaseClient supabase;

  Future<User> signUp({
    required String email,
    required String password,
    required String userId,
  }) async {
    try {
      final AuthResponse result = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          "userId": userId,
        },
      );
      await signIn(password: password, email: email);
      if (result.user == null) {
        throw const SupabaseUserSigninException();
      }
      return result.user!;
    } catch (e) {
      throw const SupabaseUserSigninException();
    }
  }

  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    final AuthResponse result = await supabase.auth.signInWithPassword(
      password: password,
      email: email,
    );
    if (result.user == null) {
      throw const SupabaseUserSigninException();
    }
    return result.user!.userMetadata!["userId"]!;
  }

  Future<void> logout() async {
    await supabase.auth.signOut();
  }

  Future<String> uploadImage({
    required String bucketId,
    required String fileId,
    required File fileToSave,
  }) async {
    try {
      final result = await supabase.storage.from(bucketId).upload(
            "$fileId.png",
            fileToSave,
          );
      await supabase.auth.updateUser(UserAttributes(
        data: {
          "avatar": result,
          ...supabase.auth.currentUser!.userMetadata!,
        },
      ));
      return result;
    } catch (e) {
      throw const SupabaseUploadImageException();
    }
  }

  Future<String> getImage({
    required String fileId,
    required String bucketId,
  }) async {
    try {
      return supabase.storage.from(bucketId).getPublicUrl("$fileId.png");
    } catch (e) {
      rethrow;
    }
  }
}
