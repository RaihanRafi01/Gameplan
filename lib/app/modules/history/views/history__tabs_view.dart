/*
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../common/appColors.dart';
import '../../../../common/widgets/custom_button.dart';
import '../../dashboard/views/widgets/subscriptionPopup.dart';
import '../../home/controllers/home_controller.dart';
import 'edited_view.dart';
import 'history_view.dart';

class HistoryTabsView extends StatelessWidget {
  const HistoryTabsView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.put(HomeController());
    final bool isFree = homeController.isFree.value;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: SvgPicture.asset('assets/images/auth/app_logo.svg'),
          actions: [
            if (isFree)
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: CustomButton(
                  height: 30,
                  textSize: 12,
                  text: 'Upgrade To Pro',
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        return const SubscriptionPopup(isManage: true);
                      },
                    );
                  },
                  width: 150,
                  backgroundGradientColor: AppColors.transparent,
                  borderGradientColor: AppColors.cardGradient,
                  isEditPage: true,
                  textColor: AppColors.textColor,
                ),
              ),
          ],
        ),
        body: Column(
          children: [
            // TabBar below the AppBar
            const TabBar(
              tabs: [
                Tab(text: "History"),
                Tab(text: "Edited"),
              ],
            ),
            // TabBarView takes the rest of the screen
            Expanded(
              child: const TabBarView(
                children: [
                  HistoryView(),
                  EditedScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/
