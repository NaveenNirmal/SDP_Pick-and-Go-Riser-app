import 'package:flutter/material.dart';
import 'package:pickngo/Styles/textStyles.dart';
import 'package:pickngo/login.dart';
import 'package:timeline_tile/timeline_tile.dart';

class PackageTracking extends StatefulWidget {
  const PackageTracking({Key key}) : super(key: key);

  @override
  _PackageTrackingState createState() => _PackageTrackingState();
}

class _PackageTrackingState extends State<PackageTracking> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
        margin: EdgeInsets.only(right: 10.0, left: 10.0),
        child: Stack(
          children: [
            Container(
              alignment: Alignment.topCenter,
              child: Text(
                "Package Details",
                style: pageTitle,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 60.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0XFF00C0FF),
                          Color(0XFF0092FF),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 25.0),
                      child: Column(
                        children: [
                          Text(
                            "Track Your Package",
                            style: titleText.copyWith(fontSize: 24.0),
                          ),
                          Text(
                            "Please enter your tracking number",
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
                                    color: Color(0XFF00A5FF),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 15.0),
                                  width: 195.0,
                                  child: TextFormField(
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      decoration: InputDecoration(
                                          hintText: "Enter Tracking Number",
                                          hintStyle: TextStyle(
                                            fontFamily: 'Manrope',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14.0,
                                            color: Color(0XFF565656),
                                          ),
                                          border: InputBorder.none),
                                      style: textBoxTextLight),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(top: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Destination Address",
                          style: DeliveryStatus.copyWith(fontSize: 18),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          "249/F3 Mountplesent Estate, Hapugala, Wakwella",
                          style: thinFont.copyWith(fontSize: 12.0),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            TimelineTile(
                              alignment: TimelineAlign.start,
                              isFirst: true,
                              indicatorStyle: IndicatorStyle(
                                width: 40,
                                color: Color(0XFF00A5FF),
                                indicatorXY: 0.7,
                                iconStyle: IconStyle(
                                  fontSize: 24.0,
                                  color: Colors.white,
                                  iconData: Icons.check,
                                ),
                              ),
                              afterLineStyle: LineStyle(
                                color: Color(0XFF00A5FF),
                              ),
                              beforeLineStyle: LineStyle(
                                color: Color(0XFF00A5FF),
                              ),
                              endChild: Container(
                                constraints: const BoxConstraints(
                                  minHeight: 80,
                                ),
                                padding: EdgeInsets.only(left: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text("Delivered", style: DeliveryStatus),
                                    Text(
                                      "Your item has been delivered to Wakwella",
                                      style: thinFont.copyWith(fontSize: 12.0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            TimelineTile(
                              alignment: TimelineAlign.start,
                              isLast: false,
                              indicatorStyle: IndicatorStyle(
                                padding: EdgeInsets.only(left: 5),
                                width: 30,
                                color: Color(0XFF00A5FF),
                                indicatorXY: 0.7,
                                iconStyle: IconStyle(
                                  fontSize: 15.0,
                                  color: Colors.white,
                                  iconData: Icons.call_merge_rounded,
                                ),
                              ),
                              afterLineStyle: LineStyle(
                                color: Color(0XFF00A5FF),
                              ),
                              beforeLineStyle: LineStyle(
                                color: Color(0XFF00A5FF),
                              ),
                              endChild: Container(
                                constraints: const BoxConstraints(
                                  minHeight: 80,
                                ),
                                padding: EdgeInsets.only(left: 15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text("Galle, Hapugala",
                                        style: DeliveryStatus),
                                    Text(
                                      "Your item is out for delivery to Hapugala",
                                      style: thinFont.copyWith(fontSize: 12.0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            TimelineTile(
                              alignment: TimelineAlign.start,
                              isLast: false,
                              indicatorStyle: IndicatorStyle(
                                padding: EdgeInsets.only(left: 5),
                                width: 30,
                                color: Color(0XFF00A5FF),
                                indicatorXY: 0.7,
                                iconStyle: IconStyle(
                                  fontSize: 15.0,
                                  color: Colors.white,
                                  iconData: Icons.directions_car_sharp,
                                ),
                              ),
                              beforeLineStyle: LineStyle(
                                color: Color(0XFF00A5FF),
                              ),
                              afterLineStyle: LineStyle(
                                color: Color(0XFF00A5FF),
                              ),
                              endChild: Container(
                                constraints: const BoxConstraints(
                                  minHeight: 80,
                                ),
                                padding: EdgeInsets.only(left: 15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text("Galle Sorting Center",
                                        style: DeliveryStatus),
                                    Text(
                                      "Regional Center Accept Your Package",
                                      style: thinFont.copyWith(fontSize: 12.0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            TimelineTile(
                              alignment: TimelineAlign.start,
                              isLast: true,
                              indicatorStyle: IndicatorStyle(
                                padding: EdgeInsets.only(left: 5),
                                width: 30,
                                color: Color(0XFF00A5FF),
                                indicatorXY: 0.7,
                                iconStyle: IconStyle(
                                  fontSize: 15.0,
                                  color: Colors.white,
                                  iconData: Icons.view_in_ar,
                                ),
                              ),
                              beforeLineStyle: LineStyle(
                                color: Color(0XFF00A5FF),
                              ),
                              endChild: Container(
                                constraints: const BoxConstraints(
                                  minHeight: 80,
                                ),
                                padding: EdgeInsets.only(left: 15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text("Package Accepted",
                                        style: DeliveryStatus),
                                    Text(
                                      "Regional Center Accept Your Package",
                                      style: thinFont.copyWith(fontSize: 12.0),
                                    ),
                                  ],
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
            )
          ],
        ),
      ),
    );
  }
}
