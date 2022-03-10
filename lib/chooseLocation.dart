import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pickngo/Styles/textStyles.dart';
import 'package:pickngo/login.dart';
import 'package:pickngo/placeRequest.dart';
import 'package:timeline_tile/timeline_tile.dart';

import 'package:google_api_headers/google_api_headers.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:geocoding/geocoding.dart';

const kGoogleApiKey = "AIzaSyCgLIy_l3M4EwsVnzgFwdb1prJz4OR-N3E";

class ChooseLocation extends PlacesAutocompleteWidget {
  ChooseLocation({Key key})
      : super(
          key: key,
          apiKey: kGoogleApiKey,
          sessionToken: Uuid().generateV4(),
          language: "en",
          components: [Component(Component.country, "lk")],
        );

  @override
  _ChooseLocationState createState() => _ChooseLocationState();
}

class _ChooseLocationState extends PlacesAutocompleteState {
  final searchScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      key: searchScaffoldKey,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            height: 200.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0XFF0099FF),
                    Color(0XFF0088FE),
                  ]),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Text(
                    "Where should we pick\nyour parcel ?",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 24.0),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                height: height - 200,
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    FlatButton(
                      splashColor: Color(0XFFFEC405),
                      highlightColor: Colors.transparent,
                      onPressed: () async {
                        var list = await getCurrentLocation;


                        /*
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PlaceOrder(
                                address: list[0],
                                subadministrative: list[1],
                                latitude: list[2].toString(),
                                longitude: list[3].toString(),
                              )
                          ),
                        );
                        */

                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      padding: const EdgeInsets.all(0.0),
                      child: Ink(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0XFFFEC405),
                                Color(0XFFFEDD05),
                              ]),
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          constraints: const BoxConstraints(
                              minWidth: 88.0, minHeight: 36.0),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.white,
                                size: 30.0,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                "Current Location",
                                style: titleText.copyWith(
                                  fontSize: 18.0,
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
                    Row(children: <Widget>[
                      Expanded(child: Divider()),
                      Text("Or"),
                      Expanded(child: Divider()),
                    ]),
                    SizedBox(
                      height: 20.0,
                    ),



                    Container(
                      padding:
                          EdgeInsets.only(bottom: 7, left: 20.0, right: 20.0),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0XFFE6F4FF),
                                Color(0XFFC9E8FF),
                              ]),
                          borderRadius: BorderRadius.circular(30.0)),
                      child: AppBarPlacesAutoCompleteTextField(
                        textDecoration: InputDecoration(
                          hintText: 'Search Location',
                          border: InputBorder.none,
                        ),
                        textStyle: TextStyle(color: Color(0XFF203D56)),
                      ),
                    ),
                    Flexible(
                      child: PlacesAutocompleteResult(
                        onTap: (p) {

                        },
                        logo: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
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



  @override
  void onResponseError(PlacesAutocompleteResponse response) {
    super.onResponseError(response);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }

  @override
  void onResponse(PlacesAutocompleteResponse response) {
    super.onResponse(response);
    if (response != null && response.predictions.isNotEmpty) {}
  }
}

Future<List> get getCurrentLocation async {
  try {
    double latitude;
    double longitude;
    String address;
    String subadministrative;
    String administrative;
    String road;

    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    } else {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      latitude = position.latitude;
      longitude = position.longitude;

      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks[0];

      subadministrative = place.subAdministrativeArea.toString();
      administrative = place.administrativeArea.toString();
      road = place.street.toString();

      address = road + ", " + subadministrative + ", " + administrative;

      return [address, subadministrative, longitude, latitude];
    }
  } on Exception catch (e) {
    print(e);
  }
}

class Uuid {
  final Random _random = Random();

  String generateV4() {
    // Generate xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx / 8-4-4-4-12.
    final int special = 8 + _random.nextInt(4);

    return '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}-'
        '${_bitsDigits(16, 4)}-'
        '4${_bitsDigits(12, 3)}-'
        '${_printDigits(special, 1)}${_bitsDigits(12, 3)}-'
        '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}';
  }

  String _bitsDigits(int bitCount, int digitCount) =>
      _printDigits(_generateBits(bitCount), digitCount);

  int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);

  String _printDigits(int value, int count) =>
      value.toRadixString(16).padLeft(count, '0');
}
