import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CallList extends StatelessWidget {
  const CallList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 0,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {},
          title: const Text(
            'Person',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          subtitle: const Padding(
            padding: EdgeInsets.only(top: 6.0),
            child: Text(
              'Info',
              style: TextStyle(fontSize: 15),
            ),
          ),
          leading: const CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(
              'Profilepic',
            ),
            radius: 30,
          ),
          trailing: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call_outlined),
          ),
        );
      },
    );
  }
}
