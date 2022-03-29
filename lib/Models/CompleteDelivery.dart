class CompleteDelivery {
  final String imgURL;

  CompleteDelivery(
      {this.imgURL});


  Map<String, dynamic> toMap() {
    return {
      'ImageURL': imgURL,
      'Status':'Delivered'
    };
  }

}