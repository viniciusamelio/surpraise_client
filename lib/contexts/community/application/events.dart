import '../../../core/core.dart';

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
