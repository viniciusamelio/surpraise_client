import '../../../core/core.dart';

class ListUserCommunitiesOutput {
  const ListUserCommunitiesOutput({
    required this.id,
    required this.ownerId,
    required this.description,
    required this.title,
    required this.url,
  });

  final String id;
  final String ownerId;
  final String description;
  final String title;
  final String url;
}

ListUserCommunitiesOutput communitiesListToMap(Json json) =>
    ListUserCommunitiesOutput(
      id: json["id"],
      ownerId: json["owner_id"],
      description: json["description"],
      title: json["title"],
      url: json["imageUrl"],
    );