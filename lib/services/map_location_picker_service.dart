import 'package:jomsports/shared/dialog/dialog.dart';
import 'package:map_location_picker/map_location_picker.dart';

class MapLocationPickerService {
  Future<Position?> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission = await Geolocator.requestPermission();

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      SharedDialog.alertDialog('Location services are disabled.',
          'Please enable the location services to have a better experience to JomSports.');
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        SharedDialog.alertDialog('Location permissions are denied',
            'Please allow the location permission in the setting to have a better experience to JomSports.');
            return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      SharedDialog.alertDialog(
          'Location permissions are permanently denied, we cannot request permissions.',
          'Please allow the location permission in the setting to have a better experience to JomSports.');
          return null;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
