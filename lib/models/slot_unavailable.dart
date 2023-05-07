import 'package:jomsports/models/appointment.dart';
import 'package:jomsports/services/listing_service_firebase.dart';

class SlotUnavailable {
  String slotUnavailableID;
  String listingID;
  String date;
  int slot;
  Appointment? appointment;

  SlotUnavailable({
    required this.slotUnavailableID,
    required this.listingID,
    required this.date,
    required this.slot,
  });

  Map<String, dynamic> toJson() =>
      {'listingID': listingID, 'date': date, 'slot': slot};

  SlotUnavailable.fromJson(String slotUnavailableID, Map<String, dynamic>? json)
      : this(
            slotUnavailableID: slotUnavailableID,
            listingID: json?['listingID'],
            date: json?['date'],
            slot: json?['slot']);

  static Stream<List<SlotUnavailable>> getSlotUnavailableList(
      String listingID, String date) {
    ListingServiceFirebase listingServiceFirebase = ListingServiceFirebase();
    return listingServiceFirebase.getSlotUnavailable(listingID, date);
  }

  Future addSlotUnavailable() async {
    ListingServiceFirebase listingServiceFirebase = ListingServiceFirebase();
    slotUnavailableID =
        await listingServiceFirebase.createSlotUnavailable(this);
  }

  Future deleteSlotUnavailable() async {
    ListingServiceFirebase listingServiceFirebase = ListingServiceFirebase();
    await listingServiceFirebase.deleteSlotUnavailable(slotUnavailableID);
  }
}
