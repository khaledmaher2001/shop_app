class LoginModel{
bool? status;
String? message;
DataModel? data;

LoginModel.fromJson(Map<String,dynamic> json){
  status =json['status'];
  message =json['message'];
  data = json['data'] != null ? DataModel.fromJson(json['data']) : null;
}

}
class DataModel{
  int? id;
  String?name;
  String?email;
  String?phone;
  String?image;
  String?token;
  int? points;
  int? credit;
  DataModel.fromJson(Map<String,dynamic> json){
    id=json['id'];
    name=json['name'];
    email=json['email'];
    phone=json['phone'];
    image=json['image'];
    token=json['token'];
    points=json['points'];
    credit=json['credit'];
  }

}
