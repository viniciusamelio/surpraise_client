import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../external_dependencies.dart';
import '../../protocols/protocols.dart';
import '../../types.dart';

class LinkService implements LinkHandler {
  @override
  AsyncAction<String> openLink({
    required String link,
  }) async {
    try {
      if (!await canLaunchUrlString(link)) {
        return Left(Exception("Can't open this link"));
      }

      await launchUrl(Uri.parse(link));
      return Right(link);
    } catch (e) {
      return Left(Exception("Can't open this link"));
    }
  }
}
