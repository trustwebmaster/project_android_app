class Pharmacy {
  String id;
  String name;
  String lat;
  String long;
  String address;


  Pharmacy({this.id, this.name, this.lat, this.long, this.address});

  factory Pharmacy.fromJson(Map<String, dynamic> json) {
    return Pharmacy(
      id: json['id'] as String,
      name: json['name'] as String,
      lat: json['lat'] as String,
      long: json['long'] as String,
      address: json['address'] as String,
    );
  }
}
