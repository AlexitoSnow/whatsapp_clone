import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> pickMediaFromGallery() async {
  File? media;
  try {
    final picked = await ImagePicker().pickMedia();
    if (picked != null) {
      media = File(picked.path);
    }
  } catch (e) {
    log(e.toString());
    Fluttertoast.showToast(msg: e.toString());
  }
  return media;
}

Future<File?> pickFile() async {
  File? file;
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      file = File(result.files.single.path!);
    }
  } catch (e) {
    log(e.toString());
    Fluttertoast.showToast(msg: e.toString());
  }
  return file;
}
