import 'package:flutter/material.dart';

class NiaMaterialLocalizations extends DefaultMaterialLocalizations {
  const NiaMaterialLocalizations();

  @override
  String get okButtonLabel => 'Lau';
}

class NiaMaterialLocalizationsDelegate extends LocalizationsDelegate<MaterialLocalizations> {
  const NiaMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'nia';

  @override
  Future<MaterialLocalizations> load(Locale locale) async {
    return const NiaMaterialLocalizations();
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<MaterialLocalizations> old) => false;
}
