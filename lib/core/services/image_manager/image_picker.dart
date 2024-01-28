import 'dart:io';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../colors.dart';
import '../../core.dart';

class ImagePickerService implements ImageManager {
  @override
  Future<File?> select() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) {
      return null;
    }
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      cropStyle: CropStyle.circle,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: "Recortar imagem",
          lockAspectRatio: true,
          toolbarColor: purple,
        ),
        IOSUiSettings(
          title: "Recortar imagem",
          aspectRatioLockEnabled: true,
          hidesNavigationBar: true,
          cancelButtonTitle: "Cancelar",
          doneButtonTitle: "Pronto",
        )
      ],
    );
    if (croppedFile == null) {
      return File.fromUri(Uri.parse(image.path));
    }

    return File(croppedFile.path);
  }
}
