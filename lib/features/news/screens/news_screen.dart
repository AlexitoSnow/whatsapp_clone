import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/widgets/whatsapp_app_bar.dart';
import 'package:whatsapp_clone/features/news/widgets/status_list.dart';
import 'package:whatsapp_clone/styles/app_theme.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: tabColor,
        child: const Icon(
          Icons.camera_alt,
          color: Colors.white,
        ),
      ),
      appBar: WhatsappAppBar(
        menuItems: const [
          PopupMenuItem(
            child: Text('Privacidad de estados'),
          ),
          PopupMenuItem(
            child: Text('Crear canal'),
          ),
        ],
        title: 'Novedades',
        onSearch: () {},
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            ListTile(title: Text('Estados')),
            ListTile(
              title: Text('Mi estado'),
              subtitle: Text('Añade una actualización'),
              leading: Badge(
                alignment: Alignment.bottomRight,
                backgroundColor: Colors.green,
                label: Icon(
                  Icons.add,
                  color: Colors.black,
                ),
                child: CircleAvatar(
                  //backgroundImage: NetworkImage('profilePic'),
                  backgroundColor: Colors.grey,
                ),
              ),
            ),
            StatusList(),
          ],
        ),
      ),
    );
  }
}
