import '../../../core/core.dart';

class CommunityAddedEvent implements ApplicationEvent<void> {
  const CommunityAddedEvent([this.data]);

  @override
  final void data;
}
