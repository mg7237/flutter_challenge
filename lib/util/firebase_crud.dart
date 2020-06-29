import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

/// Utility package to manage Cloud Firestore DB interactions for UserProfile
/// collection.
/// UserProfile defines the object for App User profile

class UserProfile {
  String name;
  String email;
  int gender;
  DateTime dateOfBirth;
  double flutterExperience;
  String country;
  bool receiveComms;
  String imageURL;

  UserProfile(
      {this.name,
      this.email,
      this.gender,
      this.dateOfBirth,
      this.country,
      this.flutterExperience,
      this.receiveComms,
      this.imageURL});
}

class FirebaseCrud {
  final _firestore = Firestore.instance;

  /// Create or Update user profile based using email as key field
  saveUser(UserProfile _userProfile) async {
    final _userCollection = _firestore.collection("UserProfile");

    List<DocumentSnapshot> documentList = [];
    try {
      documentList = (await _userCollection
              .where("email", isEqualTo: _userProfile.email)
              .getDocuments())
          .documents;

      if (documentList.length == 0) {
        _userCollection.add({
          'email': _userProfile.email,
          'name': _userProfile.name,
          'gender': _userProfile.gender,
          'dateOfBirth': _userProfile.dateOfBirth,
          'country': _userProfile.country,
          'flutterExperience': _userProfile.flutterExperience,
          'receiveComms': _userProfile.receiveComms,
          'imageURL': _userProfile.imageURL
        });
      } else {
        ///     documentList[0].documentID refers to 1st instance of result object array.
        ///     Ideally only one document for an email id should be stored in the collection
        _userCollection.document(documentList[0].documentID).updateData({
          'name': _userProfile.name,
          'gender': _userProfile.gender,
          'dateOfBirth': _userProfile.dateOfBirth,
          'country': _userProfile.country,
          'flutterExperience': _userProfile.flutterExperience,
          'receiveComms': _userProfile.receiveComms,
          'imageURL': _userProfile.imageURL
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  /// Simple Get Profile operation based on the email provided
  Future<UserProfile> getUserProfile({@required String email}) async {
    UserProfile _userProfile = UserProfile();
    final _userCollection = _firestore.collection("UserProfile");
    List<DocumentSnapshot> documentList = [];
    try {
      documentList = (await _userCollection
              .where("email", isEqualTo: email)
              .getDocuments())
          .documents;

      if (documentList.length == 0) {
        return null;
      } else {
        Map a = documentList[0].data;
        a.forEach((key, value) {
          switch (key) {
            case 'email':
              {
                _userProfile.email = value;
                break;
              }
            case 'country':
              {
                _userProfile.country = value;
                break;
              }
            case 'dateOfBirth':
              {
                if (value != null && value != "") {
                  _userProfile.dateOfBirth = (value as Timestamp).toDate();
                }
                break;
              }
            case 'flutterExperience':
              {
                _userProfile.flutterExperience = value;
                break;
              }
            case 'gender':
              {
                _userProfile.gender = value;
                break;
              }
            case 'name':
              {
                _userProfile.name = value;
                break;
              }
            case 'receiveComms':
              {
                _userProfile.receiveComms = value;
                break;
              }
            case 'imageURL':
              {
                _userProfile.imageURL = value;
                break;
              }
            default:
              break;
          }
        });
        // _userProfile.email = documentList[0].data.;
      }
    } catch (e) {
      print(e.toString());
    }
    return _userProfile;
  }
}
