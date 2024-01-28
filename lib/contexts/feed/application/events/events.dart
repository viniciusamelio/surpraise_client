import '../../../../core/core.dart';
import '../../../../shared/shared.dart';

class InviteAnsweredEvent extends ApplicationEvent<String> {
  const InviteAnsweredEvent(super.data);
}

class ReactionAddedEvent extends ApplicationEvent<PraiseReactionDto> {
  const ReactionAddedEvent(super.data);
}

class ReactionRemovedEvent extends ApplicationEvent<PraiseReactionDto> {
  const ReactionRemovedEvent(super.data);
}
