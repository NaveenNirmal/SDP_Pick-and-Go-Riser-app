
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pickngo/Styles/textStyles.dart';
import 'package:pickngo/dashboard.dart';
import 'package:pickngo/placeRequest.dart';


class RequestsList extends StatefulWidget {
  const RequestsList({Key key}) : super(key: key);

  @override
  _RequestsListState createState() => _RequestsListState();
}



class _RequestsListState extends State<RequestsList> {
  String userId = "";

  GoogleMapController mapController; //contrller for Google map
  PolylinePoints polylinePoints = PolylinePoints();

  String googleAPiKey = "AIzaSyDTmXstM4eO3I6dbJr1Mq0sX4s08WNkiWc";

  Set<Marker> markers = Set(); //markers for google map
  Map<PolylineId, Polyline> polylines = {}; //polylines to show direction

  double distance = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        title: Text(
          "Pickup Requests",
          style: textLableDark.copyWith(
              fontSize: 20.0, fontWeight: FontWeight.w700),
        ),
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
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('order_requests').where('request_status',isEqualTo: 'Pending')
                  .snapshots(),
              builder: (_, snapshot) {
                if (snapshot.hasError) return Text('Error = ${snapshot.error}');

                if (snapshot.hasData) {
                  final docs = snapshot.data.docs;

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (_, i) {
                      final dataa = docs[i].data();
                      var latitude = dataa["customer_live_latitude"];
                      var longitude = dataa["customer_live_longitude"];

                      print(snapshot.data.docs.elementAt(i).id);
                      return Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: FlatButton(
                          splashColor: Color(0XFFFFF2E5),
                          highlightColor: Colors.transparent,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return PlaceOrder(
                                    reqid: snapshot.data.docs.elementAt(i).id,
                                    customerid: dataa["customer_id"],
                                    address: dataa["customer_live_address"],
                                    longitude: dataa["customer_live_longitude"],
                                    latitude: dataa["customer_live_latitude"],
                                  );
                                },
                              ),
                            );
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          padding: const EdgeInsets.all(0.0),
                          child: Ink(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 20.0, horizontal: 20.0),
                              constraints: const BoxConstraints(
                                  minWidth: 88.0, minHeight: 36.0),
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  cusData(
                                    dataa['customer_id'],
                                    "CustomerName",
                                    titleText.copyWith(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w600,
                                      color: thinFont.color,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: thinFont.color,
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Flexible(
                                        child: Text(
                                            "${dataa['customer_live_address']}",
                                            style: thinFont),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.phone,
                                        color: thinFont.color,
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      cusData("${dataa['customer_id']}",
                                          "CustomerContact", thinFont),
                                    ],
                                  ),

                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        height: 30.0,
                                        width: 70.0,
                                        decoration: BoxDecoration(
                                            color: dataa['receiver_type'] ==
                                                    "Sensitive"
                                                ? Colors.red
                                                : Colors.amber,
                                            borderRadius:
                                                BorderRadius.circular(30.0)),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "${dataa["receiver_type"]}",
                                          style: thinFont.copyWith(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Row(
                                        children: [
                                          Image(
                                            image: AssetImage(
                                                "assets/distancebetween.png"),
                                            width: 30.0,
                                            color: thinFont.color,
                                          ),
                                          FutureBuilder(
                                            future: getDistanceBetween(
                                                double.parse(latitude),
                                                double.parse(longitude)),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                return Text(
                                                  snapshot.data
                                                          .toStringAsFixed(2) +
                                                      "KM Away",
                                                  style: textLableDark,
                                                );
                                              } else {
                                                return Text('Loading...');
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }

                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );

  }

  Future<String> getUserName(String uid) async {
    String value = "";
    var collection = FirebaseFirestore.instance.collection('customer');
    var docSnapshot = await collection.doc(uid).get();
    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data();
      value = data['CustomerName'];
    }
    return value;
  }

  Future<double> getDistanceBetween(double lat, double lon) async {
    List<LatLng> polylineCoordinates = [];

    LocationPermission permission;
    bool serviceEnabled;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position _currentUserPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);


    LatLng startLocation =
        LatLng(_currentUserPosition.latitude, _currentUserPosition.longitude);
    LatLng endLocation = LatLng(lat, lon);


    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(startLocation.latitude, startLocation.longitude),
      PointLatLng(endLocation.latitude, endLocation.longitude),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    double totalDistance=0.00;
    for (var i = 0; i < polylineCoordinates.length - 1; i++) {
      totalDistance += calculateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i + 1].latitude,
          polylineCoordinates[i + 1].longitude);
    }
    print(totalDistance);

    print("Current Position is"+totalDistance.toString());

    return totalDistance;
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }


  Widget cusData(String id, String fname, txtstyle) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance.collection("customer").doc(id).get(),
      builder: (_, snapshot) {
        if (snapshot.hasError) return Text('Error = ${snapshot.error}');

        if (snapshot.hasData) {
          var data = snapshot.data.data();
          var value = data[fname]; // <-- Your value
          return Text(
            value,
            style: txtstyle,
          );
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
