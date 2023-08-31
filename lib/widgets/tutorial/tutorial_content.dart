import 'package:flutter/material.dart';
import 'package:frontend/screens/feedback_screen.dart';
import 'package:frontend/widgets/_archive/login_details.dart';
import 'package:frontend/widgets/tutorial/mock_add_algorithm_button.dart';
import 'package:frontend/widgets/tutorial/mock_submit_button.dart';
import 'package:frontend/widgets/tutorial/mock_tags_input.dart';
import 'package:frontend/widgets/tutorial/mock_verify_button.dart';

class TutorialContent extends StatelessWidget {
  const TutorialContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 25.0),
          Text(
            'How to Contribute an Algorithm?',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const _Step(
              text: '1. Accessing the Input Screen',
              description:
                  'Tap the button in the top right corner of the screen to open the input form (represented by a plus icon).'),
          const MockAlgorithmButton(),
          const _Step(
              text: '2. Fill in the Form',
              description: 'Complete all the required fields in the form.'),
          const _Step(
              text: '3. Verify Your Code',
              description:
                  'Before submission, ensure your code is valid, by pressing the verify button. It ensures that your code is compatible with geemap package and Google Earth Engine API. Beware though, that not all valid codes are currently accepted. If your code is valid, but not accepted, please provide feedback.'),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [MockVerifyButton()],
          ),
          const _Step(
              text: '4. Verification Feedback',
              description:
                  'If valid, the verify button will turn green with a checkmark. If invalid, it will turn red with a cross. Clear text on the button indicates the code needs re-verification.'),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MockVerifyButton(isValid: true),
              MockVerifyButton(isValid: false)
            ],
          ),
          const _Step(
              text: '5. Adding Tags',
              description:
                  'When adding tags, search for the desired tag by typing it in the "Search for tags" field and select from available options. Feel free to try with the mock tag selector below! If needed, provide feedback or choose the closest relevant tag.'),
          const MockTagsInput(),
          const _Step(
              text: '6. Submission',
              description:
                  'Once all fields are filled and code is verified, submit it. The submit button should be active; if grayed out, the code is not yet verified.'),
          const MockSubmit(),
          const _Step(
              text: '7. Post-Submission',
              description:
                  'After submission, you\'ll be redirected to the catalogue screen. It takes a few minutes to process and add the code. Feel free to browse other algorithms during this time.'),
          const _Step(
              text: '8. Review and Edit',
              description:
                  'To review, access the submission form via the top right corner button. For edits, visit your profile\'s contributions tab. Deletion is also possible in the contributions section.'),
          const _Step(
              text: '9. Submission Status',
              description:
                  'Successful submissions display a green message at the screen\'s bottom. Unsuccessful attempts result in a red message and return to the input screen.'),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15.0),
              TextButton(
                child: Text(
                  '10. Questions and Feedback',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold, color: googleBlue),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const FeedbackScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8.0),
              const Text(
                  'For inquiries or suggestions, use the feedback form to get in touch with us.'),
            ],
          ),
          const SizedBox(height: 100.0),
        ],
      ),
    );
  }
}

class _Step extends StatelessWidget {
  final String text;
  final String description;

  const _Step({required this.text, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15.0),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            text,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8.0),
        Text(description),
      ],
    );
  }
}
