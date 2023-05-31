import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jomsports/models/appointment.dart';
import 'package:jomsports/models/item.dart';
import 'package:jomsports/models/listing.dart';
import 'package:jomsports/models/slot_unavailable.dart';
import 'package:jomsports/models/sports_facility.dart';
import 'package:jomsports/services/sports_related_business_service_firebase.dart';
import 'package:jomsports/shared/constant/firestore.dart';
import 'package:jomsports/shared/constant/listing_type.dart';

class ListingServiceFirebase {
  final firestoreInstance = FirebaseFirestore.instance;

  Future<String> createListing(Listing listing) async {
    return await firestoreInstance
        .collection(FirestoreCollectionConstant.listing)
        .add(listing.toListingJson())
        .then((value) => value.id);
  }

  Future createItem(Item item) async {
    return await firestoreInstance
        .collection(FirestoreCollectionConstant.item)
        .doc(item.listingID)
        .set(item.toJson());
  }

  Future createSF(SportsFacility sportsFacility) async {
    return await firestoreInstance
        .collection(FirestoreCollectionConstant.sportsFacility)
        .doc(sportsFacility.listingID)
        .set(sportsFacility.toJson());
  }

  Stream<List<Item>> getItemList(String userID) {
    return firestoreInstance
        .collection(FirestoreCollectionConstant.listing)
        .where('userID', isEqualTo: userID)
        .snapshots()
        .asyncMap((snapshot) async {
      List<Item> itemList = [];
      for (var doc in snapshot.docs) {
        if (doc.data()['listingType'] == ListingType.item.name) {
          Item? item =
              await getItem(Listing.fromListingJson(doc.id, doc.data()));
          if (item != null) {
            await item.getListingPicUrl();
            itemList.add(item);
          }
        }
      }
      return itemList;
    });
  }

  Future<Item?> getItem(Listing listing) async {
    final snapshot = await firestoreInstance
        .collection(FirestoreCollectionConstant.item)
        .doc(listing.listingID)
        .get();
    if (snapshot.exists) {
      return Item.fromJson(snapshot.data(), listing);
    } else {
      return null;
    }
  }

  Stream<List<SportsFacility>> getSFList(String userID) {
    return firestoreInstance
        .collection(FirestoreCollectionConstant.listing)
        .where('userID', isEqualTo: userID)
        .snapshots()
        .asyncMap((snapshot) async {
      List<SportsFacility> sportsFacilityList = [];
      for (var doc in snapshot.docs) {
        if (doc.data()['listingType'] == ListingType.facility.name) {
          SportsFacility? sportsFacility =
              await getSF(Listing.fromListingJson(doc.id, doc.data()));
          if (sportsFacility != null) {
            await sportsFacility.getListingPicUrl();
            sportsFacilityList.add(sportsFacility);
          }
        }
      }
      return sportsFacilityList;
    });
  }

  Future<List<SportsFacility>> readSportsFacilityList(String userID) async {
    final snapshot = await firestoreInstance
        .collection(FirestoreCollectionConstant.listing)
        .where('userID', isEqualTo: userID)
        .get();

    List<SportsFacility> sportsFacilityList = [];
    for (var doc in snapshot.docs) {
      if (doc.data()['listingType'] == ListingType.facility.name) {
        SportsFacility? sportsFacility =
            await getSF(Listing.fromListingJson(doc.id, doc.data()));
        if (sportsFacility != null) {
          await sportsFacility.getListingPicUrl();
          sportsFacilityList.add(sportsFacility);
        }
      }
    }
    return sportsFacilityList;
  }

  Future<SportsFacility?> getSF(Listing listing) async {
    final snapshot = await firestoreInstance
        .collection(FirestoreCollectionConstant.sportsFacility)
        .doc(listing.listingID)
        .get();

    if (snapshot.exists) {
      return SportsFacility.fromJson(snapshot.data(), listing);
    } else {
      return null;
    }
  }

  Future<Listing> getListing(String listingID) async {
    final snapshot = await firestoreInstance
        .collection(FirestoreCollectionConstant.listing)
        .doc(listingID)
        .get();

    return Listing.fromListingJson(listingID, snapshot.data());
  }

  Future editItem(Item item) async {
    return await firestoreInstance
        .collection(FirestoreCollectionConstant.item)
        .doc(item.listingID)
        .update(item.toJson());
  }

  Future editSF(SportsFacility sportsFacility) async {
    return await firestoreInstance
        .collection(FirestoreCollectionConstant.sportsFacility)
        .doc(sportsFacility.listingID)
        .update(sportsFacility.toJson());
  }

  Future deleteListing(String listingID) async {
    return await firestoreInstance
        .collection(FirestoreCollectionConstant.listing)
        .doc(listingID)
        .delete();
  }

  Future deleteItem(String listingID) async {
    return await firestoreInstance
        .collection(FirestoreCollectionConstant.item)
        .doc(listingID)
        .delete();
  }

  Future deleteSF(String listingID) async {
    return await firestoreInstance
        .collection(FirestoreCollectionConstant.sportsFacility)
        .doc(listingID)
        .delete();
  }

  Stream<List<SlotUnavailable>> getSlotUnavailable(
      String listingID, String date) {
    return firestoreInstance
        .collection(FirestoreCollectionConstant.slotUnavailable)
        .where('listingID', isEqualTo: listingID)
        .snapshots()
        .asyncMap((snapshot) async {
      List<SlotUnavailable> slotUnavailableList = [];

      for (var doc in snapshot.docs) {
        SlotUnavailable slotUnavailable =
            SlotUnavailable.fromJson(doc.id, doc.data());

        if (slotUnavailable.date.substring(0, 10) == date.substring(0, 10)) {
          SportsRelatedBusinessServiceFirebase
              sportsRelatedBusinessServiceFirebase =
              SportsRelatedBusinessServiceFirebase();
          Appointment? appointment = await sportsRelatedBusinessServiceFirebase
              .readAppointment(slotUnavailable.slotUnavailableID);
          if (appointment != null) {
            slotUnavailable.appointment = appointment;
          }
          slotUnavailableList.add(slotUnavailable);
        }
      }
      return slotUnavailableList;
    });
  }

  Future<String> createSlotUnavailable(SlotUnavailable slotUnavailable) async {
    return firestoreInstance
        .collection(FirestoreCollectionConstant.slotUnavailable)
        .add(slotUnavailable.toJson())
        .then((value) => value.id);
  }

  Future deleteSlotUnavailable(String slotUnavailableID) async {
    return await firestoreInstance
        .collection(FirestoreCollectionConstant.slotUnavailable)
        .doc(slotUnavailableID)
        .delete();
  }

  Future<bool> checkSlotUnavailable(
      String listingID, String date, int slot) async {
    final snapshot = await firestoreInstance
        .collection(FirestoreCollectionConstant.slotUnavailable)
        .where('listingID', isEqualTo: listingID)
        .get();
    for (var doc in snapshot.docs) {
      SlotUnavailable slotUnavailable =
          SlotUnavailable.fromJson(doc.id, doc.data());
      if (slotUnavailable.date.substring(0, 10) == date.substring(0, 10) &&
          slotUnavailable.slot == slot) {
        return true;
      }
    }
    return false;
  }

  Future<String> getSportsFacilityName(String lisitngID) async {
    final snapshot = await firestoreInstance
        .collection(FirestoreCollectionConstant.sportsFacility)
        .doc(lisitngID)
        .get();

    return snapshot.data()?['facilityName'] ?? '';
  }
}
