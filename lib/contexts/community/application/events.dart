import '../../../core/core.dart';

class CommunityAddedEvent implements ApplicationEvent<void> {
  const CommunityAddedEvent([this.data]);

  @override
  final void data;
}

class LeftCommunityEvent implements ApplicationEvent<void> {
  const LeftCommunityEvent({this.data});
  @override
  final void data;
}
