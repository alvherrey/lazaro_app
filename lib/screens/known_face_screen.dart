import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';

import 'package:lazaro_app/models/models.dart';
import 'package:lazaro_app/providers/providers.dart';
import 'package:lazaro_app/services/services.dart';
import 'package:lazaro_app/ui/input_decorations.dart';
import 'package:lazaro_app/widgets/widgets.dart';

class KnownFaceScreen extends StatelessWidget {
  const KnownFaceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final knownFacesService = Provider.of<KnownFacesService>(context);

    return ChangeNotifierProvider(
      create: (_) => KnownFaceFormProvider(knownFacesService.selectedKnownFace),
      child: _KnownFaceScreenBody(knownFacesService: knownFacesService),
    );
  }
}

class _KnownFaceScreenBody extends StatelessWidget {
  final KnownFacesService knownFacesService;

  const _KnownFaceScreenBody({
    Key? key,
    required this.knownFacesService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final knownFaceForm = Provider.of<KnownFaceFormProvider>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: knownFacesService.isSaving
            ? null
            : () async {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
                if (!knownFaceForm.isValidForm()) return;
                final String name = knownFaceForm.getName();
                final String localId = await authService.readLocalId();
                final String? imageUrl =
                    await knownFacesService.uplaodImage2(localId, name);
                // final String? imageUrl = await knownFacesService.uplaodImage();

                if (knownFaceForm.knownFace.picture != null) {
                  await CachedNetworkImage.evictFromCache(
                      knownFaceForm.knownFace.picture!);
                }
                if (imageUrl != null) {
                  knownFaceForm.knownFace.picture = imageUrl;
                }
                await knownFacesService.saveOrCreateKnownFace(
                    knownFaceForm.knownFace, localId);
              },
        child: knownFacesService.isSaving
            ? const CircularProgressIndicator(color: Colors.white)
            : const Icon(Icons.save),
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
        child: Column(
          children: [
            const SizedBox(
              height: 32,
            ),
            Stack(
              children: [
                KnownFaceImage(
                    url: knownFacesService.selectedKnownFace.picture),
                Positioned(
                  left: 30,
                  top: 50,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  right: 50,
                  top: 50,
                  child: IconButton(
                    onPressed: () async {
                      //TODO: camara o galeria
                      final ImagePicker _picker = ImagePicker();
                      final XFile? photo =
                          await _picker.pickImage(source: ImageSource.camera);
                      if (photo == null) {
                        print('no selecciono nada');
                        return;
                      }
                      print('Tenemos imagen ${photo.path}');
                      knownFacesService.updateSelectedKownFaceImage(photo.path);
                    },
                    icon: const Icon(
                      Icons.camera_alt,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  right: 100,
                  top: 50,
                  child: IconButton(
                    onPressed: () async {
                      //TODO: camara o galeria
                      final ImagePicker _picker = ImagePicker();
                      final XFile? photo =
                          await _picker.pickImage(source: ImageSource.gallery);
                      if (photo == null) {
                        print('no selecciono nada');
                        return;
                      }
                      print('Tenemos imagen ${photo.path}');
                      knownFacesService.updateSelectedKownFaceImage(photo.path);
                    },
                    icon: const Icon(
                      Icons.image,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            _KnownFaceForm(knownFace: knownFacesService.selectedKnownFace),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () async {
                await knownFacesService
                    .deleteKnownFace(knownFacesService.selectedKnownFace);
                Navigator.pop(context, 'home');
              },
              child: const Text(
                'Eliminar rostro',
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.red,
                    fontSize: 24),
              ),
            ),
            // const SizedBox(
            //   height: 100,
            // )
          ],
        ),
      ),
    );
  }
}

class _KnownFaceForm extends StatelessWidget {
  final KnownFace knownFace;

  const _KnownFaceForm({
    Key? key,
    required this.knownFace,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final knownFaceForm = Provider.of<KnownFaceFormProvider>(context);
    final knownFace = knownFaceForm.knownFace;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Form(
          key: knownFaceForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              const SizedBox(height: 10),
              TextFormField(
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'Nombre completo',
                    labelText: 'Nombre',
                    prefixIcon: FontAwesomeIcons.user),
                initialValue: knownFace.name,
                onChanged: (value) => knownFace.name = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El nombre es obligatorio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 4),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'Edad',
                    labelText: 'Edad',
                    prefixIcon: FontAwesomeIcons.cakeCandles),
                initialValue: knownFace.age.toString(),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^(\d+)?\.?\d{0,2}'))
                ],
                onChanged: (value) {
                  if (int.tryParse(value) == null) {
                    knownFace.age = 0;
                  } else {
                    knownFace.age = value as int?;
                  }
                },
              ),
              const SizedBox(height: 4),
              TextFormField(
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'Relación',
                    labelText: 'Relación',
                    prefixIcon: FontAwesomeIcons.userGroup),
                initialValue: knownFace.relation,
                onChanged: (value) => knownFace.relation = value,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => const BoxDecoration(
        // color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(16),
          bottomLeft: Radius.circular(16),
        ),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black26,
        //     blurRadius: 10,
        //     offset: Offset(0, 7),
        //   ),
        // ],
      );
}
