import 'package:flutter/material.dart';
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
      appBar: AppBar(
        title: const Text('Novedades'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.camera_alt_outlined),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            ListTile(title: Text('Estados')),
            StatusList(),
          ],
        ),
      ),
    );
  }
}
