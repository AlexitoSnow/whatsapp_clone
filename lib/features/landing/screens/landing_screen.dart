import 'package:flutter/material.dart';
import 'package:whatsapp_clone/router/router.dart';

import '../widgets/language_picker.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  ValueNotifier<String> selected = ValueNotifier('Español');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/images/bg.png',
                  height: 340,
                  width: 340,
                ),
                const Column(
                  children: [
                    Text(
                      'Te damos la bienvenida a WhatsApp',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text('Selecciona tu idioma para comenzar'),
                  ],
                ),
              ],
            ),
            Expanded(
              child: LanguagePicker(
                onSelected: (_) => selectingLanguage(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: selectingLanguage,
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }

  void selectingLanguage() {
    AppRouter.router.go(AppRoutes.privacyPolicy);
  }
}
