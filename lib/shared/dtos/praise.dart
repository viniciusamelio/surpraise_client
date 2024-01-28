import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

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
    this.reactions = const [],
    this.extraPraiseds = const [],
    this.private = false,
  });

  final String id;
  final String message;
  final String topic;
  final String communityName;
  final String communityId;
  final UserDto praiser;
  final UserDto? praised;
  final List<PraiseReactionDto> reactions;
  final List<String> extraPraiseds;
  final bool private;

  @override
  List<Object?> get props => [
        id,
        message,
        topic,
        communityName,
        communityId,
        praiser.id,
        praised?.id,
        reactions,
      ];

  PraiseDto copyWith({
    String? id,
    String? message,
    String? topic,
    String? communityName,
    String? communityId,
    UserDto? praiser,
    ValueGetter<UserDto?>? praised,
    List<PraiseReactionDto>? reactions,
    List<String>? extraPraiseds,
  }) {
    return PraiseDto(
      id: id ?? this.id,
      message: message ?? this.message,
      topic: topic ?? this.topic,
      communityName: communityName ?? this.communityName,
      communityId: communityId ?? this.communityId,
      praiser: praiser ?? this.praiser,
      praised: praised != null ? praised() : this.praised,
      reactions: reactions ?? this.reactions,
      extraPraiseds: extraPraiseds ?? this.extraPraiseds,
    );
  }
}
