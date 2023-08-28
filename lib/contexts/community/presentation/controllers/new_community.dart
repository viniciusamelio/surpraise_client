import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../../env.dart';
import '../../../../shared/presentation/controllers/session.dart';
import '../../application/application.dart';

abstract class NewCommunityController
    extends BaseStateController<CreateCommunityOutput> {
  ValueNotifier<String> get name;
  ValueNotifier<String> get description;
  ValueNotifier<String> get imagePath;

  Future<void> save();
  Future<void> pickImage();

  void dispose();
}

class DefaultNewCommunityController
    with BaseState<Exception, CreateCommunityOutput>
    implements NewCommunityController {
  DefaultNewCommunityController({
    required CommunityRepository communityRepository,
    required SessionController sessionController,
    required ImageManager imageManager,
    required SupabaseCloudClient supabase,
  })  : _communityRepository = communityRepository,
        _imageManager = imageManager,
        _supabase = supabase,
        _sessionController = sessionController;
  final CommunityRepository _communityRepository;
  final SessionController _sessionController;
  final ImageManager _imageManager;
  final SupabaseCloudClient _supabase;
  @override
  final ValueNotifier<String> description = ValueNotifier("");

  @override
  final ValueNotifier<String> imagePath = ValueNotifier("");

  @override
  final ValueNotifier<String> name = ValueNotifier("");

  @override
  Future<void> save() async {
    state.value = LoadingState();
    String? imageUrl;
    if (imagePath.value.isNotEmpty) {
      final id = DateTime.now().microsecond;
      // TODO: extract upload file service
      final fileId = await _supabase.uploadImage(
        bucketId: Env.communitiesBucket,
        fileId: id.toString(),
        fileToSave: File(imagePath.value),
      );
      imageUrl = await _supabase.getImage(
        fileId: fileId,
        bucketId: Env.communitiesBucket,
      );
    }
    final outputOrError = await _communityRepository.createCommunity(
      CreateCommunityInput(
        description: description.value,
        ownerId: _sessionController.currentUser!.id,
        title: name.value,
        imageUrl: imageUrl!,
      ),
    );
    state.value = outputOrError.fold(
      (left) => ErrorState(left),
      (right) => SuccessState(right),
    );
  }

  @override
  Future<void> pickImage() async {
    final image = await _imageManager.select();
    if (image != null) {
      imagePath.value = image.path;
    }
  }

  @override
  void dispose() {
    state.value = InitialState();
    description.value = "";
    imagePath.value = "";
    name.value = "";
  }
}
