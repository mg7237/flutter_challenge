import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mgflutter/util/constants.dart';
import 'package:mgflutter/util/firebase_crud.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DrawerProfile extends StatefulWidget {
  @override
  _DrawerProfileState createState() => _DrawerProfileState();
}

class _DrawerProfileState extends State<DrawerProfile> {
  String email;
  String name;
  String imageURL;
  bool fetchDataComplete = false;
  String _emailInitials;

  Future<void> getHeaderData() async {
    try {
      var sharedPrefInstance = await SharedPreferences.getInstance();
      email = sharedPrefInstance.getString(k_UserId) ?? "";
    } catch (e) {
      print(e.toString());
      email = "";
    }

    if (email == "") {
      name = "Not Available";
      imageURL = "";
    } else {
      FirebaseCrud firebaseInstance = FirebaseCrud();
      UserProfile userProfile;
      userProfile = await firebaseInstance.getUserProfile(email: email);
      if (userProfile == null) {
        name = "Not Available";
        imageURL = "";
      } else {
        name = userProfile.name;
        imageURL = userProfile.imageURL;
      }
    }
    if (email.length > 2) {
      _emailInitials = email.substring(0, 2).toUpperCase();
    }
    setState(() => fetchDataComplete = true);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getHeaderData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: (fetchDataComplete)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        child: Text(
                          name,
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                        margin: EdgeInsets.only(top: 10),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        email,
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                  CircleAvatar(
                      child: (imageURL != "" && imageURL != null)
                          ? ClipOval(
                              child: Container(
                                  height: 100,
                                  width: 100,
                                  child: Image(
                                      image: CachedNetworkImageProvider(
                                        imageURL,
                                      ),
                                      fit: BoxFit.cover)))
                          : Text(_emailInitials ?? ""),
                      backgroundColor: Colors.lightBlueAccent,
                      radius: 45)
                ],
              )
            : Container());
  }
}
