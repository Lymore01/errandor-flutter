import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/created_errands_tab.dart';
import '../widgets/claimed_errands_tab.dart';
import '../../controllers/my_errands_controller.dart';

class MyErrands extends StatelessWidget {
  const MyErrands({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyErrandsController());

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Errands'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                controller.fetchCreatedErrands();
                controller.fetchClaimedErrands();
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.create),
                text: 'Created',
              ),
              Tab(
                icon: Icon(Icons.work),
                text: 'Claimed',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CreatedErrandsTab(controller: controller),
            ClaimedErrandsTab(controller: controller),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Get.toNamed('/create-errand'),
          icon: const Icon(Icons.add),
          label: const Text('New Errand'),
        ),
      ),
    );
  }
}