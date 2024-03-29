import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/views/forum/forum/forum_page.dart';
import 'package:jomsports/views/home/home_page.dart';
import 'package:jomsports/views/sports_related_business/manage_listing/listing_page.dart';

class SportsRelatedBusinessNavBar extends StatelessWidget {
  const SportsRelatedBusinessNavBar({super.key, required this.currentIndex});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: (value) {
        switch (value) {
          case 0:
            Get.offAll(() =>HomePage());
            break;
          case 1:
            //listing
            Get.offAll(() =>ListingPage());
            break;
          case 2:
            //forum
            Get.offAll(() => ForumPage());
            break;
          default:
            Get.offAll(() =>HomePage());
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.sports_tennis_rounded),
          label: 'Listing',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.diversity_1_outlined),
          label: 'Forum',
        ),
      ],
    );
  }
}