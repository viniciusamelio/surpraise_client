import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../../core.dart';

class ImagePickerService implements ImageManager {
  @override
  Future<File?> select() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) {
      return null;
    }
    return File.fromUri(Uri.parse(image.path));
  }
}
