import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:jomsports/services/listing_service_firebase.dart';
import 'package:jomsports/services/storage_service_firebase.dart';
import 'package:jomsports/shared/constant/listing_type.dart';
import 'package:jomsports/shared/constant/storage_destination.dart';

class Listing {
  String listingID;
  String userID;
  ListingType listingType;
  String? listingPictureUrl;

  Listing(
      {required this.listingID,
      required this.userID,
      required this.listingType});

  Map<String, dynamic> toListingJson() => {
        'userID': userID,
        'listingType': listingType.name,
      };

  Listing.fromListingJson(String listingID, Map<String, dynamic>? json)
      : this(
          listingID: listingID,
          listingType: ListingType.values.byName(json?['listingType']),
          userID: json?['userID'],
        );

  Future createListing(XFile listingPictureXFile) async {
    ListingServiceFirebase listingServiceFirebase = ListingServiceFirebase();

    listingID = await listingServiceFirebase.createListing(this);

    //picture
    if (listingPictureXFile.path.isNotEmpty) {
      File listingPic = File(listingPictureXFile.path);
      StorageServiceFirebase storageServiceFirebase = StorageServiceFirebase();
      await storageServiceFirebase.uploadFile(
          StorageDestination.listingPic, listingID, listingPic);
    }
  }

  Future<String> getListingPicUrl() async {
    StorageServiceFirebase storageServiceFirebase = StorageServiceFirebase();
    listingPictureUrl = await storageServiceFirebase.getImage(
        StorageDestination.listingPic, listingID);
    return listingPictureUrl ?? '';
  }

  Future editListing(XFile listingPictureXFile) async {
    if (listingPictureXFile.path.isNotEmpty) {
      File listingPic = File(listingPictureXFile.path);
      StorageServiceFirebase storageServiceFirebase = StorageServiceFirebase();
      await storageServiceFirebase.uploadFile(
          StorageDestination.listingPic, listingID, listingPic);
    }
  }

  Future deleteListing() async{
    StorageServiceFirebase storageServiceFirebase = StorageServiceFirebase();
      await storageServiceFirebase.deleteFile(StorageDestination.listingPic, listingID);
    ListingServiceFirebase listingServiceFirebase = ListingServiceFirebase();
    return await listingServiceFirebase.deleteListing(listingID);
  }
}
