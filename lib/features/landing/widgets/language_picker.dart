import 'package:flutter/material.dart';

class LanguagePicker extends StatefulWidget {
  const LanguagePicker({super.key, required this.onSelected});
  final Function(String language) onSelected;

  @override
  State<LanguagePicker> createState() => _LanguagePickerState();
}

class _LanguagePickerState extends State<LanguagePicker> {
  ValueNotifier<String> selected = ValueNotifier(languages.keys.first);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: selected,
        builder: (_, value, child) {
          return ListView.builder(
            itemCount: languages.length,
            itemBuilder: (_, index) {
              return RadioListTile<String>(
                value: languages.keys.elementAt(index),
                groupValue: value,
                title: Text(languages.values.elementAt(index)),
                subtitle: const Text(
                    'Nombre del idioma pero en el idioma seleccionado actual'),
                activeColor: Colors.green,
                onChanged: (language) {
                  selected.value = language!;
                  widget.onSelected(language);
                  //TODO: Save the selected language to the shared preferences
                  //SharedPreferences.getInstance().then((value) {
                  //value.setString('language', selected.value);
                  //});
                },
              );
            },
          );
        });
  }
}

final languages = {
  'es': 'Español',
  'en': 'English',
};
