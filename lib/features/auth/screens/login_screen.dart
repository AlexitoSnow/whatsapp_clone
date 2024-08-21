// TODO: Preguntar por notificaciones
// TODO: El número es válido si la longitud del número es igual a alguna de las longitudes de los números del país seleccionado
import 'package:country/country.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/router/router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  ValueNotifier<Country?> countrySelected =
      ValueNotifier(Countries.values.first);
  final phoneController = TextEditingController();
  final codeController = TextEditingController();

  void sendPhoneNumber() {
    final phoneNumber = phoneController.text.trim();
    if (phoneNumber.isNotEmpty && countrySelected.value != null) {
      if (!verifyPhoneNumber(phoneNumber)) return;
      ref.read(authControllerProvider).login(
        '+${countrySelected.value!.countryCode}$phoneNumber',
        (verificationId, resendToken) {
          context.push(
            AppRoutes.otp,
            extra: verificationId,
          );
        },
      );
    } else {
      Fluttertoast.showToast(
        msg: 'Ingresa un número de teléfono válido',
        backgroundColor: Colors.red,
      );
    }
  }

  bool verifyPhoneNumber(String number) {
    final numberLenghts = countrySelected.value!.nationalNumberLengths;
    if (!numberLenghts.contains(number.length)) {
      Fluttertoast.showToast(
        msg:
            'El número de teléfono es inválido para el país seleccionado: ${countrySelected.value!.isoShortName}',
        backgroundColor: Colors.red,
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingresa tu número de teléfono'),
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
                  'WhatsApp necesitará verificar tu número de teléfono (es posible que tu operador aplique cargos).',
              children: [
                TextSpan(
                  text: ' ¿Cuál es mi número?',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: InkWell(
                onTap: () {
                  context
                      .push<Country>(AppRoutes.countryPicker,
                          extra: countrySelected)
                      .then((value) {
                    if (value != null) {
                      countrySelected.value = value;
                    }
                  });
                },
                child: ValueListenableBuilder(
                  valueListenable: countrySelected,
                  builder: (_, value, child) {
                    var text = codeController.text.isEmpty
                        ? 'Elige un país'
                        : value == null
                            ? 'Cód. de país inválido'
                            : value.isoShortName;
                    return IgnorePointer(
                      child: TextField(
                        controller: TextEditingController(text: text),
                        decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.arrow_drop_down),
                        ),
                        textAlign: TextAlign.center,
                        readOnly: true,
                      ),
                    );
                  },
                ),
              )),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: ValueListenableBuilder(
                    valueListenable: countrySelected,
                    builder: (_, value, child) {
                      if (value != null) {
                        codeController.text = value.countryCode;
                      }
                      return TextField(
                        controller: codeController,
                        onChanged: (value) {
                          countrySelected.value =
                              Countries.values.whereType<Country?>().firstWhere(
                                    (element) => element!.countryCode == value,
                                    orElse: () => null,
                                  );
                        },
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.add),
                        ),
                        inputFormatters: [LengthLimitingTextInputFormatter(3)],
                        keyboardType: TextInputType.number,
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      hintText: 'Número de teléfono',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [LengthLimitingTextInputFormatter(18)],
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: ElevatedButton(
              onPressed: sendPhoneNumber,
              child: const Text('Sig.'),
            ),
          ),
        ],
      ),
    );
  }
}
