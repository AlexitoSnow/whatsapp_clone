import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sliding_up_panel2/sliding_up_panel2.dart';
import 'package:whatsapp_clone/styles/app_theme.dart';
import 'package:whatsapp_clone/features/landing/widgets/language_picker.dart';
import 'package:whatsapp_clone/router/router.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  var controller = PanelController();
  ValueNotifier<String> selected = ValueNotifier(languages.keys.first);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        actions: [
          PopupMenuButton(
            itemBuilder: (_) {
              return [
                const PopupMenuItem(
                  child: Text('Ayuda'),
                ),
              ];
            },
          ),
        ],
      ),
      body: SlidingUpPanel(
        controller: controller,
        backdropEnabled: true,
        backdropTapClosesPanel: true,
        snapPoint: 0.5,
        panelBuilder: () {
          return Padding(
            padding: const EdgeInsets.only(top: kToolbarHeight),
            child: LanguagePicker(
              onSelected: (language) {
                selected.value = language;
                controller.close();
              },
            ),
          );
        },
        color: backgroundColor,
        header: SizedBox(
          height: kToolbarHeight,
          width: MediaQuery.sizeOf(context).width,
          child: ListTile(
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                controller.close();
              },
            ),
            title: const Text('Idioma de la aplicación'),
          ),
        ),
        collapsed: const Icon(Icons.minimize),
        minHeight: 0,
        maxHeight: MediaQuery.sizeOf(context).height,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                'assets/images/bg.png',
                height: 340,
                width: 340,
              ),
              const Text(
                'Te damos la bienvenida a WhatsApp',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    text: 'Lee nuestra',
                    children: [
                      TextSpan(
                        text: ' Política de privacidad',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                      TextSpan(
                        text: '. Toca "Aceptar y continuar" para aceptar las ',
                      ),
                      TextSpan(
                        text: 'Condiciones del servicio',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                      TextSpan(
                        text: '.',
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.sizeOf(context).width * 0.3,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  color: messageColor,
                ),
                child: InkWell(
                  onTap: () {
                    controller.animatePanelToSnapPoint();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.language,
                        color: tabColor,
                      ),
                      const SizedBox(width: 8),
                      ValueListenableBuilder(
                        valueListenable: selected,
                        builder: (_, value, child) => Text(
                          value,
                          style: const TextStyle(
                            fontSize: 10,
                            color: tabColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: tabColor,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        SizedBox.expand(
          child: ElevatedButton(
            onPressed: () async {
              //TODO: Save the selected language to the shared preferences
              //SharedPreferences.getInstance().then((value) {
              //value.setString('language', selected.value);
              //});
              context.go(AppRoutes.login);
            },
            child: const Text('Aceptar y continuar'),
          ),
        ),
      ],
    );
  }
}
