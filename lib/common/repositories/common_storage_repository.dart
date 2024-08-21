import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

final commonStorageRepositoryProvider = Provider(
  (ref) => CommonStorageRepository(storage: FirebaseStorage.instance),
);

class CommonStorageRepository {
  final FirebaseStorage storage;

  CommonStorageRepository({required this.storage});

  Future<String?> storeFileToFirebase(String ref, File file) async {
    try {
      UploadTask uploadTask = storage.ref().child(ref).putFile(file);
      return await uploadTask.then<String>((snapshot) async {
        String downloadUrl = await snapshot.ref.getDownloadURL();
        return downloadUrl;
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return null;
    }
  }
}
