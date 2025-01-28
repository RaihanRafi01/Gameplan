import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../app/modules/authentication/controllers/authentication_controller.dart';
import '../../../app/modules/authentication/views/sign_up_view.dart';
import '../../appColors.dart';
import '../../customFont.dart';
import 'social_button.dart';

class SignupWithOther extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final AuthenticationController _controller = Get.put(
      AuthenticationController());

  SignupWithOther({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        SvgPicture.asset('assets/images/auth/orLoginWith.svg'),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SocialButton(
              iconPath: 'assets/images/auth/apple_icon.svg',
              onPressed: () {
                // Implement Apple Sign-In here
              },
            ),
            const SizedBox(width: 30),
            SocialButton(
              iconPath: 'assets/images/auth/google_icon.svg',
              onPressed: () {
                _signInWithGoogle();
              },
            ),
            const SizedBox(width: 30),
            SocialButton(
              iconPath: 'assets/images/auth/facebook_icon.svg',
              onPressed: () {
                // Implement Facebook Sign-In here
              },
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _signInWithGoogle() async {
    try {
      _controller.isLoading.value = true;
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {

        print(':::::::::::::::::::::::::::::::::::::::${user.email}');
        print(':::::::::::::::::::::::::::::::::::::::${user.displayName}');
        print(':::::::::::::::::::::::::::::::::::::::${user.uid}');

        await _controller.signUpWithOther(user.displayName!, user.email!);

      }
    } catch (e) {
      print("Error signing in: $e");
    }finally {
      _controller.isLoading.value = false; // Hide the loading screen
    }

  }
}
