import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pickngo/Styles/textStyles.dart';
import 'package:pickngo/acceptedReqList.dart';
import 'package:pickngo/captureReceiverPhoto.dart';
import 'package:pickngo/dashboard.dart';
import 'package:pickngo/login.dart';
import 'package:pickngo/requestsList.dart';
import 'package:firestore_search/firestore_search.dart';

class ReceiverPortal extends StatefulWidget {
  @override
  _ReceiverPortalState createState() => _ReceiverPortalState();
}

class _ReceiverPortalState extends State<ReceiverPortal> {
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
              MaterialPageRoute(builder: (context) => Dashboard()),
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
                      "Parcel Distribution",
                      style: titleText.copyWith(fontSize: 24.0),
                    ),
                    Text(
                      "Please Enter Parcel Number",
                      style: subText,
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Container(
                      width: 250,
                      height: 60.0,
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white),
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            child: Icon(
                              Icons.track_changes,
                              color: Color(0XFFffa600),
                            ),
                          ),
                          Expanded(
                            child: FirestoreSearchBar(
                              tag: 'example',
                              searchBackgroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(
              height: 20.0,
            ),

            Expanded(
              child: FirestoreSearchResults.builder(
                tag: 'example',
                firestoreCollectionName: 'order_requests',
                searchBy: 'receiver_contact',
                initialBody: const Center(
                  child: Text('Enter the Receiver Contact Number'),
                ),
                dataListFromSnapshot: DataModel().dataListFromSnapshot,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final List<DataModel> dataList = snapshot.data;
                    if (dataList.isEmpty) {
                      return const Center(
                        child: Text('No Results Returned'),
                      );
                    }
                    return ListView.builder(
                        itemCount: dataList.length,
                        itemBuilder: (context, index) {
                          final DataModel data = dataList[index];

                          return Visibility(
                            visible: data.request_status=='In Transist' ? true:false,
                            child: Container(
                              height: 90.0,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: 120.0,
                                                  child: Text(
                                                    "${data.receiver_name}",
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    textAlign: TextAlign.start,
                                                    style: thinFont.copyWith(
                                                      color: Color(0XFF202D3D),
                                                      fontSize: 16.0,
                                                      fontWeight: FontWeight.w800,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5.0,
                                                ),
                                                Container(
                                                  width: 120.0,
                                                  child: Text(
                                                    "${data.receiver_address}",
                                                    style: thinFont.copyWith(
                                                      color: Color(0XFFffa600),
                                                      fontSize: 16.0,
                                                      fontWeight: FontWeight.w800,
                                                    ),
                                                    maxLines: 1,
                                                    textAlign: TextAlign.start,

                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5.0,
                                                ),
                                                Container(
                                                  width: 120.0,
                                                  child: Text(
                                                    "${data.request_status}",
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    textAlign: TextAlign.start,
                                                    style: thinFont.copyWith(
                                                      color: Color(0XFFffa600),
                                                      fontSize: 16.0,
                                                      fontWeight: FontWeight.w800,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            FlatButton(
                                              splashColor: Color(0XFFffa600),
                                              highlightColor: Colors.transparent,
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) {
                                                      return CaptureReceiverPhoto(

                                                      );
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
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 25.0, horizontal: 20.0),
                                                  child: Text(
                                                    "Distribute",
                                                    style: thinFont.copyWith(
                                                        color: Colors.white,
                                                        fontSize: 14.0,
                                                        fontWeight: FontWeight.w600),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  }

                  if (snapshot.connectionState == ConnectionState.done) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: Text('No Results Returned'),
                      );
                    }
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DataModel {
  final String receiver_name;
  final String receiver_address;
  final String receiver_contact;
  final String request_status;

  DataModel(
      {this.receiver_name,
      this.receiver_address,
      this.receiver_contact,
      this.request_status});

  //Create a method to convert QuerySnapshot from Cloud Firestore to a list of objects of this DataModel
  //This function in essential to the working of FirestoreSearchScaffold

  List<DataModel> dataListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((snapshot) {
      final Map<String, dynamic> dataMap =
          snapshot.data() as Map<String, dynamic>;

      return DataModel(
          receiver_name: dataMap['receiver_name'],
          receiver_address: dataMap['receiver_address'],
          receiver_contact: dataMap['receiver_contact'],
          request_status: dataMap['request_status']);
    }).toList();
  }
}
