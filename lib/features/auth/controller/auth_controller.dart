import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:whatsapp_clone/models/user_model.dart';
import 'package:whatsapp_clone/router/router.dart';

import '../repository/auth_repository.dart';

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository, ref);
});

final userDataProvider = FutureProvider<UserModel?>((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.getCurrentUserData();
});

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;

  AuthController(this.authRepository, this.ref);

  Future<UserModel?> getCurrentUserData() async {
    return await authRepository.getCurrentUserData();
  }

  Future<void> login(
    String phoneNumber,
    Function(String, int?) onCodeSent,
  ) async {
    authRepository.signInWithPhoneNumber(phoneNumber, onCodeSent);
  }

  Future<void> verifyOTP(
    String verificationId,
    String otp,
  ) async {
    var response = await authRepository.verifyCode(
        verificationId: verificationId, userOTP: otp);
    if (response == null) {
      AppRouter.router.go(AppRoutes.userInfo);
    } else {
      Fluttertoast.showToast(msg: response);
    }
  }

  Future<void> saveUserInformation(
    String name,
    File? profilePicture,
  ) async {
    final response =
        await authRepository.saveUserInformation(name, profilePicture, ref);
    if (response == null) {
      AppRouter.router.go(AppRoutes.home);
    } else {
      Fluttertoast.showToast(msg: response);
    }
  }

  Future<String?> updateProfilePicture(
    File? profilePicture,
  ) async {
    final response =
        await authRepository.updateProfilePicture(profilePicture, ref);
    if (response == null) {
      Fluttertoast.showToast(msg: 'Foto de perfil actualizada');
    } else {
      Fluttertoast.showToast(msg: response);
    }
    return null;
  }

  Stream<UserModel> getUserById(String uid) {
    return authRepository.getData(uid);
  }

  void updateUserState(bool isOnline) {
    authRepository.setUserState(isOnline);
  }
}
