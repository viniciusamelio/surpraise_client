import 'package:flutter/material.dart';
import '../../../../core/external_dependencies.dart' hide CommunityRepository;
import '../../../../env.dart';
import '../../../../shared/presentation/controllers/controllers.dart';
import '../../../../shared/presentation/molecules/error_snack.dart';
import '../../../../shared/presentation/molecules/success_snack.dart';
import '../../../community/application/application.dart';

import '../../../../core/core.dart';
import '../../../../shared/dtos/dtos.dart';
import '../../../community/dtos/dtos.dart';
import '../../../feed/application/application.dart';
import '../../profile.dart';

typedef Communities = List<CommunityOutput>;
typedef Praises = List<PraiseDto>;

abstract class ProfileController extends BaseStateController<Praises> {
  ValueNotifier<DefaultState<Exception, Communities>> get communitiesState;
  AtomNotifier<DefaultState<Exception, String>> get updateAvatarState;

  Future<void> getCommunities(String userId);
  Future<void> getPraises(String userId);
  Future<void> removeAvatar();
  Future<void> updateAvatar();
}

class DefaultProfileController
    with BaseState<Exception, Praises>
    implements ProfileController {
  DefaultProfileController({
    required CommunityRepository communityRepository,
    required FeedRepository feedRepository,
    required StorageService storageService,
    required ImageController imageController,
  })  : _feedRepository = feedRepository,
        _imageController = imageController,
        _storageService = storageService,
        _communityRepository = communityRepository;

  final FeedRepository _feedRepository;
  final CommunityRepository _communityRepository;
  final ImageController _imageController;
  final StorageService _storageService;

  @override
  final ValueNotifier<DefaultState<Exception, Communities>> communitiesState =
      ValueNotifier(InitialState());

  @override
  Future<void> getCommunities(String userId) async {
    communitiesState.value = LoadingState();
    final communitiesOrError =
        await _communityRepository.getCommunities(userId);
    communitiesState.value = communitiesOrError.fold(
      (left) => ErrorState(left),
      (right) => SuccessState(right),
    );
  }

  @override
  Future<void> getPraises(String userId) async {
    state.set(LoadingState());
    final feedsOrError =
        await _feedRepository.getByUser(userId: userId, asPraiser: false);
    stateFromEither(feedsOrError);
  }

  @override
  Future<void> removeAvatar() async {
    final resultOrError = await _storageService.deleteImage(
      bucketId: Env.avatarBucket,
      fileId: injected<SessionController>().currentUser.value!.id,
    );
    resultOrError.fold(
      (left) => null,
      (right) {
        injected<ApplicationEventBus>().add(const AvatarRemovedEvent());
      },
    );
  }

  @override
  Future<void> updateAvatar() async {
    final selectedFile = await _imageController.pickFile();
    if (selectedFile == null) return;
    updateAvatarState.set(LoadingState());
    final uploadedImageOrError = await _imageController.upload(
      UploadImageDto(
        filename: injected<SessionController>().currentUser.value!.id,
        bucket: Env.avatarBucket,
        file: selectedFile,
      ),
    );
    uploadedImageOrError.fold(
      (left) {
        const ErrorSnack(message: "Deu ruim com o upload da imagem").show(
          context: context,
        );
      },
      (right) {
        const SuccessSnack(
          message: "Seu avatar no feed somente será atualizado ao reiniciar",
        ).show(
          context: context,
        );
        updateAvatarState.set(SuccessState(right));
        injected<ApplicationEventBus>().add(
          AvatarUpdatedEvent(
            selectedFile,
          ),
        );
      },
    );
  }

  @override
  final AtomNotifier<DefaultState<Exception, String>> updateAvatarState =
      AtomNotifier(InitialState());
}
