/// html_attributions : []
/// result : {"geometry":{"location":{"lat":-33.866489,"lng":151.1958561},"viewport":{"northeast":{"lat":-33.8655112697085,"lng":151.1971156302915},"southwest":{"lat":-33.86820923029149,"lng":151.1944176697085}}}}
/// status : "OK"

class PlaceDetails {
  PlaceDetails({
      List<dynamic>? htmlAttributions, 
      Result? result, 
      String? status,}){
    _htmlAttributions = htmlAttributions;
    _result = result;
    _status = status;
}

  PlaceDetails.fromJson(dynamic json) {
    if (json['html_attributions'] != null) {
      _htmlAttributions = [];
      json['html_attributions'].forEach((v) {
    //    _htmlAttributions?.add(Dynamic.fromJson(v));
      });
    }
    _result = json['result'] != null ? Result.fromJson(json['result']) : null;
    _status = json['status'];
  }
  List<dynamic>? _htmlAttributions;
  Result? _result;
  String? _status;
PlaceDetails copyWith({  List<dynamic>? htmlAttributions,
  Result? result,
  String? status,
}) => PlaceDetails(  htmlAttributions: htmlAttributions ?? _htmlAttributions,
  result: result ?? _result,
  status: status ?? _status,
);
  List<dynamic>? get htmlAttributions => _htmlAttributions;
  Result? get result => _result;
  String? get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_htmlAttributions != null) {
      map['html_attributions'] = _htmlAttributions?.map((v) => v.toJson()).toList();
    }
    if (_result != null) {
      map['result'] = _result?.toJson();
    }
    map['status'] = _status;
    return map;
  }

}

/// geometry : {"location":{"lat":-33.866489,"lng":151.1958561},"viewport":{"northeast":{"lat":-33.8655112697085,"lng":151.1971156302915},"southwest":{"lat":-33.86820923029149,"lng":151.1944176697085}}}

class Result {
  Result({
      Geometry? geometry,}){
    _geometry = geometry;
}

  Result.fromJson(dynamic json) {
    _geometry = json['geometry'] != null ? Geometry.fromJson(json['geometry']) : null;
  }
  Geometry? _geometry;
Result copyWith({  Geometry? geometry,
}) => Result(  geometry: geometry ?? _geometry,
);
  Geometry? get geometry => _geometry;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_geometry != null) {
      map['geometry'] = _geometry?.toJson();
    }
    return map;
  }

}

/// location : {"lat":-33.866489,"lng":151.1958561}
/// viewport : {"northeast":{"lat":-33.8655112697085,"lng":151.1971156302915},"southwest":{"lat":-33.86820923029149,"lng":151.1944176697085}}

class Geometry {
  Geometry({
      Location? location, 
      Viewport? viewport,}){
    _location = location;
    _viewport = viewport;
}

  Geometry.fromJson(dynamic json) {
    _location = json['location'] != null ? Location.fromJson(json['location']) : null;
    _viewport = json['viewport'] != null ? Viewport.fromJson(json['viewport']) : null;
  }
  Location? _location;
  Viewport? _viewport;
Geometry copyWith({  Location? location,
  Viewport? viewport,
}) => Geometry(  location: location ?? _location,
  viewport: viewport ?? _viewport,
);
  Location? get location => _location;
  Viewport? get viewport => _viewport;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_location != null) {
      map['location'] = _location?.toJson();
    }
    if (_viewport != null) {
      map['viewport'] = _viewport?.toJson();
    }
    return map;
  }

}

/// northeast : {"lat":-33.8655112697085,"lng":151.1971156302915}
/// southwest : {"lat":-33.86820923029149,"lng":151.1944176697085}

class Viewport {
  Viewport({
      Northeast? northeast, 
      Southwest? southwest,}){
    _northeast = northeast;
    _southwest = southwest;
}

  Viewport.fromJson(dynamic json) {
    _northeast = json['northeast'] != null ? Northeast.fromJson(json['northeast']) : null;
    _southwest = json['southwest'] != null ? Southwest.fromJson(json['southwest']) : null;
  }
  Northeast? _northeast;
  Southwest? _southwest;
Viewport copyWith({  Northeast? northeast,
  Southwest? southwest,
}) => Viewport(  northeast: northeast ?? _northeast,
  southwest: southwest ?? _southwest,
);
  Northeast? get northeast => _northeast;
  Southwest? get southwest => _southwest;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_northeast != null) {
      map['northeast'] = _northeast?.toJson();
    }
    if (_southwest != null) {
      map['southwest'] = _southwest?.toJson();
    }
    return map;
  }

}

/// lat : -33.86820923029149
/// lng : 151.1944176697085

class Southwest {
  Southwest({
      double? lat, 
      double? lng,}){
    _lat = lat;
    _lng = lng;
}

  Southwest.fromJson(dynamic json) {
    _lat = json['lat'];
    _lng = json['lng'];
  }
  double? _lat;
  double? _lng;
Southwest copyWith({  double? lat,
  double? lng,
}) => Southwest(  lat: lat ?? _lat,
  lng: lng ?? _lng,
);
  double? get lat => _lat;
  double? get lng => _lng;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['lat'] = _lat;
    map['lng'] = _lng;
    return map;
  }

}

/// lat : -33.8655112697085
/// lng : 151.1971156302915

class Northeast {
  Northeast({
      double? lat, 
      double? lng,}){
    _lat = lat;
    _lng = lng;
}

  Northeast.fromJson(dynamic json) {
    _lat = json['lat'];
    _lng = json['lng'];
  }
  double? _lat;
  double? _lng;
Northeast copyWith({  double? lat,
  double? lng,
}) => Northeast(  lat: lat ?? _lat,
  lng: lng ?? _lng,
);
  double? get lat => _lat;
  double? get lng => _lng;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['lat'] = _lat;
    map['lng'] = _lng;
    return map;
  }

}

/// lat : -33.866489
/// lng : 151.1958561

class Location {
  Location({
      double? lat, 
      double? lng,}){
    _lat = lat;
    _lng = lng;
}

  Location.fromJson(dynamic json) {
    _lat = json['lat'];
    _lng = json['lng'];
  }
  double? _lat;
  double? _lng;
Location copyWith({  double? lat,
  double? lng,
}) => Location(  lat: lat ?? _lat,
  lng: lng ?? _lng,
);
  double? get lat => _lat;
  double? get lng => _lng;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['lat'] = _lat;
    map['lng'] = _lng;
    return map;
  }

}