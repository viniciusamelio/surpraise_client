import '../../../core/external_dependencies.dart';

class InviteDto {
  const InviteDto({
    required this.communityTitle,
    required this.communityId,
    required this.role,
    required this.id,
  });

  final String communityTitle;
  final String communityId;
  final Role role;
  final String id;
}

InviteDto inviteFromMap(Map<String, dynamic> map) => InviteDto(
      id: map["id"],
      communityTitle: map["community"]["title"],
      communityId: map["community_id"],
      role: Role.values.singleWhere((element) => element.value == map["role"]),
    );
