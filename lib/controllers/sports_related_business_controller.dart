import 'package:get/get.dart';
import 'package:jomsports/controllers/listing_controller.dart';
import 'package:jomsports/models/sports_related_business.dart';
import 'package:jomsports/services/map_location_picker_service.dart';
import 'package:jomsports/shared/constant/map.dart';
import 'package:jomsports/shared/dialog/dialog.dart';
import 'package:jomsports/views/sports_related_business/view_sports_related_business/view_sports_related_business_page.dart';
import 'package:map_location_picker/map_location_picker.dart';

class SportsRelatedBusinessController extends GetxController {
  //sports shop map
  RxDouble lat = RxDouble(0);
  RxDouble lon = RxDouble(0);
  Future initMap() async {
    MapLocationPickerService geolocatorService = MapLocationPickerService();
    Position? position = await geolocatorService.determinePosition();
    if (position != null) {
      lat.value = position.latitude;
      lon.value = position.longitude;
    } else {
      lat.value = MapConstant.defaultLat;
      lon.value = MapConstant.defaultLon;
    }
  }

  Stream<List<Marker>> getSportsActivityMarkerList(
      {required Function(SportsRelatedBusiness) onTap, bool isSFOnly = false}) {
    return SportsRelatedBusiness.getSportsRelatedBusinessMarkerList(
        lat: lat.value, lon: lon.value, onTap: onTap, isSFOnly: isSFOnly);
  }

  //view srb
  SportsRelatedBusiness? selectedSRB;
  bool initSRB(SportsRelatedBusiness sportsRelatedBusiness) {
    selectedSRB = sportsRelatedBusiness;
    if (selectedSRB == null) {
      SharedDialog.errorDialog();
      Get.back();
      return false;
    } else {
      final ListingController listingController =
          Get.put(tag: 'listingController', ListingController());
      listingController.initSportsRelatedBusiness(selectedSRB!.userID);
      return true;
    }
  }
}
