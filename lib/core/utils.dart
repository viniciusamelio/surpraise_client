import '../env.dart';

String getAvatarFromId(String id) {
  return "${Env.sbUrl}/storage/v1/object/public/${Env.avatarBucket}/$id.png";
}
