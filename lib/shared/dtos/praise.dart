import '../shared.dart';

class PraiseDto {
  const PraiseDto({
    required this.id,
    required this.message,
    required this.topic,
    required this.communityName,
    required this.communityId,
    required this.praiser,
    this.praised,
  });

  final String id;
  final String message;
  final String topic;
  final String communityName;
  final String communityId;
  final UserDto praiser;
  final UserDto? praised;
}
