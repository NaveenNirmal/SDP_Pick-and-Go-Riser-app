import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_search/firestore_search.dart';
import 'package:pickngo/Presenter/mainPresenter.dart';
import 'package:pickngo/Styles/textStyles.dart';
import 'package:pickngo/login.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pickngo/receiverPortal.dart';

class CaptureReceiverPhoto extends StatefulWidget {
  final String customerNumber;

  CaptureReceiverPhoto({this.customerNumber});

  @override
  _CaptureReceiverPhotoState createState() => _CaptureReceiverPhotoState();
}

class _CaptureReceiverPhotoState extends State<CaptureReceiverPhoto> {
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      functionLoad();
    });
  }

  Presenter presenter = new Presenter();

  String docID;
  String docName;
  String docAddress;

  bool imageLoding = false;
  String imgUrl;
  PickedFile imagePick;

  Future<void> functionLoad() async {
    QuerySnapshot querySnap = await FirebaseFirestore.instance
        .collection('order_requests')
        .where('request_status', isEqualTo: 'InTransist')
        .where('receiver_contact', isEqualTo: widget.customerNumber)
        .get();
    QueryDocumentSnapshot doc = querySnap.docs[
        0]; // Assumption: the query returns only one document, THE doc you are looking for.
    DocumentReference docRef = doc.reference;

    setState(() {
      docID = doc.id;
      docName = doc['receiver_name'];
      docAddress = doc['receiver_address'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(right: 30.0, left: 30.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0XFFffa600),
                    Color(0XFFff7b00),
                  ],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 40.0),
                child: Column(
                  children: [
                    Text(
                      "ORDER INFO",
                      style: titleText.copyWith(
                          fontSize: 22.0, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      "${docID}",
                      style: titleText.copyWith(fontSize: 18.0),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.account_circle,
                          color: Colors.white,
                          size: 20.0,
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          "${docName}",
                          style: titleText.copyWith(fontSize: 16.0),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 20.0,
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          "${docAddress}",
                          style: titleText.copyWith(fontSize: 16.0),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //this is a container that contain image
                  //when user select image from Gallery or Camera
                  Text(
                    "RECEIVER PHOTO",
                    style: titleText.copyWith(
                        fontSize: 20.0, color: Colors.black54),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    width: 150,
                    height: 150,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: (imagePick != null)
                          ? Image.file(
                              File(imagePick.path),
                              fit: BoxFit.cover,
                            )
                          : Icon(
                              Icons.image,
                              size: 150,
                              color: Color(0XFFffa600),
                            ),
                    ),
                  ),

                  Row(
                    //this is used to provide space between icons
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //this widget is used to get image from
                      //Camera
                      IconButton(
                        icon: Icon(
                          Icons.camera_alt,
                          size: 30,
                          color: Colors.black54,
                        ),
                        onPressed: () {
                          uploadFromCamera();
                        },
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 30.0,
                  ),

                  FlatButton(
                    splashColor: Color(0XFFffa600),
                    highlightColor: Colors.transparent,
                    onPressed: () {
                      presenter.addCompleteDelivery(docID, imgUrl);
                      presenter.updateStatus(docID, "Delivered");
                      presenter.updateTracking(docID,true, true,true, true, true, true);

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(docID+" Order Delivered Successfully"),
                        backgroundColor: Color(0XFFff7b00),
                      ));

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ReceiverPortal();
                          },
                        ),
                      );
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    padding: const EdgeInsets.all(0.0),
                    child: Ink(
                      decoration: const BoxDecoration(
                        color: Color(0XFFff7b00),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: Container(
                        width: 200,
                        padding: EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.where_to_vote,
                              color: Colors.white,
                            ),

                            SizedBox(
                              width: 10.0,
                            ),

                            Text(
                              "Deliver Parcel",
                              style: thinFont.copyWith(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  uploadFromCamera() async {
    final _storage = FirebaseStorage.instance;
    final _picker = ImagePicker();
    PickedFile image;
    //Check Permissions
    //Select Image
    image = await _picker.getImage(source: ImageSource.camera);
    setState(() {
      image != null ? imageLoding = true : imageLoding = false;
    });
    var file = File(image.path);
    //Upload to Firebase
    var imagename = Random().nextInt(10000).toString();
    var snapshot =
        await _storage.ref().child('receiverImages/$imagename').putFile(file);
    var downloadUrl = await snapshot.ref.getDownloadURL();
    //print(downloadUrl);
    setState(() {
      imgUrl = downloadUrl;
      imageLoding = false;
      imagePick = image;
    });
  }
}
