import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:developer';

import 'package:whatsapp_clone/common/repositories/common_storage_repository.dart';
import 'package:whatsapp_clone/models/user_model.dart';
import 'package:whatsapp_clone/router/router.dart';

final authRepositoryProvider = Provider(
    (ref) => AuthRepository(FirebaseAuth.instance, FirebaseFirestore.instance));

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository(this.auth, this.firestore) {
    log('Listening to auth state changes', name: 'AuthStateChanges');
    auth.userChanges().listen((user) {
      log('User data changed', name: 'AuthStateChanges');
      if (user == null) {
        log('User is signed out', name: 'AuthStateChanges');
        AppRouter.router.go(AppRoutes.login);
      } else {
        log('${user.phoneNumber} - ${user.displayName}',
            name: 'AuthStateChanges');
      }
    });
  }

  Future<UserModel?> getCurrentUserData() async {
    var userData =
        await firestore.collection('users').doc(auth.currentUser?.uid).get();
    if (userData.exists) {
      log('User data found', name: 'Auth');
      return UserModel.fromMap(userData.data()!);
    }
    return null;
  }

  Future<void> signInWithPhoneNumber(String phoneNumber,
      Function(String verificationId, int? resendToken) onCodeSent) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (credential) {
          auth.signInWithCredential(credential);
        },
        verificationFailed: (exception) {
          debugPrint(exception.message);
        },
        codeSent: onCodeSent,
        codeAutoRetrievalTimeout: (_) {},
      );
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.code);
      log(e.code, name: 'Auth', error: e);
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      log(e.toString(), name: 'Auth', error: e);
    }
  }

  Future<String?> verifyCode({
    required String verificationId,
    required String userOTP,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: userOTP,
      );
      await auth.signInWithCredential(credential);
      return null;
    } on FirebaseAuthException catch (e) {
      log(e.code, name: 'Auth', error: e);
      return e.code;
    }
  }

  Future<String?> saveUserInformation(
    String? name,
    File? profilePicture,
    ProviderRef ref,
  ) async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        String? url;
        if (profilePicture != null) {
          url = await ref
              .read(commonStorageRepositoryProvider)
              .storeFileToFirebase(
                'profilePics/${user.uid}',
                profilePicture,
              );
        }
        final userModel = UserModel(
          name: name,
          uid: user.uid,
          profilePic: url,
          isOnline: true,
          phoneNumber: user.phoneNumber!,
          groupId: [],
          lastSeen: DateTime.now(),
          info: '',
        );
        user.updateProfile(displayName: name, photoURL: url);
        user.reload();
        firestore.collection('users').doc(user.uid).set(userModel.toMap());
      }
    } catch (e) {
      log(e.toString(), name: 'Auth', error: e);
      return e.toString();
    }
    return null;
  }

  Stream<UserModel> getData(String uid) {
    return firestore.collection('users').doc(uid).snapshots().map((event) {
      return UserModel.fromMap(event.data()!);
    });
  }

  void setUserState(bool isOnline) async {
    try {
      firestore.collection('users').doc(auth.currentUser?.uid).update({
        'isOnline': isOnline,
        'lastSeen': DateTime.now().toIso8601String(),
      });
      log('User state updated: $isOnline', name: 'Auth');
    } catch (e) {
      log(e.toString(), name: 'Auth', error: e);
    }
  }

  Future<String?> updateProfilePicture(
    File? profilePicture,
    ProviderRef ref,
  ) async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        String? url;
        if (profilePicture != null) {
          url = await ref
              .read(commonStorageRepositoryProvider)
              .storeFileToFirebase(
                'profilePics/${user.uid}',
                profilePicture,
              );
        }
        user.updateProfile(photoURL: url);
        user.reload();
        firestore.collection('users').doc(user.uid).update({'profilePic': url});
      }
    } catch (e) {
      log(e.toString(), name: 'Auth', error: e);
      return e.toString();
    }
    return null;
  }
}
