import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../../shared/presentation/controllers/session.dart';
import '../../application/application.dart';

abstract class NewCommunityController
    extends BaseStateController<CreateCommunityOutput> {
  ValueNotifier<String> get name;
  ValueNotifier<String> get description;
  ValueNotifier<String> get imagePath;

  Future<void> save();
  Future<void> pickImage();
}

class DefaultNewCommunityController
    with BaseState<Exception, CreateCommunityOutput>
    implements NewCommunityController {
  DefaultNewCommunityController({
    required CommunityRepository communityRepository,
    required SessionController sessionController,
  })  : _communityRepository = communityRepository,
        _sessionController = sessionController;
  final CommunityRepository _communityRepository;
  final SessionController _sessionController;
  @override
  final ValueNotifier<String> description = ValueNotifier("");

  @override
  final ValueNotifier<String> imagePath = ValueNotifier("");

  @override
  final ValueNotifier<String> name = ValueNotifier("");

  @override
  Future<void> save() async {
    state.value = LoadingState();
    //TODO: fazer upload da imagem antes de criar a comunidade
    final outputOrError = await _communityRepository.createCommunity(
      CreateCommunityInput(
        description: description.value,
        ownerId: _sessionController.currentUser!.id,
        title: name.value,
        imageUrl: imagePath.value,
      ),
    );
    state.value = outputOrError.fold(
      (left) => ErrorState(left),
      (right) => SuccessState(right),
    );
  }

  @override
  Future<void> pickImage() async {
    // TODO: implement pickImage
    throw UnimplementedError();
  }
}
