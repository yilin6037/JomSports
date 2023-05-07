import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/listing_controller.dart';
import 'package:jomsports/models/item.dart';
import 'package:jomsports/shared/dialog/dialog.dart';
import 'package:jomsports/views/sports_related_business/manage_listing/edit_listing_page.dart';

class ItemList extends StatelessWidget {
  ItemList({super.key});

  final ListingController listingController =
      Get.find(tag: 'listingController');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Item>>(
      stream: listingController.getItemList(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          final itemList = snapshot.data!;
          if (itemList.isEmpty) {
            return const Center(child: Text('No item yet. Add some!'));
          } else {
            return ListView.builder(
                itemCount: itemList.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemBuilder: (context, index) {
                  Item item = itemList[index];
                  return Column(
                    children: [
                      ListTile(
                        title: Text(item.itemName),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.description),
                            Text(item.availability
                                ? 'Available'
                                : 'Not Available'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () async {
                                    await listingController
                                        .initEditItemForm(item.listingID);
                                    Get.to(() => EditListingPage());
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    SharedDialog.confirmationDialog(
                                      title: 'Delete Item',
                                      message:
                                          'Are you sure to delete ${item.itemName} listing?',
                                      onCancel: () {},
                                      onOK: () async {
                                        await listingController
                                            .deleteItem(item);
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        leading: item.listingPictureUrl != null &&
                                item.listingPictureUrl!.isNotEmpty
                            ? ClipRect(
                                child: Material(
                                  color: Colors.transparent,
                                  child: Ink.image(
                                      image:
                                          NetworkImage(item.listingPictureUrl!),
                                      fit: BoxFit.contain,
                                      width: 100,
                                      height: 100,
                                      child: const InkWell()),
                                ),
                              )
                            : const CircleAvatar(
                                radius: 50,
                                child: Icon(Icons.sports_tennis),
                              ),
                      ),
                      const Divider()
                    ],
                  );
                });
          }
        }
      },
    );
  }
}
