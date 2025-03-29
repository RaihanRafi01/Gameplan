import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../common/customFont.dart';

class TermsPrivacyView extends GetView {
  final bool isTerms;
  const TermsPrivacyView({required this.isTerms,super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isTerms? const Text('Terms & Condition') : const Text('Privacy policy'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 15),
          child: isTerms? Text(style: h3.copyWith(height: 2,fontSize: 14),
            'Welcome to Gameplan AI, owned and operated by GAMEPLAN APPS LTD (“Company,” “we,” “us,” or “our”). These Terms of Service (“Terms”) govern your use of our mobile application, website, and related services (collectively, the “Platform”). By accessing or using the Platform, you agree to be bound by these Terms and our Privacy Policy. To use the Platform, you must be at least 18 years old or the age of majority in your jurisdiction, have the authority to enter into a binding agreement, and comply with all applicable laws. You are responsible for maintaining the confidentiality of your login credentials and agree to notify us immediately of any unauthorized access to your account. We may collect, store, and process your data as described in our Privacy Policy and comply with global data protection laws, including GDPR and CCPA. Payments for certain features must comply with our Refund Policy, and subscriptions auto-renew unless canceled. All content on the Platform is owned or licensed by us, and unauthorized use is prohibited. We are not liable for third-party services integrated with the Platform or for indirect damages, and our total liability is limited to amounts paid by you in the past 12 months. The Platform is provided “as is” without warranties, and we reserve the right to suspend or terminate accounts for violations. These Terms are governed by the laws of [your country/state], and disputes are resolved exclusively in [your jurisdiction]. We may update these Terms from time to time, and significant changes will be communicated via the Platform or email. For questions, contact us at [Insert Email Address]. By using the Platform, you acknowledge that you have read, understood, and agreed to these Terms.',
          ) : 
          Text(style: h3.copyWith(height: 2,fontSize: 14) ,
              'At Gameplan (“we,” “us,” or “our”), we are committed to protecting your privacy and ensuring the security of your personal information. This Privacy Policy explains how we collect, use, store, and share your data when you use our mobile application, website, and related services (collectively, the “Platform”). We collect personal data such as your name, email address, payment details, and usage information to provide and improve our services, as described in this policy. We may share your information with third-party service providers for purposes such as payment processing, analytics, and customer support, and we ensure that they comply with applicable privacy laws. Your data is processed in accordance with global data protection regulations, including the General Data Protection Regulation (GDPR) and the California Consumer Privacy Act (CCPA), and you have rights to access, correct, delete, or restrict your data. We use industry-standard measures to protect your data but cannot guarantee absolute security. By using the Platform, you consent to the collection and processing of your information as outlined in this policy. If you are under the age of 18, you may only use the Platform with parental consent. This Privacy Policy may be updated periodically, and significant changes will be communicated through the Platform or via email. For questions or to exercise your rights, contact us at support@gameplanai.co.uk'),
        ),
      ),
    );
  }
}
