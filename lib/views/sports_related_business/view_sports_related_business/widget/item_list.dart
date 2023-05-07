import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/listing_controller.dart';
import 'package:jomsports/models/item.dart';

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
            return const Center(child: Text('No item yet.'));
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
