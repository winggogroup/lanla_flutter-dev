import 'package:geolocator/geolocator.dart';

Future<Position> GetLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  print('位置1');
  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }
  print('位置2');

  permission = await Geolocator.checkPermission();
  print('位置3');
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }
  print('位置4');

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }
  print('获取最后位置');
  Position? position = await Geolocator.getLastKnownPosition();
  if(position != null){
    return position;
  }
  print(await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best));
  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
}
