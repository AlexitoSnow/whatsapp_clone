import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';

class OtpScreen extends ConsumerWidget {
  const OtpScreen({super.key, required this.verificationId});

  final String verificationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifica tu número de teléfono'),
        actions: [
          PopupMenuButton(
            itemBuilder: (_) {
              return [
                const PopupMenuItem(
                  child: Text('Vincular como dispositivo adicional'),
                ),
                const PopupMenuItem(
                  child: Text('Ayuda'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          RichText(
            text: const TextSpan(
              text:
                  'WhatsApp enviará un SMS con un código de verificación al número de teléfono que uses para verificar que es tuyo. ',
              children: [
                TextSpan(
                  text: '¿Qué es esto?',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Pinput(
            onCompleted: (value) => verifyCode(ref, value),
            autofocus: true,
            length: 6,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Siguiente'),
          ),
        ],
      ),
    );
  }

  void verifyCode(WidgetRef ref, String userOTP) async {
    ref.read(authControllerProvider).verifyOTP(verificationId, userOTP);
  }
}
