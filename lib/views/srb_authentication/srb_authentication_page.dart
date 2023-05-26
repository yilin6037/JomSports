import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/sports_related_business_controller.dart';
import 'package:jomsports/models/sports_related_business.dart';
import 'package:jomsports/shared/constant/asset.dart';
import 'package:jomsports/shared/constant/role.dart';
import 'package:jomsports/shared/widget/scaffold/scaffold_default.dart';
import 'package:jomsports/views/sports_related_business/view_sports_related_business/view_sports_related_business_page.dart';
import 'package:jomsports/views/srb_authentication/view_map.dart';
import 'package:jomsports/views/srb_authentication/widget/authentication_button.dart';

class SRBAuthenticationPage extends StatelessWidget {
  SRBAuthenticationPage({super.key});

  final SportsRelatedBusinessController sportsRelatedBusinessController =
      Get.put(SportsRelatedBusinessController(),
          tag: 'sportsRelatedBusinessController');

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      title: 'Authenticate Sports Related Business',
      role: Role.admin,
      navIndex: 1,
      back: false,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: StreamBuilder<List<SportsRelatedBusiness>>(
              stream: sportsRelatedBusinessController.getPendingSRB(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }
                if (!snapshot.hasData ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  final srbList = snapshot.data!;
                  if (srbList.isEmpty) {
                    return const Center(
                        child: Text(
                            '- No pending Sports Related Business to be authenticated -'));
                  } else {
                    return ListView.builder(
                      itemCount: srbList.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemBuilder: (context, index) {
                        final srb = srbList[index];
                        return Column(
                          children: [
                            ListTile(
                              leading: srb.profilePictureUrl != null &&
                                      srb.profilePictureUrl!.isNotEmpty
                                  ? ClipRect(
                                      child: Material(
                                        color: Colors.transparent,
                                        child: Ink.image(
                                            image: NetworkImage(
                                                srb.profilePictureUrl!),
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
                              title: Text(srb.name),
                              subtitle: Column(
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.phone),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Flexible(
                                        child: Text(
                                          srb.phoneNo,
                                          softWrap: true,
                                        ),
                                      )
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      final icon =
                                          await sportsRelatedBusinessController
                                              .getBytesFromAsset(
                                                  path: AssetConstant.shop,
                                                  width: 200);
                                      Get.to(() => ViewMap(
                                          srb: srb,
                                          icon: icon,
                                          onTap: () {
                                            bool isInit =
                                                sportsRelatedBusinessController
                                                    .initSRB(srb);
                                            if (isInit) {
                                              Get.to(() =>
                                                  ViewSportsRelatedBusinessPage());
                                            }
                                          }));
                                    },
                                    child: Row(
                                      children: [
                                        const Icon(Icons.location_on),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          child: Text(
                                            srb.address,
                                            softWrap: true,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                bool isInit = sportsRelatedBusinessController
                                    .initSRB(srb);
                                if (isInit) {
                                  Get.to(() => ViewSportsRelatedBusinessPage());
                                }
                              },
                            ),
                            AuthenticationButton(userID: srb.userID),
                            const Divider(),
                          ],
                        );
                      },
                    );
                  }
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
