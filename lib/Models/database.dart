import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pickngo/Models/Users.dart';
import 'package:pickngo/Models/VehicleTracking.dart';
import 'package:pickngo/Models/order_pickup.dart';
import 'package:pickngo/Models/order_requests.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;

class Database {
  Future<void> addUser(Users users,String userid) async {
    var userdata = users.toMap();

    await _firestore.collection('customer').doc(userid).set(userdata);
  }
  Future<void>addTracking(VehicleTracking vehicleTracking, String trackingid) async{
    var tracking=vehicleTracking.toMap();
    await _firestore.collection('tracking').doc(trackingid).set(tracking);
  }

  Future<void>updateTracking(VehicleTracking vehicleTracking,String reqid) async{
    var tracking=vehicleTracking.toMap();
    await FirebaseFirestore.instance.collection('tracking').doc(reqid).update(tracking);
  }
  Future<void>updatePickup(OrderPickup orderPickup,String reqid) async{
    await FirebaseFirestore.instance.collection('order_pickup').doc(reqid).update({'pic_date': orderPickup.pic_date,'pic_time':orderPickup.pic_time,'pic_status':orderPickup.pic_status});


  }


  Future<void>addPickupOrder(OrderPickup orderPickup, String pickupid) async{
    var orderpick=orderPickup.toMap();
    await _firestore.collection('order_pickup').doc(pickupid).set(orderpick);
  }

  Future<void>addOrderRequest(OrderRequests ordReq) async{
    var orderReq=ordReq.toMap();

    await _firestore.collection('order_requests').add(orderReq);
  }
}