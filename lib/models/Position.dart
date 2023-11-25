class Position {
  Position({
    required this.status,
    required this.country,
    required this.countryCode,
    required this.region,
    required this.regionName,
    required this.city,
    required this.zip,
    required this.lat,
    required this.lon,
    required this.timezone,
    required this.isp,
    required this.org,
    required this.as,
    required this.query,});

   Position.fromJson(dynamic json) {
    status = json['status'];
    country = json['country'];
    countryCode = json['countryCode'];
    region = json['region'];
    regionName = json['regionName'];
    city = json['city'];
    zip = json['zip'];
    lat = json['lat'];
    lon = json['lon'];
    timezone = json['timezone'];
    isp = json['isp'];
    org = json['org'];
    as = json['as'];
    query = json['query'];
  }
  late String status;
  late String country;
  late String countryCode;
  late String region;
  late String regionName;
  late String city;
  late String zip;
  late double lat;
  late double lon;
  late String timezone;
  late String isp;
  late String org;
  late String as;
  late String query;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['country'] = country;
    map['countryCode'] = countryCode;
    map['region'] = region;
    map['regionName'] = regionName;
    map['city'] = city;
    map['zip'] = zip;
    map['lat'] = lat;
    map['lon'] = lon;
    map['timezone'] = timezone;
    map['isp'] = isp;
    map['org'] = org;
    map['as'] = as;
    map['query'] = query;
    return map;
  }

}