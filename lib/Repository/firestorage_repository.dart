import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Firestorage_repository {
  firebase_storage.UploadTask uploodImageFile(String subjectName, String uid, String filename, File file) {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('$subjectName/$uid')
        .child('/$filename.jpg');

    return ref.putFile(file);
  }
}
