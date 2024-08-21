import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:whatsapp_clone/models/user_model.dart';

final contactsRepositoryProvider = Provider(
  (ref) => ContactsRepository(
    firestore: FirebaseFirestore.instance,
  ),
);

class ContactsRepository {
  final FirebaseFirestore firestore;

  ContactsRepository({
    required this.firestore,
  });

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

  Future<UserModel?> selectContact(String selectedPhone) async {
    try {
      var userCollection = await firestore.collection('users').get();

      for (var document in userCollection.docs) {
        var userData = UserModel.fromMap(document.data());
        if (selectedPhone == userData.phoneNumber) {
          return userData;
        }
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
    return null;
  }
}
