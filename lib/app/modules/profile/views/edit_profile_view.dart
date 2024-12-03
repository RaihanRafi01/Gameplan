import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:agcourt/common/widgets/custom_button.dart';
import 'package:agcourt/common/widgets/custom_textField.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../controllers/profile_controller.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({Key? key}) : super(key: key);

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  XFile? _pickedImage;

  final ProfileController profileController = Get.put(ProfileController());

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Personal information',style: h2,),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: _pickedImage != null
                            ? FileImage(File(_pickedImage!.path))
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
                        profileController.name.value,
                        style: h1.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                      )),
                      const SizedBox(height: 10),
                      CustomButton(
                        isGem: true,
                        width: 190,
                        text: 'Standard Account',
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Obx(() => CustomTextField(
              label: 'Full Name',
              controller: TextEditingController(text: profileController.name.value),
              prefixIcon: Icons.person_outline_rounded,
              onChanged: (value) {
                profileController.updateName(value);
              },
            )),
            Obx(() => CustomTextField(
              label: 'Email',
              controller: TextEditingController(text: profileController.email.value),
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                profileController.updateEmail(value);
              },
            )),
            Obx(() => CustomTextField(
              label: 'About You',
              controller: TextEditingController(text: profileController.aboutYou.value),
              onChanged: (value) {
                profileController.updateAboutYou(value);
              },
            )),
            const SizedBox(height: 20),
            CustomButton(
              text:'Save',
              onPressed: () {
              },
            )
          ],
        ),
      ),
    );
  }
}
