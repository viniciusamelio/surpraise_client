import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../env.dart';
import '../services/string/field_validations.dart';
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

  Future<void> changePassword({required String newPassword}) async {
    try {
      await supabase.auth
          .updateUser(UserAttributes(password: password(newPassword)));
    } catch (e) {
      throw Exception("Erro ao alterar sua senha");
    }
  }

  Future<void> checkResetOtp(String token) async {
    try {
      await supabase.auth.verifyOTP(token: token, type: OtpType.recovery);
    } catch (e) {
      throw Exception("Erro ao confirmar o código");
    }
  }

  Future<void> requestPasswordReset({required String email}) async {
    try {
      await supabase.auth.resetPasswordForEmail(email);
    } catch (e) {
      throw Exception("Erro ao resetar a senha");
    }
  }

  Future<User> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponse result = await supabase.auth.signUp(
        email: email,
        password: password,
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

  Future<User> signIn({
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
    return result.user!;
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
      final newId = "$fileId.png";
      final result = await supabase.storage.from(bucketId).upload(
            newId,
            fileToSave,
            fileOptions: const FileOptions(upsert: true),
          );
      if (bucketId == Env.avatarBucket) {
        await supabase.auth.updateUser(UserAttributes(
          data: {
            "avatar": result,
            ...supabase.auth.currentUser!.userMetadata!,
          },
        ));
      }

      return "${Env.sbUrl}/storage/v1/object/public/$bucketId/$fileId.png";
    } catch (e) {
      throw const SupabaseUploadImageException();
    }
  }

  Future<String> getImage({
    required String fileId,
    required String bucketId,
  }) async {
    try {
      return supabase.storage.from(bucketId).getPublicUrl(fileId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteImage({
    required String fileId,
    required String bucketId,
  }) async {
    try {
      await supabase.storage.from(bucketId).remove(["$fileId.png"]);
      if (bucketId == Env.avatarBucket) {
        await supabase.auth.updateUser(UserAttributes(
          data: {
            "avatar": null,
            ...supabase.auth.currentUser!.userMetadata!,
          },
        ));
      }
    } catch (e) {
      rethrow;
    }
  }
}
