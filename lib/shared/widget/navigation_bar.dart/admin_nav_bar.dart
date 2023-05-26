import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/views/forum/forum/forum_page.dart';
import 'package:jomsports/views/home/home_page.dart';
import 'package:jomsports/views/srb_authentication/srb_authentication_page.dart';

class AdminNavBar extends StatelessWidget {
  const AdminNavBar({super.key, required this.currentIndex});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: (value) {
        switch (value) {
          case 0:
            Get.offAll(() => HomePage());
            break;
          case 1:
            //authentication
            Get.offAll(()=>SRBAuthenticationPage());
            break;
          case 2:
            //forum
            Get.offAll(() => ForumPage());
            break;
          default:
            Get.offAll(() => HomePage());
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.store_outlined),
          label: 'Authentication',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.diversity_1_outlined),
          label: 'Forum',
        ),
      ],
    );
  }
}
