import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/config/app_life_cycle/app_life_cycle.dart';
import 'package:whatsapp_clone/features/chats/screens/chats_screen.dart';
import 'package:whatsapp_clone/features/communities/screens/communities_screen.dart';
import 'package:whatsapp_clone/features/news/screens/news_screen.dart';
import '../features/calls/screens/calls_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends AppLifeCycle<HomeScreen> {
  final pageController = PageController();
  final ValueNotifier<int> selectedIndex = ValueNotifier(0);

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
    selectedIndex.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          selectedIndex.value = index;
        },
        children: const [
          ChatsScreen(),
          NewsScreen(),
          CommunitiesScreen(),
          CallsScreen(),
        ],
      ),
      bottomNavigationBar: ValueListenableBuilder(
          valueListenable: selectedIndex,
          builder: (context, value, child) {
            return AppNavigationBar(
              selectedIndex: value,
              onDestinationSelected: (index) {
                pageController.jumpToPage(index);
                selectedIndex.value = index;
              },
            );
          }),
    );
  }
}

class AppNavigationBar extends StatelessWidget {
  const AppNavigationBar({
    super.key,
    required this.selectedIndex,
    this.onDestinationSelected,
  });

  final int selectedIndex;
  final void Function(int)? onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: const [
        NavigationDestination(
          icon: Badge(
            label: Text('+99'),
            child: Icon(Icons.chat_outlined),
          ),
          selectedIcon: Badge(
            label: Text('+99'),
            child: Icon(Icons.chat),
          ),
          label: 'Chats',
          tooltip: 'Chats',
        ),
        NavigationDestination(
          icon: Badge(child: Icon(Icons.circle_outlined)),
          selectedIcon: Icon(Icons.circle),
          label: 'Novedades',
          tooltip: 'Novedades',
        ),
        NavigationDestination(
          icon: Icon(Icons.groups_outlined),
          selectedIcon: Icon(Icons.groups),
          label: 'Comunidades',
          tooltip: 'Comunidades',
        ),
        NavigationDestination(
          icon: Icon(Icons.call_outlined),
          selectedIcon: Icon(Icons.call),
          label: 'Llamadas',
          tooltip: 'Llamadas',
        ),
      ],
    );
  }
}
