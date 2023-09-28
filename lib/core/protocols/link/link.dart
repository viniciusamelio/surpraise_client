import '../../types.dart';

abstract class LinkHandler {
  AsyncAction<String> openLink({
    required String link,
  });
}
