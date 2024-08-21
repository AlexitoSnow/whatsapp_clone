// TODO: Poner en primer lugar al país según la ubicación del usuario y en segundo a los países que hablan el idioma del usuario
import 'package:country/country.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/styles/app_theme.dart';

class CountryPickerScreen extends StatelessWidget {
  const CountryPickerScreen({super.key, required this.selected});

  final ValueNotifier<Country?> selected;

  @override
  Widget build(BuildContext context) {
    /*
    var countries = Countries.values;
    if (selected.value != null) {
      countries = 
    }
    */
    return Scaffold(
      appBar: AppBar(
        title: const Text('Elige un país'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: Countries.values.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (_, index) {
          final country = Countries.values[index];
          var nameByLocale = country.isoShortNameByLocale[
              Localizations.localeOf(context).languageCode]!;
          var name = country.isoShortName;
          return ListTile(
            title: Text(
              nameByLocale,
              style: TextStyle(
                color: selected.value == country ? tabColor : textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: nameByLocale != name
                ? Text(
                    name,
                  )
                : null,
            leading: Text(country.flagEmoji),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '+${country.countryCode}',
                  style: const TextStyle(
                    color: greyColor,
                  ),
                ),
                if (selected.value == country)
                  const Icon(
                    Icons.check,
                    color: tabColor,
                  ),
              ],
            ),
            onTap: () {
              Navigator.pop(context, country);
            },
          );
        },
      ),
    );
  }
}
