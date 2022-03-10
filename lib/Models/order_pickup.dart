class OrderPickup {
  final String req_id;
  final String employee_id;
  final String customer_id;
  final String pic_status;
  final String pic_date;
  final String pic_time;


  OrderPickup(
      {this.req_id, this.employee_id,this.customer_id, this.pic_status, this.pic_date,this.pic_time});


  Map<String, dynamic> toMap() {
    return {
      'req_id': req_id,
      'employee_id': employee_id,
      'customer_id':customer_id,
      'pic_status': pic_status,
      'pic_date': pic_date,
      'pic_time':pic_time,
    };
  }

}