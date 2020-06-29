import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

/// File storage / retrieval / delete of files at Fiebase Storage cloud
class FirebaseImageOps {
  File _file;
  String _user;
  String _fileName;
  var storage;

  FirebaseImageOps() {
    storage = FirebaseStorage.instance;
  }

  Future<String> uploadFile({String user, File file}) async {
    _user = user;
    _file = file;

    String downloadURL = "";
    if (_file == null) {
      throw ("File to upload has not been provided. Use fileToUpload setter to provide file to upload");
    } else if (_user == null) {
      throw ("User not provided");
    } else {
      _fileName = path.basename(_file.path);
      try {
        StorageTaskSnapshot snapshot = await storage
            .ref()
            .child("images/$_user/$_fileName")
            .putFile(_file)
            .onComplete;
        if (snapshot.error == null) {
          downloadURL = await snapshot.ref.getDownloadURL();
        }
      } catch (e) {
        print(e.toString());
      }
    }
    return downloadURL;
  }

  Future<bool> deleteImage({String documentURL}) async {
    if (documentURL == null) {
      throw ("Document URL not provided");
    } else {
      StorageReference docReference =
          await storage.getReferenceFromUrl(documentURL);
      docReference.delete();
      print("deleted");
    }
    return true;
  }
}
