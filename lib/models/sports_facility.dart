import 'package:image_picker/image_picker.dart';
import 'package:jomsports/models/listing.dart';
import 'package:jomsports/services/listing_service_firebase.dart';
import 'package:jomsports/shared/constant/listing_type.dart';

class SportsFacility extends Listing {
  String facilityName;
  String description;
  List<OperatingHour> operatingHourList;

  SportsFacility({
    required String listingID,
    required String userID,
    required ListingType listingType,
    required this.facilityName,
    required this.description,
    required this.operatingHourList,
  }) : super(listingID: listingID, userID: userID, listingType: listingType);

  Map<String, dynamic> toJson() => {
        'facilityName': facilityName,
        'description': description,
        'operatingHourList': operatingHourList.map((e) => {
              'openHour': e.openHour,
              'closeHour': e.closeHour,
            })
      };

  SportsFacility.fromJson(Map<String, dynamic>? json, Listing listing)
      : this(
            listingID: listing.listingID,
            listingType: listing.listingType,
            userID: listing.userID,
            facilityName: json?['facilityName'],
            description: json?['description'],
            operatingHourList: json?['operatingHourList']
                .map<OperatingHour>(
                    (e) => OperatingHour(e['openHour'], e['closeHour']))
                .toList());

  @override
  Future createListing(XFile listingPictureXFile) async {
    await super.createListing(listingPictureXFile);

    ListingServiceFirebase listingServiceFirebase = ListingServiceFirebase();
    return await listingServiceFirebase.createSF(this);
  }

  static Stream<List<SportsFacility>> getSFList(String userID) {
    ListingServiceFirebase listingServiceFirebase = ListingServiceFirebase();
    return listingServiceFirebase.getSFList(userID);
  }

  static Future<SportsFacility?> getListing(String listingID) async {
    ListingServiceFirebase listingServiceFirebase = ListingServiceFirebase();
    Listing listing = await listingServiceFirebase.getListing(listingID);
    return await listingServiceFirebase.getSF(listing);
  }

  @override
  Future editListing(XFile listingPictureXFile) async {
    await super.editListing(listingPictureXFile);
    ListingServiceFirebase listingServiceFirebase = ListingServiceFirebase();
    return await listingServiceFirebase.editSF(this);
  }

  @override
  Future deleteListing()async{
    await super.deleteListing();
    ListingServiceFirebase listingServiceFirebase = ListingServiceFirebase();
    return await listingServiceFirebase.deleteSF(listingID);
  }

  static Future getSportsFacilityName(String listingID) async{
    ListingServiceFirebase listingServiceFirebase = ListingServiceFirebase();
    return await listingServiceFirebase.getSportsFacilityName(listingID);
  }
}

class OperatingHour {
  int openHour;
  int closeHour;
  OperatingHour(this.openHour, this.closeHour);
}
