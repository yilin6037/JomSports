import 'package:image_picker/image_picker.dart';
import 'package:jomsports/models/listing.dart';
import 'package:jomsports/services/listing_service_firebase.dart';
import 'package:jomsports/shared/constant/listing_type.dart';

class Item extends Listing {
  String itemName;
  String description;
  bool availability;

  Item(
      {required String listingID,
      required String userID,
      required ListingType listingType,
      required this.itemName,
      required this.description,
      required this.availability})
      : super(listingID: listingID, userID: userID, listingType: listingType);

  Map<String, dynamic> toJson() => {
        'itemName': itemName,
        'description': description,
        'availability': availability,
      };

  Item.fromJson(Map<String, dynamic>? json, Listing listing)
      : this(
          listingID: listing.listingID,
          listingType: listing.listingType,
          userID: listing.userID,
          itemName: json?['itemName'],
          description: json?['description'],
          availability: json?['availability'],
        );

  @override
  Future createListing(XFile listingPictureXFile) async {
    await super.createListing(listingPictureXFile);

    ListingServiceFirebase listingServiceFirebase = ListingServiceFirebase();
    return await listingServiceFirebase.createItem(this);
  }

  static Stream<List<Item>> getItemList(String userID) {
    ListingServiceFirebase listingServiceFirebase = ListingServiceFirebase();
    return listingServiceFirebase.getItemList(userID);
  }

  static Future<Item?> getListing(String listingID) async {
    ListingServiceFirebase listingServiceFirebase = ListingServiceFirebase();
    Listing listing = await listingServiceFirebase.getListing(listingID);
    return await listingServiceFirebase.getItem(listing);
  }

  @override
  Future editListing(XFile listingPictureXFile) async {
    await super.editListing(listingPictureXFile);
    ListingServiceFirebase listingServiceFirebase = ListingServiceFirebase();
    return await listingServiceFirebase.editItem(this);
  }

  @override
  Future deleteListing() async{
    await super.deleteListing();
    ListingServiceFirebase listingServiceFirebase = ListingServiceFirebase();
    return await listingServiceFirebase.deleteItem(listingID);
  }
}
