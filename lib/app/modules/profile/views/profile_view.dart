import 'package:agcourt/app/modules/authentication/views/authentication_view.dart';
import 'package:agcourt/app/modules/home/views/home_view.dart';
import 'package:agcourt/app/modules/profile/views/edit_profile_view.dart';
import 'package:agcourt/app/modules/profile/views/faq_view.dart';
import 'package:agcourt/app/modules/profile/views/help_support_view.dart';
import 'package:agcourt/app/modules/profile/views/settings_view.dart';
import 'package:agcourt/app/modules/profile/views/terms_privacy_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../../../../common/widgets/profile/profileList.dart';
import '../../../../main.dart';
import '../../../routes/app_pages.dart';
import '../../dashboard/controllers/theme_controller.dart';
import '../../dashboard/views/widgets/subscriptionPopup.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/profile_controller.dart';



class ProfileView extends GetView<ProfileController> {
  final HomeController homeController = Get.put(HomeController());
  final ThemeController themeController = Get.put(ThemeController());

  ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 58),
            Container(
              height: 70,
              width: double.maxFinite,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: AppColors.cardGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Text(
                  'Account',
                  style: h3.copyWith(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            ProfileList(
              svgPath: 'assets/images/profile/profile_icon.svg',
              text: 'PROFILE',
              onTap: () => Get.to(() => EditProfileView()),
            ),
            ProfileList(
              svgPath: 'assets/images/profile/settings_icon.svg',
              text: 'MANAGE SUBSCRIPTION',
              onTap: () {
                print(':::::::::::::::::::VALUE::::::::::::::::${homeController.subscriptionStatus.value}');
                final bool isFree = homeController.isFree.value;
                if (isFree) {
                  showDialog(
                    context: context,
                    barrierDismissible: true, // Prevent closing the dialog by tapping outside
                    builder: (BuildContext context) {
                      return const SubscriptionPopup(isManage: true); // Use the SubscriptionPopup widget
                    },
                  );
                } else {
                  Get.to(() => SettingsView());
                }
              },
            ),
            ProfileList(
              svgPath: 'assets/images/profile/faq_icon.svg',
              text: 'FAQ',
              onTap: () => Get.to(() => FaqView(selectedIndex: 0,)),
            ),
            ProfileList(
              svgPath: 'assets/images/profile/support_icon.svg',
              text: 'HELP & SUPPORT',
              onTap: () => Get.to(() => HelpSupportView()),
            ),
            ProfileList(
              svgPath: 'assets/images/profile/terms_icon.svg',
              text: 'TERMS & CONDITION',
              onTap: () => Get.to(() => TermsPrivacyView(isTerms: true,)),
            ),
            ProfileList(
              svgPath: 'assets/images/profile/privacy_icon.svg',
              text: 'PRIVACY POLICY',
              onTap: () => Get.to(() => TermsPrivacyView(isTerms: false,)),
            ),
            ProfileList(
               // Adjust the icon
              text: 'Dark Mode',
              onTap: () {}, // No need to navigate; just toggle switch
              trailingWidget: Obx(() => Switch(
                value: themeController.isDarkTheme.value,
                onChanged: (value) {
                  themeController.toggleTheme();
                },
              )),
            ),
            ProfileList(
              svgPath: 'assets/images/profile/logout_icon.svg',
              text: 'LOG OUT',
              onTap: () {
                // Handle Logout
                showDialog(
                  context: context,
                  builder: (context) {
                    final ThemeController themeController = Get.find<ThemeController>();

                    return Obx(() => AlertDialog(
                      backgroundColor: themeController.isDarkTheme.value
                          ? Colors.grey[850]
                          : Colors.white, // Dynamic dialog background color
                      title: Text(
                        'Log Out',
                        style: h2.copyWith(
                          color: themeController.isDarkTheme.value
                              ? Colors.white
                              : Colors.black, // Dynamic title text color
                        ),
                      ),
                      content: Text(
                        'Are you sure you want to log out?',
                        style: h3.copyWith(
                          color: themeController.isDarkTheme.value
                              ? Colors.white70
                              : Colors.black87, // Dynamic content text color
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Cancel',
                            style: h2.copyWith(
                              color: themeController.isDarkTheme.value
                                  ? Colors.white70
                                  : AppColors.appColor, // Dynamic button text color
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            // Add your logout logic here
                            logout();
                          },
                          child: Text(
                            'Log Out',
                            style: h2.copyWith(
                              color: themeController.isDarkTheme.value
                                  ? Colors.redAccent
                                  : Colors.red, // Dynamic logout button color
                            ),
                          ),
                        ),
                      ],
                    ));
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<void> logout() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');

    // SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false); // User is logged out

    Get.offAll(() => AuthenticationView()); // Navigate to the login screen
  }
}
