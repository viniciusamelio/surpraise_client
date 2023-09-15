import 'package:faker/faker.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:surpraise_client/contexts/community/community.dart';
import 'package:surpraise_client/core/external_dependencies.dart'
    hide CommunityRepository;
import 'package:surpraise_client/core/state/default_state.dart';
import 'package:surpraise_client/shared/shared.dart';

import '../../../../mocks.dart';

void main() {
  group("Community Details Controller: ", () {
    late CommunityDetailsController sut;
    late SessionController sessionController;
    late CommunityRepository communityRepository;

    setUp(() {
      communityRepository = MockCommunityRepository();
      sessionController = MockSessionController();
      sut = DefaultCommunityDetailsController(
        sessionController: sessionController,
        communityRepository: communityRepository,
      );
      WidgetsFlutterBinding.ensureInitialized();
    });

    tearDown(() {
      reset(communityRepository);
      reset(sessionController);
    });

    test(
      "sut.getMembers() should set state as loading when action starts",
      () async {
        when(
          () => communityRepository.getCommunityMembers(any()),
        ).thenAnswer((_) async {
          return Right([]);
        });

        sut.getMembers(id: faker.guid.guid());

        expect(sut.state.value, isA<LoadingState>());
        verify(() => communityRepository.getCommunityMembers(any())).called(1);
      },
    );

    test(
      "sut.getMembers() should set state as success when repo returns right",
      () async {
        when(
          () => communityRepository.getCommunityMembers(any()),
        ).thenAnswer((_) async {
          return Right([]);
        });

        await sut.getMembers(id: faker.guid.guid());

        expect(sut.state.value, isA<SuccessState>());
        verify(() => communityRepository.getCommunityMembers(any())).called(1);
      },
    );

    test(
      "sut.getMembers() should set state as error when repo returns left",
      () async {
        when(
          () => communityRepository.getCommunityMembers(any()),
        ).thenAnswer((_) async {
          return Left(Exception());
        });

        await sut.getMembers(id: faker.guid.guid());

        expect(sut.state.value, isA<ErrorState>());
        verify(() => communityRepository.getCommunityMembers(any())).called(1);
      },
    );

    test(
      "sut.leave() should set state as loading when action starts",
      () async {
        when(
          () => communityRepository.leaveCommunity(
            communityId: any(named: "communityId"),
            memberId: any(named: "memberId"),
          ),
        ).thenAnswer((_) async {
          return Right(null);
        });

        sut.leave(communityId: faker.guid.guid());

        expect(sut.leaveState.value, isA<LoadingState>());
        verify(() => communityRepository.leaveCommunity(
            communityId: any(named: "communityId"),
            memberId: any(named: "memberId"))).called(1);
      },
    );

    test(
      "sut.leave() should set state as success when repo returns right",
      () async {
        when(
          () => communityRepository.leaveCommunity(
            communityId: any(named: "communityId"),
            memberId: any(named: "memberId"),
          ),
        ).thenAnswer((_) async {
          return Right(null);
        });

        await sut.leave(communityId: faker.guid.guid());

        expect(sut.leaveState.value, isA<SuccessState<Exception, void>>());
        verify(
          () => communityRepository.leaveCommunity(
            communityId: any(named: "communityId"),
            memberId: any(named: "memberId"),
          ),
        ).called(1);
      },
    );

    test(
      "sut.leave() should set state as error when repo returns left",
      () async {
        when(
          () => communityRepository.leaveCommunity(
            communityId: any(named: "communityId"),
            memberId: any(named: "memberId"),
          ),
        ).thenAnswer((_) async {
          return Left(Exception());
        });

        await sut.leave(communityId: faker.guid.guid());

        expect(sut.leaveState.value, isA<ErrorState>());
        verify(
          () => communityRepository.leaveCommunity(
            communityId: any(named: "communityId"),
            memberId: any(named: "memberId"),
          ),
        ).called(1);
      },
    );
  });
}
