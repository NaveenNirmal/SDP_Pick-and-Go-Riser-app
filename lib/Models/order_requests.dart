import 'package:cloud_firestore/cloud_firestore.dart';

class OrderRequests {
  final String customer_id;
  final String customer_live_address;
  final String customer_live_servicearea;
  final String customer_live_latitude;
  final String customer_live_longitude;
  final String receiver_name;
  final String receiver_city;
  final String receiver_city_id;
  final String receiver_address;
  final String receiver_contact;
  final String receiver_type;
  final String shedule_time;
  final String request_status;
  final String request_date;
  final String request_time;

  OrderRequests({this.customer_id, this.customer_live_address, this.customer_live_servicearea, this.customer_live_latitude, this.customer_live_longitude, this.shedule_time,this.receiver_name, this.receiver_city,this.receiver_city_id,this.receiver_address, this.receiver_contact,this.receiver_type,this.request_status,this.request_date,this.request_time});

  Map<String,dynamic>toMap(){
    return {
      'customer_id':customer_id,
      'customer_live_address':customer_live_address,
      'customer_live_servicearea':customer_live_servicearea,
      'customer_live_latitude':customer_live_latitude,
      'customer_live_longitude':customer_live_longitude,
      'receiver_name':receiver_name,
      'receiver_city':receiver_city,
      'receiver_city_id':receiver_city_id,
      'receiver_address':receiver_address,
      'receiver_contact':receiver_contact,
      'receiver_type':receiver_type,
      'shedule_time':shedule_time,
      'request_status':request_status,
      'request_date':request_date,
      'request_time':request_time,
      'reqest_time_stamp':Timestamp.now()
    };
  }
}
