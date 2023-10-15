import '../../../../core/events/events.dart';
import '../application.dart';

export "consumers.dart";

class SocialSignedInEvent extends ApplicationEvent<SocialAuthDetailsDto> {
  const SocialSignedInEvent(super.data);
}
