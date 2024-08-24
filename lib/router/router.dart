/*
TODO: When the locale is selected, the app should be reloaded to apply the changes and 
TODO: if the user goes out of the app and comes back, the app should be in the privacy policy screen
*/
import 'dart:async';
import 'dart:developer';

import 'package:country/country.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:whatsapp_clone/features/screens.dart';
import 'package:whatsapp_clone/features/chat/screens/chat_screen.dart';
import 'package:whatsapp_clone/features/settings/screens/settings_screen.dart';
import 'package:whatsapp_clone/screens/profile_screen.dart';

import '../features/auth/controller/auth_controller.dart';
import '../models/user_model.dart';
import '../screens/home_screen.dart';

part 'routes.dart';

class AppRouter {
  static GoRouter router = GoRouter(
    initialLocation: AppRoutes.landing,
    redirect: redirection,
    routes: routes,
    debugLogDiagnostics: true,
  );

  //TODO: Implement the redirection method
  static FutureOr<String?> redirection(context, state) async {
    final container = ProviderScope.containerOf(context);
    var user = await container.read(userDataProvider.future);
    final currentLocation = state.fullPath;

    log('UserModel has data: ${user != null}', name: 'AppRouter Redirect');
    log('Current Location: ${state.fullPath}', name: 'AppRouter Redirect');
/*
    // * Redirection rules at Landing Screen
    if (currentLocation == AppRoutes.landing) {}

    // * Redirection rules at Home Screen
    if (currentLocation == AppRoutes.home) {}*/

    /*
    //TODO: Read the selected language from the shared preferences
    SharedPreferences.getInstance().then((value) {
      // * That means that is the first time the app is opened
      if (value.containsKey('locale') && user == null) {
        log('Locale found', name: 'AppRouter Redirect');
        return AppRoutes.privacyPolicy;
      } else {
        log('Locale not found', name: 'AppRouter Redirect');
        return AppRoutes.landing;
      }
    });

    */
    if (user == null && currentLocation == AppRoutes.home) {
      log('No user data found, redirecting to login',
          name: 'AppRouter Redirect');
      return AppRoutes.login;
    }

    if (user != null && currentLocation == AppRoutes.landing) {
      log('User data found, redirecting to mobile chat',
          name: 'AppRouter Redirect');
      return AppRoutes.home;
    }

    log('User data found, not doing anything', name: 'AppRouter Redirect');
    return null;
  }

  static List<GoRoute> routes = [
    GoRoute(
      path: AppRoutes.landing,
      builder: (_, __) => const LandingScreen(),
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (_, __) => const SettingsScreen(),
    ),
    GoRoute(
      path: AppRoutes.profile,
      builder: (_, state) => ProfileScreen(user: state.extra as UserModel?),
    ),
    GoRoute(
      path: AppRoutes.privacyPolicy,
      builder: (_, __) => const PrivacyPolicyScreen(),
    ),
    GoRoute(
      path: AppRoutes.otp,
      builder: (_, state) => OtpScreen(verificationId: state.extra as String),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (_, __) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.userInfo,
      builder: (_, __) => const UserInformationScreen(),
    ),
    GoRoute(
      path: AppRoutes.countryPicker,
      builder: (_, state) =>
          CountryPickerScreen(selected: state.extra as ValueNotifier<Country?>),
    ),
    GoRoute(
      path: AppRoutes.contacts,
      builder: (_, __) => const ContactsScreen(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (_, __) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.chat,
      builder: (_, state) {
        final user = state.extra as Map<String, dynamic>;
        return ChatScreen(
          name: user['name'],
          receiverUserId: user['uid'],
        );
      },
    ),
  ];
}
