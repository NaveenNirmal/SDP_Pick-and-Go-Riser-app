import 'dart:ffi';
import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pickngo/Styles/textStyles.dart';
import 'package:pickngo/acceptRequest.dart';
import 'package:pickngo/dashboard.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pickngo/login.dart';
import 'package:pickngo/chooseLocation.dart';
import 'package:pickngo/placeRequest.dart';
import 'package:pickngo/search.dart';
import 'package:timeline_tile/timeline_tile.dart';

class AcceptedRequests extends StatefulWidget {
  const AcceptedRequests({Key key}) : super(key: key);

  @override
  _AcceptedRequestsState createState() => _AcceptedRequestsState();
}

class _AcceptedRequestsState extends State<AcceptedRequests> {

  @override

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
          "Accepted Requests",
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
                  .collection('order_pickup').where('employee_id',isEqualTo: FirebaseAuth.instance.currentUser.uid).where('pic_status',isEqualTo: "Accepted")
                  .snapshots(),
              builder: (_, snapshot) {
                if (snapshot.hasError) return Text('Error = ${snapshot.error}');

                if (snapshot.hasData) {
                  final docs = snapshot.data.docs;

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (_, i) {
                      final dataa = docs[i].data();

                      print(snapshot.data.docs
                          .elementAt(i)
                          .id);
                      return Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                          future: FirebaseFirestore.instance.collection("order_requests").doc(dataa['req_id']).get(),
                          builder: (_, snapshot) {
                            if (snapshot.hasError) return Text('Error = ${snapshot.error}');

                            if (snapshot.hasData) {
                              var data = snapshot.data.data();


                              var cuslatitude = data["customer_live_latitude"].toString();
                              var cuslongitude = data["customer_live_longitude"].toString();

                              return FlatButton(
                                splashColor: Color(0XFFFFF2E5),
                                highlightColor: Colors.transparent,
                                onPressed: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => AcceptRequest(
                                      customerid: dataa["customer_id"],
                                      reqid: dataa["req_id"],
                                      address: data["customer_live_address"],
                                      longitude: data["customer_live_longitude"],
                                      latitude: data["customer_live_latitude"],
                                    )),
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
                                        requestData(
                                          dataa['customer_id'],
                                          "customer",
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
                                              child: requestData(
                                                dataa['req_id'],
                                                "order_requests",
                                                "customer_live_address",
                                                titleText.copyWith(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: thinFont.color,
                                                ),
                                              ),
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
                                            requestData(
                                                "${dataa['customer_id']}", "customer",
                                                "CustomerContact", thinFont),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),

                                        Row(
                                          children: [
                                            Icon(
                                              Icons.access_time,
                                              color: Colors.red,
                                            ),
                                            SizedBox(
                                              width: 10.0,
                                            ),
                                            requestData(
                                              dataa['req_id'],
                                              "order_requests",
                                              "shedule_time",
                                              titleText.copyWith(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w800,
                                                  color: Colors.red
                                              ),
                                            ),
                                          ],
                                        ),

                                        SizedBox(
                                          height: 10.0,
                                        ),

                                        getDistance(dataa['req_id']),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }

                            return Center(child: Text(""));
                          },
                        )
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

  Widget requestData(String id, String collection, String field_name, txtstyle) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance.collection(collection).doc(id).get(),
      builder: (_, snapshot) {
        if (snapshot.hasError) return Text('Error = ${snapshot.error}');

        if (snapshot.hasData) {
          var data = snapshot.data.data();
          var value = data[field_name]; // <-- Your value
          return Text(
            "${value}",
            style: txtstyle,
          );
        }

        return Center(child: Text(""));
      },
    );
  }

  Widget getDistance(String id) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance.collection("order_requests").doc(id).get(),
      builder: (_, snapshot) {
        if (snapshot.hasError) return Text('Error = ${snapshot.error}');

        if (snapshot.hasData) {
          var data = snapshot.data.data();
          var latitude = data["customer_live_latitude"];
          var longitude = data["customer_live_longitude"];

          return Row(
            children: [
              Container(
                height: 30.0,
                width: 70.0,
                decoration: BoxDecoration(
                    color: data['receiver_type'] ==
                        "Sensitive"
                        ? Colors.red
                        : Colors.amber,
                    borderRadius:
                    BorderRadius.circular(30.0)),
                alignment: Alignment.center,
                child: Text(
                  "${data["receiver_type"]}",
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
                  FutureBuilder(future: getDistanceBetween(
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
          );
        }

        return Center(child: Text(""));
      },
    );
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
    print(_currentUserPosition);

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
    double totalDistance = 0;
    for (var i = 0; i < polylineCoordinates.length - 1; i++) {
      totalDistance += calculateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i + 1].latitude,
          polylineCoordinates[i + 1].longitude);
    }
    print(totalDistance);

    return totalDistance;
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }



}


