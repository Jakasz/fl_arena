class IpCallModel {
  int? ipVersion;
  String? ipAddress;
  double? latitude;
  double? longitude;
  String? countryName;
  String? countryCode;
  String? timeZone;
  String? zipCode;
  String? cityName;
  String? regionName;
  bool? isProxy;
  String? continent;
  String? continentCode;

  IpCallModel(
      {this.ipVersion,
      this.ipAddress,
      this.latitude,
      this.longitude,
      this.countryName,
      this.countryCode,
      this.timeZone,
      this.zipCode,
      this.cityName,
      this.regionName,
      this.isProxy,
      this.continent,
      this.continentCode});

  IpCallModel.fromJson(Map<String, dynamic> json) {
    ipVersion = json['ipVersion'];
    ipAddress = json['ipAddress'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    countryName = json['countryName'];
    countryCode = json['countryCode'];
    timeZone = json['timeZone'];
    zipCode = json['zipCode'];
    cityName = json['cityName'];
    regionName = json['regionName'];
    isProxy = json['isProxy'];
    continent = json['continent'];
    continentCode = json['continentCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ipVersion'] = ipVersion;
    data['ipAddress'] = ipAddress;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['countryName'] = countryName;
    data['countryCode'] = countryCode;
    data['timeZone'] = timeZone;
    data['zipCode'] = zipCode;
    data['cityName'] = cityName;
    data['regionName'] = regionName;
    data['isProxy'] = isProxy;
    data['continent'] = continent;
    data['continentCode'] = continentCode;
    return data;
  }
}
