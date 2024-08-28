import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
              future: ref.watch(userDataProvider.future),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  final data = snapshot.data;
                  return ListTile(
                    title: Text(data?.name ?? '~'),
                    subtitle: Text(data?.info ?? 'Hola, estoy usando WhatsApp'),
                    leading: InkWell(
                      onTap: () async {
                        await pickMediaFromGallery().then((value) {
                          if (value != null) {
                            ref
                                .read(authControllerProvider)
                                .updateProfilePicture(value);
                          }
                        });
                      },
                      child: CircleAvatar(
                        backgroundImage: data?.profilePic != null
                            ? NetworkImage(data!.profilePic!)
                            : null,
                        radius: 20,
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.grey,
                        child: data?.profilePic == null
                            ? const Icon(Icons.person)
                            : null,
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return ListTile(
                    title: const Text('Error'),
                    subtitle: Text(snapshot.error.toString()),
                  );
                } else {
                  return const ListTile(
                    title: Text('Cargando...'),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
