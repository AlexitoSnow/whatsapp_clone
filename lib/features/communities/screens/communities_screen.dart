import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/widgets/whatsapp_app_bar.dart';

class CommunitiesScreen extends StatelessWidget {
  const CommunitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: WhatsappAppBar(
        title: 'Comunidades',
      ),
    );
  }
}
