import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

class StoreData {
  Future<String> uploadImageToStorage(
      String childName, Uint8List file, String docId) async {
    Reference ref = _firebaseStorage.ref().child(childName).child(docId);

    final newMetadata = SettableMetadata(
      cacheControl: "public,max-age=300",
      contentType: "image/jpeg",
    );

    UploadTask uploadTask = ref.putData(file, newMetadata);

    TaskSnapshot snap = await uploadTask;

    String downloadUrl = await snap.ref.getDownloadURL();

    return downloadUrl;
  }
}
