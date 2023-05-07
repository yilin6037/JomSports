import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jomsports/models/item.dart';
import 'package:jomsports/models/slot_unavailable.dart';
import 'package:jomsports/models/sports_facility.dart';
import 'package:jomsports/shared/constant/listing_type.dart';
import 'package:jomsports/shared/dialog/dialog.dart';
import 'package:jomsports/views/sports_related_business/manage_listing/listing_page.dart';
import 'user_controller.dart';

class ListingController extends GetxController {
  final UserController userController = Get.find(tag: 'userController');

  //create & edit
  Rx<ListingType> listingChoice = Rx<ListingType>(ListingType.item);

  //listing picture
  XFile listingPicture = XFile('');
  String listingPictureUrl = '';
  void onSelectListingPicture(XFile imageSelected) {
    listingPicture = XFile(imageSelected.path);
  }

  GlobalKey<FormState> itemFormKey = GlobalKey<FormState>();
  TextEditingController itemNameTextController = TextEditingController();
  TextEditingController itemDescriptionTextController = TextEditingController();
  RxBool itemAvailability = RxBool(true);

  void initItemForm() {
    itemFormKey = GlobalKey<FormState>();
    itemNameTextController = TextEditingController();
    itemDescriptionTextController = TextEditingController();
    itemAvailability = RxBool(true);
    listingPicture = XFile('');
    listingPictureUrl = '';
  }

  Future addItem() async {
    Item item = Item(
        listingID: '',
        userID: userController.currentUser.userID,
        listingType: ListingType.item,
        itemName: itemNameTextController.text,
        description: itemDescriptionTextController.text,
        availability: itemAvailability.value);

    await item.createListing(listingPicture);
    SharedDialog.directDialog(
        'Success', 'Listing is added successfully!', ListingPage());
    initItemForm();
    initSFForm();
  }

  GlobalKey<FormState> facilityFormKey = GlobalKey<FormState>();
  TextEditingController facilityNameTextController = TextEditingController();
  TextEditingController facilityDescriptionTextController =
      TextEditingController();

  List<TextEditingController> openHourTextControllerList =
      List.generate(7, (index) => TextEditingController());
  List<TextEditingController> closeHourTextControllerList =
      List.generate(7, (index) => TextEditingController());

  List<RxString> operatingHourErrorMessage =
      List.generate(7, (index) => RxString(''));

  void initSFForm() {
    facilityFormKey = GlobalKey<FormState>();
    facilityNameTextController = TextEditingController();
    facilityDescriptionTextController = TextEditingController();

    openHourTextControllerList =
        List.generate(7, (index) => TextEditingController());
    closeHourTextControllerList =
        List.generate(7, (index) => TextEditingController());

    listingPicture = XFile('');
    listingPictureUrl = '';
  }

  Future addSF() async {
    List<OperatingHour> operatingHourList = [];
    for (int i = 0; i < 7; i++) {
      operatingHourList.add(OperatingHour(
          int.parse(openHourTextControllerList[i].text),
          int.parse(closeHourTextControllerList[i].text)));
    }

    SportsFacility sportsFacility = SportsFacility(
        listingID: '',
        userID: userController.currentUser.userID,
        listingType: ListingType.facility,
        facilityName: facilityNameTextController.text,
        description: facilityDescriptionTextController.text,
        operatingHourList: operatingHourList);

    await sportsFacility.createListing(listingPicture);
    SharedDialog.directDialog(
        'Success', 'Listing is added successfully!', ListingPage());
    initItemForm();
    initSFForm();
  }

  //read
  Stream<List<Item>> getItemList() {
    return Item.getItemList(userController.currentUser.userID);
  }

  Stream<List<SportsFacility>> getSFList() {
    return SportsFacility.getSFList(userController.currentUser.userID);
  }

  //edit
  Item? selectedItem;
  Future initEditItemForm(String listingID) async {
    selectedItem = await Item.getListing(listingID);
    if (selectedItem == null) {
      SharedDialog.errorDialog();
      Get.back();
    }
    listingChoice.value = ListingType.item;
    itemFormKey = GlobalKey<FormState>();
    itemNameTextController =
        TextEditingController(text: selectedItem!.itemName);
    itemDescriptionTextController =
        TextEditingController(text: selectedItem!.description);
    itemAvailability = RxBool(selectedItem!.availability);
    await selectedItem!.getListingPicUrl();
    if (selectedItem!.listingPictureUrl != null) {
      listingPictureUrl = selectedItem!.listingPictureUrl!;
      listingPicture = XFile('');
    } else {
      listingPicture = XFile('');
      listingPictureUrl = '';
    }
  }

  SportsFacility? selectedSF;
  Future initEditSFForm(String listingID) async {
    selectedSF = await SportsFacility.getListing(listingID);
    if (selectedSF == null) {
      SharedDialog.errorDialog();
      Get.back();
    }
    listingChoice.value = ListingType.facility;
    facilityFormKey = GlobalKey<FormState>();
    facilityNameTextController =
        TextEditingController(text: selectedSF!.facilityName);
    facilityDescriptionTextController =
        TextEditingController(text: selectedSF!.description);

    openHourTextControllerList = List.generate(
        7,
        (index) => TextEditingController(
            text: selectedSF!.operatingHourList[index].openHour.toString()));
    closeHourTextControllerList = List.generate(
        7,
        (index) => TextEditingController(
            text: selectedSF!.operatingHourList[index].closeHour.toString()));
    await selectedSF!.getListingPicUrl();
    if (selectedSF!.listingPictureUrl != null) {
      listingPictureUrl = selectedSF!.listingPictureUrl!;
      listingPicture = XFile('');
    } else {
      listingPicture = XFile('');
      listingPictureUrl = '';
    }
  }

  Future editItem() async {
    Item item = Item(
        listingID: selectedItem!.listingID,
        userID: userController.currentUser.userID,
        listingType: ListingType.item,
        itemName: itemNameTextController.text,
        description: itemDescriptionTextController.text,
        availability: itemAvailability.value);

    await item.editListing(listingPicture);
    initItemForm();
    initSFForm();
    SharedDialog.directDialog(
        'Success', 'Listing is edited successfully!', ListingPage());
  }

  Future editSF() async {
    List<OperatingHour> operatingHourList = [];
    for (int i = 0; i < 7; i++) {
      operatingHourList.add(OperatingHour(
          int.parse(openHourTextControllerList[i].text),
          int.parse(closeHourTextControllerList[i].text)));
    }

    SportsFacility sportsFacility = SportsFacility(
        listingID: selectedSF!.listingID,
        userID: userController.currentUser.userID,
        listingType: ListingType.facility,
        facilityName: facilityNameTextController.text,
        description: facilityDescriptionTextController.text,
        operatingHourList: operatingHourList);

    await sportsFacility.editListing(listingPicture);
    initItemForm();
    initSFForm();
    SharedDialog.directDialog(
        'Success', 'Listing is edited successfully!', ListingPage());
  }

  Future deleteItem(Item item) async {
    await item.deleteListing();
    SharedDialog.alertDialog('Success', 'Listing is deleted successfully');
  }

  Future deleteSF(SportsFacility sportsFacility) async {
    await sportsFacility.deleteListing();
    SharedDialog.alertDialog('Success', 'Listing is deleted successfully');
  }

  List<DateTime> upcomingWeek = [];
  Rx<DateTime> selectedDate = Rx<DateTime>(DateTime.now());
  Future initAvailability(String listingID) async {
    selectedSF = await SportsFacility.getListing(listingID);
    if (selectedSF == null) {
      SharedDialog.errorDialog();
      Get.back();
    }
    DateTime now = DateTime.now();

    upcomingWeek = List.generate(
        7, (index) => DateTime(now.year, now.month, now.day + index));
    selectedDate.value = upcomingWeek[0];
  }

  Stream<List<SlotUnavailable>> getSlotUnavailableList(String date) {
    return SlotUnavailable.getSlotUnavailableList(selectedSF!.listingID, date);
  }

  Future addSlotUnavailable(int slot) async {
    SlotUnavailable slotUnavailable = SlotUnavailable(
        slotUnavailableID: '',
        listingID: selectedSF!.listingID,
        date: selectedDate.value.toString(),
        slot: slot);

    return await slotUnavailable.addSlotUnavailable();
  }

  Future deleteSlotUnavailable(SlotUnavailable slotUnavailable) async{
    return await slotUnavailable.deleteSlotUnavailable();
  }
}
