import 'package:flutter/widgets.dart';

class PraiseReactionDto {
  final String userId;
  final String praiseId;
  final String reaction;
  final String? id;

  const PraiseReactionDto({
    required this.userId,
    required this.praiseId,
    required this.reaction,
    this.id,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PraiseReactionDto &&
        other.userId == userId &&
        other.praiseId == praiseId &&
        other.reaction == reaction;
  }

  @override
  int get hashCode => userId.hashCode ^ praiseId.hashCode ^ reaction.hashCode;

  PraiseReactionDto copyWith({
    String? userId,
    String? praiseId,
    String? reaction,
    ValueGetter<String?>? id,
  }) {
    return PraiseReactionDto(
      userId: userId ?? this.userId,
      praiseId: praiseId ?? this.praiseId,
      reaction: reaction ?? this.reaction,
      id: id != null ? id() : this.id,
    );
  }
}
