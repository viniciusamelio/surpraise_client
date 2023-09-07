import '../../../core/core.dart';

class FindCommunityMemberOutput extends FindCommunityMemberDto {
  FindCommunityMemberOutput({
    required super.id,
    required super.communityId,
    required super.role,
    required this.name,
    required this.tag,
  });

  final String tag;
  final String name;
}
