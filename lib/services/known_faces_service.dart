import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:lazaro_app/models/models.dart';
import 'package:lazaro_app/services/services.dart';

class KnownFacesService extends ChangeNotifier {
  final String _baseUrl =
      'lazaro-18bf3-default-rtdb.europe-west1.firebasedatabase.app';
  final List<KnownFace> knownFaces = [];
  final List<KnownFace> knownFacesByLocalId = [];
  late KnownFace selectedKnownFace;

  final storage = const FlutterSecureStorage();

  File? newPictureFile;

  bool isLoading = true;
  bool isSaving = false;

  KnownFacesService() {
    loadKnownFaces();
  }
  Future<List<KnownFace>> loadKnownFaces() async {
    isLoading = true;
    notifyListeners();
    final url = Uri.https(_baseUrl, 'known_faces.json',
        {'auth': await storage.read(key: 'idToken') ?? ''});
    final resp = await http.get(url);

    print(resp.body);

    final Map<String, dynamic> kownFacesMap = json.decode(resp.body);

    kownFacesMap.forEach((key, value) {
      final tempKnownFace = KnownFace.fromMap(value);
      tempKnownFace.id = key;
      knownFaces.add(tempKnownFace);
    });
    isLoading = false;
    notifyListeners();
    return knownFaces;
  }

  Future<List<KnownFace>> loadKnownFacesByLicalId(String localId) async {
    isLoading = true;
    notifyListeners();
    final url = Uri.https(_baseUrl, 'known_faces.json',
        {'auth': await storage.read(key: 'idToken') ?? ''});
    final resp = await http.get(url);

    print(resp.body);

    final Map<String, dynamic> kownFacesMap = json.decode(resp.body);

    kownFacesMap.forEach((key, value) {
      final tempKnownFace = KnownFace.fromMap(value);
      tempKnownFace.id = key;
      if (tempKnownFace.localId == localId) {
        knownFacesByLocalId.add(tempKnownFace);
      }
    });
    isLoading = false;
    notifyListeners();
    return knownFacesByLocalId;
  }

  Future<String> createKnownFace(KnownFace knownFace, String localId) async {
    final url = Uri.https(_baseUrl, 'known_faces.json',
        {'auth': await storage.read(key: 'idToken') ?? ''});
    knownFace.localId = localId;
    final resp = await http.post(url, body: knownFace.toJson());
    final decodeData = json.decode(resp.body);

    // print(decodeData);
    knownFace.id = decodeData['name'];
    knownFaces.add(knownFace);

    return knownFace.id!;
  }

  Future<String> updateKnownFace(KnownFace knownFace) async {
    final url = Uri.https(_baseUrl, 'known_faces/${knownFace.id}.json',
        {'auth': await storage.read(key: 'idToken') ?? ''});
    final resp = await http.put(url, body: knownFace.toJson());
    final decodeData = resp.body;

    // TODO Actualizar la lista de KnownFaces
    final index =
        knownFaces.indexWhere((element) => element.id == knownFace.id);
    knownFaces[index] = knownFace;
    print(knownFace.id);

    return knownFace.id!;
  }

  Future saveOrCreateKnownFace(KnownFace knownFace, String localId) async {
    isSaving = true;
    notifyListeners();

    if (knownFace.id == null) {
      //es necesario crear
      print('tratando de crear rostro conocido nuevo');
      await createKnownFace(knownFace, localId);
    } else {
      await updateKnownFace(knownFace);
    }

    isSaving = false;
    notifyListeners();
  }

  void updateSelectedKownFaceImage(String path) {
    selectedKnownFace.picture = path;
    newPictureFile = File.fromUri(Uri(path: path));
    notifyListeners();
  }

  Future<String?> uplaodImage() async {
    if (newPictureFile == null) return null;
    isSaving = true;
    notifyListeners();
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/drzw0qhgf/image/upload?upload_preset=rgco1k7o');

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file =
        await http.MultipartFile.fromPath('file', newPictureFile!.path);

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final response = await http.Response.fromStream(streamResponse);

    if (response.statusCode != 200 && response.statusCode != 201) {
      print('algo salio mal al subir la imagen a cloudinary');
      print(response.body);
      return null;
    }
    newPictureFile = null;
    final decodedData = json.decode(response.body);
    return decodedData['secure_url'];
  }

  Future<String?> uplaodImage2(String localId, String name) async {
    if (newPictureFile == null) return null;
    isSaving = true;
    notifyListeners();
    // url backend
    final url = Uri.parse(
        'https://des.digitalonboarding.es/lazaro/face/upload/$localId?name=$name');

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file =
        await http.MultipartFile.fromPath('file', newPictureFile!.path);

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final response = await http.Response.fromStream(streamResponse);

    if (response.statusCode != 200 && response.statusCode != 201) {
      print('algo salio mal al subir la imagen a servidor propio');
      print(response.body);
      return null;
    }
    newPictureFile = null;
    final decodedData = json.decode(response.body);
    print(decodedData['path']);
    return decodedData['path'];
  }

  Future deleteKnownFace(KnownFace knownFace) async {
    final url = Uri.https(_baseUrl, 'known_faces/${knownFace.id}.json',
        {'auth': await storage.read(key: 'idToken') ?? ''});
    final resp = await http.delete(url);
    final statusCode = resp.statusCode;
    if (statusCode != 200) {
      print('Error al borrar el rostro conocido');
    } else {
      // Quitar de la lista de KnownFaces alamacenada en local
      final index =
          knownFaces.indexWhere((element) => element.id == knownFace.id);
      print(index);
      knownFaces.removeAt(index);

      // notificar listeners para que desaparezca del screen
      notifyListeners();
    }
  }
}
