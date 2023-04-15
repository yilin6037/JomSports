import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageServiceFirebase {
  final firebaseStorage = FirebaseStorage.instance;

  Future<void> uploadFile(
      String destination, String fileName, File file) async {
    final ref = firebaseStorage.ref(destination + fileName);
    await ref.putFile(file);
  }

  Future<String> getImage(String destination, String fileName) async {
    try{
      final ref = firebaseStorage.ref('$destination$fileName');
      String imageUrl = await ref.getDownloadURL();
      return imageUrl;
    }catch (e){
      print(e.toString());
    }
    return '';
    
  }
}
