import 'dart:ffi';

class VehicleTracking {
  final bool Accepted;
  final bool Collected;
  final bool InSortingCenter;
  final bool InTransist;
  final bool ArrivedAtWarehouse;
  final bool Delivered;


  VehicleTracking(
      {this.Accepted,this.Collected, this.InSortingCenter, this.InTransist, this.ArrivedAtWarehouse, this.Delivered});


  Map<String, dynamic> toMap() {
    return {
      'Accepted': Accepted,
      'Collected':Collected,
      'InSortingCenter': InSortingCenter,
      'InTransist': InTransist,
      'ArrivedAtWarehouse': ArrivedAtWarehouse,
      'Delivered': Delivered,
    };
  }

}