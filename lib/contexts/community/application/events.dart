import '../../../core/core.dart';
import '../dtos/dtos.dart';

class CommunitySavedEvent implements ApplicationEvent<CreateCommunityOutput> {
  const CommunitySavedEvent(this.data);

  @override
  final CreateCommunityOutput data;
}

class LeftCommunityEvent implements ApplicationEvent<void> {
  const LeftCommunityEvent({this.data});
  @override
  final void data;
}

class MemberRemovedEvent
    implements ApplicationEvent<FindCommunityMemberOutput> {
  const MemberRemovedEvent(this.data);
  @override
  final FindCommunityMemberOutput data;
}
