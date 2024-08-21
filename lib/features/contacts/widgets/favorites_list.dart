import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FavoritesList extends StatelessWidget {
  const FavoritesList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListTile(
                onTap: (){},
                title: const Text(
                  'Person',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                leading: const CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                    'ProfilePic',
                  ),
                  radius: 30,
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.call_outlined),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.videocam_outlined),
            ),
          ],
        );
      },
    );
  }
}
