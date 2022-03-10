import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pickngo/Styles/textStyles.dart';
import 'package:pickngo/acceptedReqList.dart';
import 'package:pickngo/login.dart';
import 'package:pickngo/chooseLocation.dart';
import 'package:pickngo/requestsList.dart';
import 'package:pickngo/search.dart';
import 'package:timeline_tile/timeline_tile.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
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
        margin: EdgeInsets.only(right: 30.0, left: 30.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              width: MediaQuery.of(context).size.width,
              height: 120,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0XFFFFCD00),
                        Color(0XFFFFC900),
                      ]),
                  borderRadius: BorderRadius.circular(40.0)),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: AssetImage("assets/icons/totorders.png"),
                            width: 50.0,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            "5",
                            style: titleText.copyWith(
                              fontSize: 50.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        "COMPLETED ORDERS",
                        style: titleText.copyWith(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FlatButton(
                  splashColor: Color(0XFFFF5500),
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return RequestsList();
                        },
                      ),
                    );
                  },

                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0)),
                  padding: const EdgeInsets.all(0.0),
                  child: Ink(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0XFFFF7000),
                            Color(0XFFFF5500),
                          ]),
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 30.0),
                      constraints:
                          const BoxConstraints(minWidth: 88.0, minHeight: 36.0),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: AssetImage("assets/icons/reqplacepickup.png"),
                            width: 60.0,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            "PICKUP\nREQUESTS",
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

                FlatButton(
                  splashColor: Color(0XFFF30021),
                  highlightColor: Colors.transparent,
                  onPressed: () {
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
                      borderRadius: BorderRadius.circular(40.0)),
                  padding: const EdgeInsets.all(0.0),
                  child: Ink(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0XFFFF0049),
                            Color(0XFFFF0023),
                          ]),
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 25.0,horizontal: 30.0),
                      constraints:
                      const BoxConstraints(minWidth: 88.0, minHeight: 36.0),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check,
                            size: 50.0,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            "ACCEPTED\nREQUESTS",
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

            SizedBox(
              height: 40.0,
            ),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Recent Jobs",
                  style: textBoxText.copyWith(fontSize: 18.0),
                  textAlign: TextAlign.start,
                ),
              ],
            ),

            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('order_requests')
                    .snapshots(),
                builder: (_, snapshot) {
                  if (snapshot.hasError) return Text('Error = ${snapshot.error}');

                  if (snapshot.hasData) {
                    final docs = snapshot.data.docs;

                    return ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (_, i) {
                        final dataa = docs[i].data();

                        print(snapshot.data.docs.elementAt(i).id);
                        return Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          child: FlatButton(
                            splashColor: Color(0XFFFFF2E5),
                            highlightColor: Colors.transparent,
                            onPressed: () {

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
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
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
      ),
    );
  }
}
