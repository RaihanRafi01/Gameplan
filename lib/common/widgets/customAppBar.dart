import 'package:agcourt/common/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/modules/dashboard/views/widgets/subscriptionPopup.dart';
import '../appColors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: /*Icon(Icons.check_box_outlined)*/
      Image.asset('assets/images/history/save_icon.png',scale: 3,),
      centerTitle: true,
      title: CustomButton(
        text: 'Upgrade To Pro',
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: true, // Prevent closing the dialog by tapping outside
            builder: (BuildContext context) {
              return const SubscriptionPopup(isManage: true); // Use the SubscriptionPopup widget
            },
          );
        },
        width: 170,
        backgroundGradientColor: AppColors.transparent,
        borderGradientColor: AppColors.cardGradient,
        isEditPage: true,
        textColor: AppColors.textColor,
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: GestureDetector(
              onTap: (){

              },
              child: SvgPicture.asset('assets/images/history/pin_icon.svg')),
        ),
      ],
    );
  }
}