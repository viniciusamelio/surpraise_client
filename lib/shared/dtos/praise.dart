import 'package:equatable/equatable.dart';

import '../shared.dart';

class PraiseDto extends Equatable {
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

  @override
  List<Object?> get props => [
        id,
        message,
        topic,
        communityName,
        communityId,
        praiser.id,
        praised?.id,
      ];
}
