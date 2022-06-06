import 'package:geocoding/geocoding.dart';

class GetLocation {
  start(String live) async {
    List<Location> locations = await locationFromAddress(live);
    String start = locations[0].toString().substring(15, 32);
    var start_list = start.split(",");
    return double.parse(start_list[0].toString());
  }

  end(String live) async {
    List<Location> locations = await locationFromAddress(live);
    String end = locations[0].toString().substring(43);
    var end_list = end.split(",");
    return double.parse(end_list[0].toString());
  }

  marker(String live) {
    double start_list = start(live);
    double end_list = end(live);
    print(start_list);
    print(end_list);
  }
}
