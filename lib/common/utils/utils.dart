import 'dart:developer';
import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> pickImageFromGallery() async {
  File? image;
  try {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      image = File(picked.path);
    }
  } catch (e) {
    log(e.toString());
    Fluttertoast.showToast(msg: e.toString());
  }
  return image;
}
