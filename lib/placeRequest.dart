import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pickngo/Presenter/mainPresenter.dart';
import 'package:pickngo/Styles/textStyles.dart';
import 'package:pickngo/acceptedReqList.dart';
import 'package:pickngo/animation/FadeAnimation.dart';
import 'package:pickngo/animation/Form.dart';
import 'package:pickngo/login.dart';
import 'package:pickngo/chooseLocation.dart';
import 'package:pickngo/requestsList.dart';
import 'package:pickngo/search.dart';
import 'package:timeline_tile/timeline_tile.dart';

class PlaceOrder extends StatefulWidget {
  final String customerid;
  final String reqid;
  final String address;
  final String longitude;
  final String latitude;

  PlaceOrder({this.reqid,this.customerid, this.address, this.longitude, this.latitude});

  @override
  _PlaceOrderState createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State<PlaceOrder> {
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

  FirebaseAuth _auth = FirebaseAuth.instance;
  Presenter _presenter = new Presenter();

  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    String request_date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String request_time = DateFormat('H:m').format(DateTime.now());

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
                    fontSize: 16.0,
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
            height: 20.0,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
                margin: EdgeInsets.only(bottom: 30.0),
                width: MediaQuery.of(context).size.width - 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.0),
                  color: Color(0XFFFFFAF3),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 8,
                        offset: Offset(5, 10),
                        color: Color(0xffFFE1C9).withOpacity(.6),
                        spreadRadius: -9)
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Pickup Info",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 2.0,
                    ),
                    Row(children: <Widget>[
                      Expanded(child: Divider()),
                    ]),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Pickup Time",
                          style: textBoxText.copyWith(
                              fontSize: 15.0, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Text(
                          "${selectedTime.hour}:${selectedTime.minute}",
                          style: textBoxText.copyWith(
                              color: Colors.black,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.access_time,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            _selectTime(context);
                          },
                          color: Colors.transparent,
                          splashColor: Colors.red,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),

                    FlatButton(
                      splashColor: Color(0XFF434343),
                      highlightColor: Colors.transparent,
                      onPressed: () {

                        print(widget.reqid);
                        _presenter.updateStatus(widget.reqid, "Accepted");
                        _presenter.updateSchedule(widget.reqid, "${selectedTime.hour}:${selectedTime.minute}");
                        _presenter.addTracking(widget.reqid,true,false, false, false, false, false);
                        _presenter.pickupOrder(widget.reqid, FirebaseAuth.instance.currentUser.uid,widget.customerid, "Accepted", "", "");

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
                          borderRadius: BorderRadius.circular(10.0)),
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
                              ]),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 15.0),
                          constraints: const BoxConstraints(
                              minWidth: 88.0, minHeight: 36.0),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
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
                  ],
                ),
              ),
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
