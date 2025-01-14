import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/customFont.dart';
import '../../../../common/widgets/profile/faqWidget.dart';
import 'package:agcourt/app/modules/profile/controllers/profile_controller.dart';

class FaqView extends GetView<ProfileController> {
  final int selectedIndex;

  FaqView({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    // Ensure the controller is available
    final controller = Get.put(ProfileController());

    // Set the initial selected index in the controller
    controller.setSelectedFAQIndex(selectedIndex);

    return Scaffold(
      appBar: AppBar(
        title: Text('FAQ', style: h1),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              FaqWidget(
                index: 0,
                question: 'What should I tell the AI to get the best session plan?',
                answer: 'The more specific you are, the better the results. We encourage you to type exactly the session you want to teach, excluding no details. \nStart with these basics: \n\n• The sport you coach (e.g., soccer, basketball, etc.). \n• The focus of your session (e.g., dribbling, fitness, defense). \n• Your team’s age group and skill level (e.g., beginner U12 team). \n• The duration of your session (e.g., 60 minutes). \n• If your session has a theme feel free to add this in as well.For example, say: “Plan a 1-hour soccer session for 10-year-old beginners focusing on ball control and fun.” \n\nOr \n\n‘’Plan a 45 minute gymnastics session. The average age of the gymnasts is 7 years old. Plan at least 5 different stations. Include a warm-up and cool down. The theme for the week is animals’ \n\nAlternatively, if you just want specific drill ideas to work on a specific skill, you could type: \n\n“Give me 5 different drills to help my gymnast achieve a back handspring. The gymnast is 10 years old and is a complete beginner”. ',
              ),
              FaqWidget(
                index: 1,
                question: 'Can I plan more than 1 session at a time?',
                answer: 'Yes! We understand that as coaches, often you are planning multi-week or termly progressions. Simply state this in your initial message and get a multi-session plan. For example:\n\n‘’Provide me with a 5-week gymnastics plan focused on achieving an up-start on bars. The gymnasts are between the ages of 10-12. Currently the gymnasts can perform a dead hang from the bar. Each session should be roughly 45 minutes in length.’’ ',
              ),
              FaqWidget(
                index: 2,
                question: 'What if the AI doesn\'t give me an appropriate session plan?',
                answer: 'If you don\'t get the result you wanted, continue to ask questions until you have a session plan that works for you.\n\nFor example, if the results of: “Plan a 1-hour soccer session for 10-year-old beginners focusing on ball control and fun.” were too advanced, you could type:\n\n‘’This session was too advanced for the kids I teach, please give me a session with more basic skills’’ \n\nOr, If: \n\n‘’Plan a 45 minute gymnastics session. The average age of the gymnasts is 7 years old. Plan at least 5 different stations. Include a warm-up and cool down. The theme for the week is animals’’ gave you a result with a station including apparatus you dont have in the gym, simply say: \n\n‘’We don’t have a high bar in the gym, please provide an alternative exercise’’.\n\nYou can go back and forth as many times as you like until you have the perfect session.\n\nAdditionally, you can manually edit the response with ease in the editor by clicking the ‘Edit’ button.',
              ),
              FaqWidget(
                index: 3,
                question: 'What is gameplan, and how can it help me as a coach?',
                answer: 'gameplan uses advanced AI to help sports coaches quickly plan effective training sessions for their teams. By understanding your needs—such as the age, skill level, and focus area of your players—the AI suggests drills, exercises, and session plans tailored to your goals. It saves time and ensures your sessions are engaging and productive. ',
              ),
              FaqWidget(
                index: 4,
                question: 'Can I edit or customize the AI-generated session plan?',
                answer: 'Yes! Once the AI generates your session plan, you can make adjustments. You can easily edit the response given by clicking the ‘Edit’ button located below the response. You can also ‘Pin’ the generated session plan to the specific time and date you will be coaching the session, or save the chat to a specific class.',
              ),
              FaqWidget(
                index: 5,
                question: 'Will the AI understand my coaching goals if I use simple language?',
                answer: 'Absolutely! The AI is designed to understand everyday language. You can type instructions as simple as, “Make a fitness-focused session for teenage basketball players,” and it will know what you mean. We do encourage you to be as specific as possible but there is absolutely no need for technical or complex terms.',
              ),
              FaqWidget(
                index: 6,
                question: 'Can I use this app/website offline or on the go?',
                answer: 'The app is designed for flexibility. While some features require an internet connection (like generating AI sessions), you can save session plans in advance to access them offline—perfect for when you\'re on the field or in a gym without Wi-Fi. ',
              ),
              FaqWidget(
                index: 7,
                question: 'How accurate or reliable is the AI’s session planning?',
                answer: 'The AI has been trained using vast amounts of sports coaching knowledge, best practices, and proven drills. However, it’s still a tool—you’re the expert coach! Use the AI as a helpful assistant, and feel free to adjust its suggestions to meet your team’s unique needs.',
              ),
              FaqWidget(
                index: 8,
                question: 'Is this app/website suitable for coaches at all levels?',
                answer: 'Yes! Whether you’re a beginner coaching your child’s team or an experienced professional, the app adapts to your needs. It can provide basic drills for beginners or advanced, strategy-focused sessions for elite teams.',
              ),
              FaqWidget(
                index: 9,
                question: 'How can I save my session plans?',
                answer: 'All your recent chats and plans with the AI are automatically saved and can be easily accessed in the ‘History’ section on the mobile app, and under ‘Recent plans’ on the website. If you want to highlight a specific chat, you can click the save button and then easily filter for this chat in the future. If you’ve set up a list of classes, you also have the ability to save the plan to a specific class of yours.',
              ),
              FaqWidget(
                index: 10,
                question: 'I have a different question, what should I do?',
                answer: 'Please use the help and support page to contact us and our team will be happy to assist you as soon as possible. Alternatively, you can email us directly at support@gameplanai.co.uk',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
