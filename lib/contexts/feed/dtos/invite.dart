import '../../../core/core.dart';

class InviteDto {
  const InviteDto({
    required this.communityTitle,
    required this.communityId,
    required this.role,
  });

  final String communityTitle;
  final String communityId;
  final Role role;
}

InviteDto inviteFromMap(Json map) => InviteDto(
      communityTitle: map["community"]["title"],
      communityId: map["community_id"],
      role: Role.values.singleWhere((element) => element.value == map["role"]),
    );
