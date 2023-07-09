import 'dart:io';

abstract class ImageManager {
  Future<File?> select();
}
