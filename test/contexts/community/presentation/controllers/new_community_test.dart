import 'dart:io';

import 'package:ez_either/ez_either.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:surpraise_client/contexts/community/community.dart';
import 'package:surpraise_client/core/core.dart';
import 'package:surpraise_client/shared/shared.dart';

import '../../../../mocks.dart';

void main() {
  group(
    "New Community Controller",
    () {
      late UpdateCommunityUsecase updateCommunityUsecase;
      late SessionController sessionController;
      late ImageManager imageManager;
      late ImageController imageController;
      late NewCommunityController sut;
      late CreateCommunityUsecase createCommunityUsecase;
      bool receivedEvent = false;
      final input = CreateCommunityInput(
        description: faker.lorem.words(4).join(" "),
        ownerId: faker.guid.guid(),
        title: faker.lorem.word(),
        imageUrl: faker.internet.httpUrl(),
      );

      setUp(() {
        updateCommunityUsecase = MockUpdateCommunityUsecase();
        sessionController = MockSessionController();
        imageManager = MockImageManager();
        imageController = MockImageController();
        createCommunityUsecase = MockCreateCommunityUsecase();
        sut = DefaultNewCommunityController(
          updateCommunityUsecase: updateCommunityUsecase,
          sessionController: sessionController,
          imageManager: imageManager,
          imageController: imageController,
          createCommunityUsecase: createCommunityUsecase,
        );
        WidgetsFlutterBinding.ensureInitialized();
        registerFallbackValue(
          UploadImageDto(
            filename: "mockedfile",
            bucket: "mockedBucket",
            file: File("virtualFile"),
          ),
        );
        registerFallbackValue(
          input,
        );
      });

      setUpAll(() {
        inject<ApplicationEventBus>(
          DefaultBus(),
          singleton: true,
        );
        injected<ApplicationEventBus>().on<CommunitySavedEvent>((event) {
          receivedEvent = true;
        });
      });

      test(
        "sut.save() should throw an error when imagePath.value is empty",
        () async {
          // ignore: deprecated_member_use
          expect(() => sut.save(), throws);
        },
      );

      test(
        "sut.save() should set state as error when upload image fails",
        () async {
          when(() => imageController.upload(any())).thenAnswer(
            (_) async => Left(
              Exception(),
            ),
          );
          sut.imagePath.value = "somekindofpath";

          await sut.save();

          expect(sut.state.value, isA<ErrorState>());
        },
      );

      test(
        "sut.save() should set state as error when upload image succeeds but createCommunity request fails",
        () async {
          when(() => imageController.upload(any())).thenAnswer(
            (_) async => Right(
              faker.internet.httpsUrl(),
            ),
          );
          when(() => createCommunityUsecase(any())).thenAnswer(
            (_) async => Left(Exception()),
          );
          sut.imagePath.value = "somekindofpath";

          await sut.save();

          expect(sut.state.value, isA<ErrorState>());
        },
      );

      test(
        "sut.save() should set state as success & publish CommunityAddedEvent when upload image succeeds & createCommunity request does so",
        () async {
          when(() => imageController.upload(any())).thenAnswer(
            (_) async => Right(
              faker.internet.httpsUrl(),
            ),
          );
          when(() => createCommunityUsecase(any())).thenAnswer(
            (_) async => Right(
              CreateCommunityOutput(
                id: faker.guid.guid(),
                description: input.description,
                title: input.title,
                members: [
                  {
                    "member_id": input.ownerId,
                    "community_id": faker.guid.guid(),
                    "role": "owner",
                  }
                ],
                ownerId: sessionController.currentUser.value!.id,
              ),
            ),
          );
          sut.imagePath.value = "somekindofpath";

          await sut.save();

          expect(sut.state.value, isA<SuccessState>());
          await Future.delayed(const Duration(milliseconds: 10));
          expect(receivedEvent, isTrue);
        },
      );
    },
  );
}
