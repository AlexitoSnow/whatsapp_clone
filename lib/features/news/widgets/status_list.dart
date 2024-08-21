import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:status_view/status_view.dart';

class StatusList extends StatelessWidget {
  const StatusList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 0,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        return Row(
          children: [
            Expanded(
              child: ListTile(
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
                    'info',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                leading: StatusView(
                  centerImageUrl: 'profilePic',
                  radius: 30,
                  indexOfSeenStatus: 3,
                  numberOfStatus: Random().nextInt(5) + 5,
                  seenColor: Colors.green,
                  unSeenColor: Colors.grey,
                ),
              ),
            ),
            CachedNetworkImage(
              imageUrl: 'ProfilePic',
              fit: BoxFit.fitWidth,
              width: MediaQuery.sizeOf(context).width * 0.2,
            ),
          ],
        );
      },
    );
  }
}
