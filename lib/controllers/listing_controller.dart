import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jomsports/models/item.dart';
import 'package:jomsports/models/slot_unavailable.dart';
import 'package:jomsports/models/sports_facility.dart';
import 'package:jomsports/shared/constant/listing_type.dart';
import 'package:jomsports/shared/constant/role.dart';
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

  GlobalKey<FormState> addItemFormKey = GlobalKey<FormState>();
  TextEditingController itemNameTextController = TextEditingController();
  TextEditingController itemDescriptionTextController = TextEditingController();
  RxBool itemAvailability = RxBool(true);

  void initItemForm() {
    addItemFormKey = GlobalKey<FormState>();
    itemNameTextController = TextEditingController();
    itemDescriptionTextController = TextEditingController();
    itemAvailability = RxBool(true);
    listingPicture = XFile('');
    listingPictureUrl = '';
  }

  Future addItem() async {
    Item item = Item(
        listingID: '',
        userID: sportsRelatedBusinessID!,
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

  GlobalKey<FormState> addFacilityFormKey = GlobalKey<FormState>();
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
    addFacilityFormKey = GlobalKey<FormState>();
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
        userID: sportsRelatedBusinessID!,
        listingType: ListingType.facility,
        facilityName: facilityNameTextController.text,
        description: facilityDescriptionTextController.text,
        operatingHourList: operatingHourList);

    await sportsFacility.createListing(listingPicture);
    SharedDialog.directDialog(
        'Success', 'Listing is added successfully!', ListingPage());
    await userController.currentUser.setHasSF(true);
    initItemForm();
    initSFForm();
  }

  //read
  String? sportsRelatedBusinessID;
  void initSportsRelatedBusiness(String userID){

      sportsRelatedBusinessID = userID;
    
  }

  Stream<List<Item>> getItemList() {
    if(userController.currentUser.userType == Role.sportsRelatedBusiness){
      initSportsRelatedBusiness(userController.currentUser.userID);
    }
    return Item.getItemList(sportsRelatedBusinessID!);
  }

  Stream<List<SportsFacility>> getSFList() {
    if(userController.currentUser.userType == Role.sportsRelatedBusiness){
      initSportsRelatedBusiness(userController.currentUser.userID);
    }
    return SportsFacility.getSFList(sportsRelatedBusinessID!);
  }

  //edit
  Item? selectedItem;
  GlobalKey<FormState> editItemFormKey = GlobalKey<FormState>();
  Future initEditItemForm(String listingID) async {
    editItemFormKey = GlobalKey<FormState>();
    selectedItem = await Item.getListing(listingID);
    if (selectedItem == null) {
      SharedDialog.errorDialog();
      Get.back();
    }
    listingChoice.value = ListingType.item;
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
  GlobalKey<FormState> editFacilityFormKey = GlobalKey<FormState>();
  Future initEditSFForm(String listingID) async {
    editFacilityFormKey = GlobalKey<FormState>();
    selectedSF = await SportsFacility.getListing(listingID);
    if (selectedSF == null) {
      SharedDialog.errorDialog();
      Get.back();
    }
    listingChoice.value = ListingType.facility;
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
        userID: sportsRelatedBusinessID!,
        listingType: ListingType.item,
        itemName: itemNameTextController.text,
        description: itemDescriptionTextController.text,
        availability: itemAvailability.value);

    await item.editListing(listingPicture);
    initItemForm();
    initSFForm();
    SharedDialog.directDialog(
        'Success', 'Listing is edited successfully!', ListingPage());
    editItemFormKey = GlobalKey<FormState>();
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
        userID: sportsRelatedBusinessID!,
        listingType: ListingType.facility,
        facilityName: facilityNameTextController.text,
        description: facilityDescriptionTextController.text,
        operatingHourList: operatingHourList);

    await sportsFacility.editListing(listingPicture);
    initItemForm();
    initSFForm();
    SharedDialog.directDialog(
        'Success', 'Listing is edited successfully!', ListingPage());
    editFacilityFormKey = GlobalKey<FormState>();
  }

  Future deleteItem(Item item) async {
    await item.deleteListing();
    SharedDialog.alertDialog('Success', 'Listing is deleted successfully');
  }

  Future deleteSF(SportsFacility sportsFacility, bool isLast) async {
    await sportsFacility.deleteListing();
    if (isLast) {
      await userController.currentUser.setHasSF(false);
    }
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

  Future deleteSlotUnavailable(SlotUnavailable slotUnavailable) async {
    return await slotUnavailable.deleteSlotUnavailable();
  }
}
