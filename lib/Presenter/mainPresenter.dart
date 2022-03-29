import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pickngo/Models/CompleteDelivery.dart';
import 'package:pickngo/Models/Users.dart';
import 'package:pickngo/Models/VehicleTracking.dart';
import 'package:pickngo/Models/database.dart';
import 'package:pickngo/Models/order_pickup.dart';
import 'package:pickngo/Models/order_requests.dart';
import 'package:pickngo/dashboard.dart';
import 'package:pickngo/login.dart';


class Presenter {

  Database _database=new Database();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  void login (String email,String password,context) async {

    try{
      QuerySnapshot _myDoc=await firestore.collection('employee_data').where('empType', isEqualTo: "Rider").get();
      List<DocumentSnapshot> _myDocCount = _myDoc.docs;

      if(_myDocCount.length>0) {
        final user = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        if (user != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return Dashboard();
              },
            ),
          );
        }
      }
      else{
        String error="Please enter a valid user credentials";
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error),
          backgroundColor: Colors.red,
        ));
      }


    }
    on FirebaseAuthException catch (e){

      String error="Error while login. Please try again.";
      if(e.code.toString()=="invalid-email"){
        error="Please enter a valid email address";
      }
      else if(e.code.toString()=="user-not-found"){
        error="The email you entered is incorrect. Please try again.";
      }
      else if(e.code.toString()=="wrong-password"){
        error="The password you entered is incorrect. Please try again.";
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error),
        backgroundColor: Colors.red,
      ));
      print(e.code.toString());
    }
  }

  void countDocuments() async {
// Count of Documents in Collection
  }

  Future<void> addTracking(String reqid,bool Accepted,bool Collected,bool InSortingCenter, bool InTransist,bool ArrivedAtWarehouse,bool Delivered) async {
    VehicleTracking tracking=VehicleTracking(
      Accepted: Accepted,
      Collected: Collected,
      InSortingCenter: InSortingCenter,
      InTransist: InTransist,
      ArrivedAtWarehouse: ArrivedAtWarehouse,
      Delivered: Delivered
    );
    await _database.addTracking(tracking,reqid);
  }

  Future<void> updateTracking(String reqid,bool Accepted,bool Collected,bool InSortingCenter, bool InTransist,bool ArrivedAtWarehouse,bool Delivered) async {
    VehicleTracking tracking=VehicleTracking(
        Accepted: Accepted,
        Collected: Collected,
        InSortingCenter: InSortingCenter,
        InTransist: InTransist,
        ArrivedAtWarehouse: ArrivedAtWarehouse,
        Delivered: Delivered
    );
    await _database.updateTracking(tracking,reqid);
  }

  Future<void> addCompleteDelivery(String reqid,String imgURL) async {

    CompleteDelivery completeDelivery=CompleteDelivery(
      imgURL: imgURL
    );


    await _database.addCompleteDelivery(completeDelivery,reqid);
  }


  void updateStatus(String reqid,String status) async{
    firestore.collection('order_requests').doc(reqid).update({'request_status':status});
  }

  void updateSchedule(String reqid,String scheduleTime) async{
    firestore.collection('order_requests').doc(reqid).update({'shedule_time': scheduleTime});
  }


  Future<void> pickupOrder(String req_id, String employee_id, String customer_id,String pic_status, String pic_date, String pic_time) async {
    OrderPickup orderPickup=OrderPickup(
      req_id: req_id,
      employee_id: employee_id,
      customer_id: customer_id,
      pic_status: pic_status,
      pic_date: pic_date,
      pic_time: pic_time
    );

    await _database.addPickupOrder(orderPickup,req_id);
  }

  Future<void> updatePickup(String reqid,String pic_status, String pic_date, String pic_time) async {
    OrderPickup orderPickup=OrderPickup(
        pic_status: pic_status,
        pic_date: pic_date,
        pic_time: pic_time
    );

    await _database.updatePickup(orderPickup,reqid);
  }


  void placeRequest(String customer_id,String customer_live_address,String customer_live_servicearea, String customer_live_latitude,String customer_live_longitude,String receiver_name, String receiver_city, String receiver_city_id, String receiver_address, String receiver_contact, String receiver_type, String shedule_time, String request_status, String request_date, request_time) async{
    OrderRequests orderRequests = OrderRequests(
      customer_id: customer_id,
      customer_live_address: customer_live_address,
      customer_live_servicearea: customer_live_servicearea,
      customer_live_latitude: customer_live_latitude,
      customer_live_longitude: customer_live_longitude,
      receiver_name: receiver_name,
      receiver_city: receiver_city,
      receiver_city_id: receiver_city_id,
      receiver_address: receiver_address,
      receiver_contact: receiver_contact,
      receiver_type: receiver_type,
      shedule_time: shedule_time,
      request_status: request_status,
      request_date: request_date,
      request_time: request_time
    );
    await _database.addOrderRequest(orderRequests);
  }


  void register(String email,String fullName,String userName,String nicNumber,String contactNumber,String password,context) async {
    User user;
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
      await user.updateProfile(displayName: fullName,photoURL: "Testt.com");
      await user.reload();
      user = _auth.currentUser;
      print(user.uid);

      Users users = Users(
        CustomerEmail: email,
        CustomerName: fullName,
        CustomerUserName: userName,
        CustomerNIC: nicNumber,
        CustomerContact: contactNumber,
        CustomerPassword: password,
      );

      await _database.addUser(users,user.uid);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return LoginPage();
          },
        ),
      );

    } on FirebaseAuthException catch (e) {

      String error=e.toString();
      if (e.code == 'weak-password') {
        error="The password provided is too weak";
      } else if (e.code == 'email-already-in-use') {
        error="The account already exists for that email";
      }
      else if(e.code == 'invalid-email'){
        error="The email provided is invalid. Please enter valid email & try again.";
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error),
        backgroundColor: Colors.red,
      ));

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));
    }

  }

}