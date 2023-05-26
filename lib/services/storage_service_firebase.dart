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
    try {
      final ref = firebaseStorage.ref('$destination$fileName');
      String imageUrl = await ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print(e.toString());
    }
    return '';
  }

  Future deleteFile(String destination, String fileName) async {
    try {
      final ref = firebaseStorage.ref('$destination$fileName');
      await ref.delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> uploadMultipleFiles(
      String destination, String id, List<File> files) async {
    for (var i = 0; i < files.length; i++) {
      final ref = firebaseStorage.ref('$destination$id/$i');
      await ref.putFile(files[i]);
    }
  }

  Future<List<String>> getMultipleImages(String destination, String id) async {
    try {
      final ref = firebaseStorage.ref().child(destination).child(id);
      final imageUrl = await ref.listAll().then((result) async {
        List<String> urlList = [];
        for (var item in result.items) {
          final url = await item.getDownloadURL();
          urlList.add(url);
        }
        return urlList;
      });
      return imageUrl;
    } catch (e) {
      print(e.toString());
    }
    return [];
  }

  Future deleteMultipleFiles(String destination, String id) async {
    try {
      final ref = firebaseStorage.ref().child(destination).child(id);
      await ref.listAll().then((result) async {
        for (var element in result.items) {
          await element.delete();
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
