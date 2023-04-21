import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/shared/constant/map.dart';
import 'package:jomsports/shared/dialog/dialog.dart';
import 'package:map_location_picker/map_location_picker.dart';

class SharedMapLocationPicker extends StatelessWidget {
  SharedMapLocationPicker(
      {super.key,
      this.widgetHeight = 500,
      this.currentLat = MapConstant.defaultLat,
      this.currentLon = MapConstant.defaultLon,
      required this.onPickLocation});

  RxDouble lat = RxDouble(0);
  RxDouble lon = RxDouble(0);
  RxString address = RxString('');
  final double widgetHeight;
  final double currentLat;
  final double currentLon;
  Function(String address, double lat, double lon) onPickLocation;

  @override
  Widget build(BuildContext context) {
    lat.value = currentLat;
    lon.value = currentLon;
    return SizedBox(
      height: widgetHeight,
      child: MapLocationPicker(
        apiKey: MapConstant.GOOGLE_API_KEY,
        region: 'my',
        minMaxZoomPreference: MinMaxZoomPreference.unbounded,
        currentLatLng: LatLng(currentLat, currentLon),
        canPopOnNextButtonTaped: false,
        searchHintText: 'Search location',
        bottomCardIcon: const Icon(Icons.add_location),
        onNext: (GeocodingResult? result) {
          if (result != null) {
            //select de
            address.value = result.formattedAddress ?? '';
            lat.value = result.geometry.location.lat;
            lon.value = result.geometry.location.lng;
            onPickLocation(address.value,lat.value,lon.value);
          } else {
            SharedDialog.alertDialog(
                'Operation Failed', 'Please tap on a valid place');
          }
        },
        onSuggestionSelected: (PlacesDetailsResponse? result) {
          if (result != null) {
            //search de
            address.value = '${result.result.name},';
            address.value += result.result.formattedAddress ?? '';
            lat.value = result.result.geometry?.location.lat ?? lat.value;
            lon.value = result.result.geometry?.location.lng ?? lon.value;
            onPickLocation(address.value,lat.value,lon.value);
          }
        },
      ),
    );
  }
}
