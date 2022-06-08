import 'package:flutter/material.dart';

import 'package:lazaro_app/models/models.dart';

class KnownFaceFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  KnownFace knownFace;

  KnownFaceFormProvider(this.knownFace);

  // updateAvailability(bool value) {
  //   print(value);
  //   knownFace.available = value;
  //   notifyListeners();
  // }

  bool isValidForm() {
    print(knownFace.name);
    print(knownFace.age);
    print(knownFace.relation);

    return formKey.currentState?.validate() ?? false;
  }

  String getName() {
    return knownFace.name;
  }
}
