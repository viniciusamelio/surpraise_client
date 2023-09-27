import 'dart:io';

import '../../core/core.dart';

class ProfileEditedEvent extends ApplicationEvent<EditUserOutput> {
  const ProfileEditedEvent(super.data);
}

class AvatarRemovedEvent extends ApplicationEvent<void> {
  const AvatarRemovedEvent() : super(null);
}

class AvatarUpdatedEvent extends ApplicationEvent<File> {
  const AvatarUpdatedEvent(super.data);
}
