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
    late UpdateCommunityUsecase updateCommunityUsecase;
    late MockLeaveCommunityUsecase leaveCommunityUsecase;
    late MockGetMembersQuery getMembersQuery;

    setUpAll(() {
      registerFallbackValue(
        LeaveCommunityInput(
          memberId: faker.guid.guid(),
          communityId: faker.guid.guid(),
          memberRole: "member",
        ),
      );
      registerFallbackValue(
        GetMembersInput(communityId: faker.guid.guid()),
      );
    });

    setUp(() {
      updateCommunityUsecase = MockUpdateCommunityUsecase();
      sessionController = MockSessionController();
      leaveCommunityUsecase = MockLeaveCommunityUsecase();
      getMembersQuery = MockGetMembersQuery();
      sut = DefaultCommunityDetailsController(
        sessionController: sessionController,
        getMembersQuery: getMembersQuery,
        leaveCommunityUsecase: leaveCommunityUsecase,
      );
      WidgetsFlutterBinding.ensureInitialized();
    });

    tearDown(() {
      reset(updateCommunityUsecase);
      reset(sessionController);
    });

    test(
      "sut.getMembers() should set state as loading when action starts",
      () async {
        when(
          () => getMembersQuery(any()),
        ).thenAnswer((_) async {
          return Right(const GetMembersOutput(value: []));
        });

        sut.getMembers(id: faker.guid.guid());

        expect(sut.state.value, isA<LoadingState>());
        verify(() => getMembersQuery(any())).called(1);
      },
    );

    test(
      "sut.getMembers() should set state as success when repo returns right",
      () async {
        when(
          () => getMembersQuery(any()),
        ).thenAnswer((_) async {
          return Right(const GetMembersOutput(value: []));
        });

        await sut.getMembers(id: faker.guid.guid());

        expect(sut.state.value, isA<SuccessState>());
        verify(() => getMembersQuery(any())).called(1);
      },
    );

    test(
      "sut.getMembers() should set state as error when repo returns left",
      () async {
        when(
          () => getMembersQuery(any()),
        ).thenAnswer((_) async {
          return Left(QueryError("some error"));
        });

        await sut.getMembers(id: faker.guid.guid());

        expect(sut.state.value, isA<ErrorState>());
        verify(() => getMembersQuery(any())).called(1);
      },
    );

    test(
      "sut.leave() should set state as loading when action starts",
      () async {
        when(
          () => leaveCommunityUsecase(
            any(),
          ),
        ).thenAnswer((_) async {
          return Right(const LeaveCommunityOutput(""));
        });

        sut.leave(
          communityId: faker.guid.guid(),
          role: Role.member,
        );

        expect(sut.leaveState.value, isA<LoadingState>());
        verify(
          () => leaveCommunityUsecase(
            any(),
          ),
        ).called(1);
      },
    );

    test(
      "sut.leave() should set state as success when repo returns right",
      () async {
        when(
          () => leaveCommunityUsecase(
            any(),
          ),
        ).thenAnswer((_) async {
          return Right(const LeaveCommunityOutput(""));
        });

        await sut.leave(
          communityId: faker.guid.guid(),
          role: Role.moderator,
        );

        expect(sut.leaveState.value, isA<SuccessState<Exception, void>>());
        verify(
          () => leaveCommunityUsecase(
            any(),
          ),
        ).called(1);
      },
    );

    test(
      "sut.leave() should set state as error when repo returns left",
      () async {
        when(
          () => leaveCommunityUsecase(
            any(),
          ),
        ).thenAnswer((_) async {
          return Left(Exception());
        });

        await sut.leave(communityId: faker.guid.guid(), role: Role.member);

        expect(sut.leaveState.value, isA<ErrorState>());
        verify(
          () => leaveCommunityUsecase(
            any(),
          ),
        ).called(1);
      },
    );
  });
}
