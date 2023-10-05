// ignore_for_file: public_member_api_docs, sort_constructors_first
class SettingsDto {
  final bool notificationEnabled;
  const SettingsDto({
    required this.notificationEnabled,
  });

  SettingsDto copyWith({
    bool? notificationEnabled,
  }) {
    return SettingsDto(
      notificationEnabled: notificationEnabled ?? this.notificationEnabled,
    );
  }
}
