import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/sports_related_business_controller.dart';
import 'package:jomsports/shared/widget/chart/piechart.dart';

class AdminHome extends StatelessWidget {
  AdminHome({super.key});

  final SportsRelatedBusinessController sportsRelatedBusinessController =
      Get.put(
          tag: 'sportsRelatedBusinessController',
          SportsRelatedBusinessController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Authentication Status Summary',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        StreamBuilder<List<ChartData>>(
          stream: sportsRelatedBusinessController.getSRBSummary(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            } else if (snapshot.hasData) {
              return Card(
                  child: SharedPieChart(
                chartData: snapshot.data!,
              ));
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ],
    );
  }
}
