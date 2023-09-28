import 'package:url_launcher/url_launcher.dart';

import '../../external_dependencies.dart';
import '../../protocols/protocols.dart';
import '../../types.dart';

class LinkService implements LinkHandler {
  @override
  AsyncAction<String> openLink({
    required String link,
  }) async {
    try {
      await launchUrl(
        Uri.parse(link),
        mode: LaunchMode.externalApplication,
      );
      return Right(link);
    } catch (e) {
      return Left(Exception("Can't open this link"));
    }
  }
}
