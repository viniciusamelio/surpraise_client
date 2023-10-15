// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../application.dart';

class SocialAuthDetailsDto {
  const SocialAuthDetailsDto({
    required this.id,
    required this.name,
    required this.provider,
    required this.email,
  });

  final String id;
  final String email;
  final String name;
  final SocialProvider provider;
}
