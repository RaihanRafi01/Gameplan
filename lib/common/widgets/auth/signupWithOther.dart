import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../app/modules/authentication/views/sign_up_view.dart';
import '../../appColors.dart';
import '../../customFont.dart';
import 'social_button.dart';
class SignupWithOther extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: "356582055980-1d0cfdvitkqperbi576l9blkns4knqur.apps.googleusercontent.com",
  );
  SignupWithOther({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
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
              // Call Google sign-in function
            },
          ),
          SizedBox(width: 30),
          SocialButton(
            iconPath: 'assets/images/auth/google_icon.svg',
            onPressed: ()  {
              _signInWithGoogle();
            },
          ),
          SizedBox(width: 30),
          SocialButton(
            iconPath: 'assets/images/auth/facebook_icon.svg',
            onPressed: () {
              // Call Google sign-in function
            },
          ),
        ],
      ),


    ],);
  }



  Future<void> _signInWithGoogle() async {
    try {


      var googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        print(":: NULL:::");
        // User canceled the sign-in
        return;
      }

      var user = googleUser.displayName;
      var email = googleUser.email;

      print(":: USER:::::::$user");
      print(":: Email:::::::$email");

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;


      var accessToken =  googleAuth.accessToken;
      var idToken =  googleAuth.idToken;

      print(":::::::::::::::::::::Google accessToken ::::::::: $accessToken");
      print(":::::::::::::::::::::Google ID Token ::::::::: $idToken");

    } catch (error) {
      print('Google Sign-In error: $error');
    }
  }


}
