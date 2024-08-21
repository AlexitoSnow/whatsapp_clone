import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/styles/app_theme.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';

class UserInformationScreen extends ConsumerStatefulWidget {
  const UserInformationScreen({super.key});

  @override
  ConsumerState<UserInformationScreen> createState() =>
      _UserInformationScreenState();
}

class _UserInformationScreenState extends ConsumerState<UserInformationScreen> {
  ValueNotifier<File?> file = ValueNotifier(null);
  var nameController = TextEditingController();

  @override
  void dispose() {
    file.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ref.watch(userDataProvider).when(
            loading: () => const CircularProgressIndicator(),
            error: (error, _) => Text('Error: $error'),
            data: (user) {
              log('User: ${user?.name}', name: 'UserInformationScreen');
              return Column(
                children: [
                  InkWell(
                    onTap: () async =>
                        file.value = await pickImageFromGallery(),
                    child: ValueListenableBuilder(
                      valueListenable: file,
                      builder: (_, value, __) {
                        String? imageUrl = user?.profilePic;
                        return CircleAvatar(
                          backgroundColor: greyColor,
                          foregroundImage: value != null
                              ? FileImage(value)
                              : imageUrl != null
                                  ? NetworkImage(imageUrl)
                                  : null,
                          child: const Icon(Icons.person),
                        );
                      },
                    ),
                  ),
                  TextField(
                    controller: nameController..text = user?.name ?? '',
                    decoration: const InputDecoration(
                      hintText: 'Nombre',
                      suffixIcon: Icon(Icons.check),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: storeUserData,
                    child: const Text('Siguiente'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void storeUserData() async {
    final name = nameController.text.trim();
    await ref.read(authControllerProvider).saveUserInformation(
          name,
          file.value,
        );
  }
}
