import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:myshoppinglist/models/user_model.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _firebaseStorage;

  UserRepository({FirebaseAuth? firebaseAuth, FirebaseFirestore? firestore, FirebaseStorage? cloudstorage})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _firebaseStorage = cloudstorage ?? FirebaseStorage.instance;

  Future<UserModel?> signInWithCredential(String email, String password) async {
    UserCredential credential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

    if (credential.user != null) {
      return UserModel(uuid: credential.user?.uid, email: credential.user?.email ?? "");
    } else {
      return null;
    }
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  Future<bool> isSignedIn() async {
    final currentUser = _firebaseAuth.currentUser;
    return currentUser != null;
  }

  Future<UserModel?> getUser() async {
    final currentUser = _firebaseAuth.currentUser;

    if (currentUser != null) {
      UserModel userSettings = await getSetting(currentUser.uid);

      String avatar = await getAvatar(currentUser.uid);

      return UserModel(uuid: currentUser.uid, email: currentUser.email ?? "", name: userSettings.name, surname: userSettings.surname, avatar: avatar);
    }
    return null;
  }

  Future<UserModel> getSetting(String uuid) async {
    DocumentReference<Map<String, dynamic>> userRef = _firestore.collection("users").doc(uuid);
    DocumentSnapshot<Map<String, dynamic>> userSnapshot = await userRef.get();

    Map<String, dynamic>? documentData = userSnapshot.data();

    return UserModel(
      uuid: uuid,
      name: documentData?['name'] ?? "",
      surname: documentData?['surname'] ?? "",
      email: documentData?['email'] ?? "",
    );
  }

  Future<UserModel> updateSetting(UserModel user) async {
    CollectionReference<Map<String, dynamic>> userRef = _firestore.collection("users");

    await userRef.doc(user.uuid).set({
      'name': user.name,
      'surname': user.surname,
      'email': user.email,
    });

    return user.copyWith(name: user.name, surname: user.surname, email: user.email);
  }

  Future<String> getAvatar(String uuid) async {
    try {
      final Reference storageRef = _firebaseStorage.ref();

      final Reference fileRef = storageRef.child("avatars/$uuid.jpg");

      return await fileRef.getDownloadURL();
    } catch (e) {
      return "";
    }
  }

  Future<String> uploadAvatar(String uuid, File selectedFile) async {
    final Reference storageRef = _firebaseStorage.ref();

    final Reference fileRef = storageRef.child("avatars/$uuid.jpg");

    await fileRef.putFile(selectedFile);

    return await fileRef.getDownloadURL();
  }
}
