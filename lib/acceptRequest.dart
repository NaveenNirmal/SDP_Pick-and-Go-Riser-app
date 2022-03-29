import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:pickngo/Presenter/mainPresenter.dart';
import 'package:pickngo/Styles/textStyles.dart';
import 'package:pickngo/acceptedReqList.dart';

import 'package:url_launcher/url_launcher.dart';

class AcceptRequest extends StatefulWidget {
  final String customerid;
  final String reqid;
  final String address;
  final String longitude;
  final String latitude;

  AcceptRequest(
      {this.reqid,
      this.customerid,
      this.address,
      this.longitude,
      this.latitude});

  @override
  _AcceptRequestState createState() => _AcceptRequestState();
}

class _AcceptRequestState extends State<AcceptRequest> {
  String parceltypes = 'Normal';
  var items = [
    'Normal',
    'Sensitive',
  ];
  String reciever_city;
  String reciever_city_id;
  String selectedval;

  final receiver_name = TextEditingController();
  final receiver_address = TextEditingController();
  final receiver_contact = TextEditingController();
  final receiver_type = TextEditingController();

  Presenter _presenter = new Presenter();

  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    String pickdate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String picktime = DateFormat('H:m').format(DateTime.now());

    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            height: 250.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0XFFFF9700),
                    Color(0XFFFFB900),
                  ]),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.place,
                      color: Colors.white,
                      size: 30.0,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      "Location",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 24.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  widget.address,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.account_circle,
                      color: Colors.white,
                      size: 16.0,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    cusData(widget.customerid, "CustomerName",
                        normalText.copyWith(fontSize: 16.0)),
                  ],
                ),
                SizedBox(
                  height: 5.0,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.phone,
                      color: Colors.white,
                      size: 16.0,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    cusData(widget.customerid, "CustomerContact",
                        normalText.copyWith(fontSize: 16.0)),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 40.0,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              children: [

                FlatButton(
                  splashColor: Color(0XFF434343),
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    print(widget.reqid);
                    _presenter.updateStatus(widget.reqid, "Collected");
                    _presenter.updateTracking(widget.reqid,true, true,false, false, false, false);
                    _presenter.updatePickup(widget.reqid, "Collected", pickdate, picktime);

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(widget.reqid+" Confirmed Pickup Successfully"),
                      backgroundColor: Color(0XFFff7b00),
                    ));

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return AcceptedRequests();
                        },
                      ),
                    );
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  padding: const EdgeInsets.all(0.0),
                  child: Ink(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0XFF2A2A2A),
                          Color(0XFF323232),
                          Color(0XFF272727),
                        ],
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      constraints:
                          const BoxConstraints(minWidth: 88.0, minHeight: 36.0),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            "Confirm Pickup",
                            style: titleText.copyWith(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                FlatButton(
                  splashColor: Colors.orange,
                  highlightColor: Colors.transparent,
                  onPressed: () async {
                    var list = await _getCurrentLocation;

                    String latitude1 = list[1].toString();
                    String longitude1 = list[0].toString();

                    String cuslatitude = widget.latitude;
                    String cuslongitude = widget.longitude;

                    String googleUrl =
                        'https://www.google.com/maps/dir/$latitude1,$longitude1/$cuslatitude,$cuslongitude';
                    if (await canLaunch(googleUrl)) {
                      await launch(googleUrl);
                    } else {
                      throw 'Could not open the map.';
                    }
                    /*
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return AcceptedRequests();
                        },
                      ),
                    );

                     */
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  padding: const EdgeInsets.all(0.0),
                  child: Ink(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0XFFFF9700),
                          Color(0XFFFFB900),
                        ],
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      constraints:
                      const BoxConstraints(minWidth: 88.0, minHeight: 36.0),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.map,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            "Get Direction",
                            style: titleText.copyWith(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),

                Image(
                  image: AssetImage("assets/getpickup.png"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedTime) {
      setState(() {
        selectedTime = timeOfDay;
      });
    }
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

  Future<List> get _getCurrentLocation async {
    try {
      double latitude;
      double longitude;

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      latitude = position.latitude;
      longitude = position.longitude;

      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks[0];
      return [longitude, latitude];
    } on Exception catch (_) {
      return [79.8612, 6.9271];
    }
  }

  void _onShopDropItemSelected(String newValueSelected) {
    setState(
      () {
        final data = newValueSelected.split(',');

        this.selectedval = newValueSelected;
        this.reciever_city = data[1];
        this.reciever_city_id = data[0];
      },
    );
  }
}
