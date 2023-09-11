import '../../../core/core.dart';

class CommunityOutput {
  const CommunityOutput({
    required this.id,
    required this.ownerId,
    required this.description,
    required this.title,
    required this.image,
  });

  final String id;
  final String ownerId;
  final String description;
  final String title;
  final String image;
}

CommunityOutput communityOutputFromMap(Json json) => CommunityOutput(
      id: json["id"],
      ownerId: json["owner_id"],
      description: json["description"],
      title: json["title"],
      image: json["imageUrl"],
    );
