import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:agcourt/common/widgets/custom_button.dart';
import 'package:agcourt/common/widgets/custom_textField.dart';
import '../../../../common/customFont.dart';
import '../../../data/services/api_services.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/profile_controller.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({Key? key}) : super(key: key);

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  XFile? _pickedImage;
  final ProfileController profileController = Get.put(ProfileController());
  final HomeController homeController = Get.put(HomeController());

  // TextEditingControllers for the input fields
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _aboutYouController;

  @override
  void initState() {
    super.initState();
    homeController.isEditingProfile.value = true;

    // Initialize TextEditingControllers with data from the ProfileController
    _nameController = TextEditingController(text: homeController.name.value);
    _emailController = TextEditingController(text: homeController.email.value);
    _aboutYouController = TextEditingController(text: homeController.aboutYou.value);

    // Sync the profile data to controllers after fetch
    homeController.fetchProfileData().then((_) {
      setState(() {
        _nameController.text = homeController.name.value;
        _emailController.text = homeController.email.value;
        _aboutYouController.text = homeController.aboutYou.value;
      });
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _pickedImage = image;
      });
    }
  }

  @override
  void dispose() {
    // Dispose controllers to free up resources
    _nameController.dispose();
    _emailController.dispose();
    _aboutYouController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal information', style: h2),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _pickedImage != null
                          ? FileImage(File(_pickedImage!.path))
                          : homeController.profilePicUrl.value.isNotEmpty

                          ? NetworkImage(
                        // https://agcourt.pythonanywhere.com         //  https://apparently-intense-toad.ngrok-free.app

                          '${ApiService().baseUrl}${homeController.profilePicUrl.value}')
                          : const AssetImage('assets/images/profile/profile_avatar.png') as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: SvgPicture.asset('assets/images/profile/edit_pic.svg'),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Obx(() => Text(
                      homeController.name.value,
                      style: h1.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                    )),
                    const SizedBox(height: 10),
                    CustomButton(
                      isGem: true,
                      width: 190,
                      text: 'Standard Account',
                      textSize: 14,
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 40),
            CustomTextField(
              label: 'Full Name',
              controller: _nameController,
              prefixIcon: Icons.person_outline_rounded,
              onChanged: (value) {
                // Update ProfileController whenever the text changes
                profileController.updateName(value);
              },
            ),
            CustomTextField(
              readOnly: true,
              label: 'Email',
              controller: _emailController,
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            CustomTextField(
              label: 'About You',
              controller: _aboutYouController,
              onChanged: (value) {
                // Update ProfileController whenever the text changes
                profileController.updateAboutYou(value);
              },
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Save',
              onPressed: () async {
                print('::::::::edit:::::::::::::NAME:::::::::::${homeController.name.value}');
                print('::::::::::edit:::::::::::aboutYou:::::::::::${homeController.aboutYou.value}');

                // Set editing flag to true when saving
                //homeController.isEditingProfile.value = true;

                // Handle the profile picture
                File? profilePic;
                if (_pickedImage != null) {
                  profilePic = File(_pickedImage!.path);
                }

                // Call the updateData method
                await profileController.updateData(
                  homeController.name.value,
                  homeController.aboutYou.value,
                  profilePic,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
