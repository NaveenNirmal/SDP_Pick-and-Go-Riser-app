class Users {
  final String CustomerEmail;
  final String CustomerName;
  final String CustomerNIC;
  final String CustomerContact;
  final String CustomerUserName;
  final String CustomerPassword;

  Users({this.CustomerEmail, this.CustomerName, this.CustomerNIC,this.CustomerContact,this.CustomerUserName,this.CustomerPassword});


  Map<String,dynamic>toMap(){
    return {
      'CustomerEmail':CustomerEmail,
      'CustomerName':CustomerName,
      'CustomerUserName':CustomerUserName,
      'CustomerNIC':CustomerNIC,
      'CustomerContact':CustomerContact,
      'CustomerPassword':CustomerPassword};
  }
}
