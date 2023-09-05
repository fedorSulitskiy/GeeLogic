import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:frontend/app_theme.dart';
import 'package:frontend/widgets/feedback/submit_button.dart';

const double inputWidth = 800.0;

var _enteredName = '';
var _enteredEmail = '';
var _enteredTitle = '';
var _enteredMessage = '';

/// Widget that helps in organizing the feedback screen.
class FeedbackContent extends StatefulWidget {
  const FeedbackContent({super.key});

  @override
  State<FeedbackContent> createState() => _FeedbackContentState();
}

class _FeedbackContentState extends State<FeedbackContent> {
  final _feedbackKey = GlobalKey<FormState>();

  /// Error message snack bar
  SnackBar snackBar({
    required Color color,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return SnackBar(
      backgroundColor: color,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 45.0,
          ),
          const SizedBox(width: 5.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(
                subtitle,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.white),
              ),
            ],
          )
        ],
      ),
    );
  }

  /// The [sendEmail] function sends an email using the EmailJS API by making a POST request to the
  /// specified URL with the provided parameters.
  ///
  /// Args:
  ///   - `name` (String): The name of the recipient of the email.
  ///   - `email` (String): The "email" parameter is a required string that represents the recipient's email
  /// address.
  ///   - `title` (String): The "title" parameter is used to specify the subject or title of the email that
  /// will be sent.
  ///   - `message` (String): The "message" parameter is a required string that represents the content of
  /// the email message that you want to send. It can contain any text you want to include in the email.
  void sendEmail({
    required String name,
    required String email,
    required String title,
    required String message,
  }) async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final headers = {"Content-Type": "application/json"};
    final body = json.encode({
      "service_id": "service_li3yaya",
      "template_id": "template_k7qavgq",
      "user_id": "9qj_p_3g77bNYkIUd",
      "template_params": {
        "user_name": name,
        "user_email": email,
        "email_title": title,
        "email_message": message,
      }
    });
    await http.post(
      url,
      headers: headers,
      body: body,
    );
  }

  /// The [submit] function validates user inputs, displays a snackbar if inputs are invalid, saves the
  /// inputs and sends an email if inputs are valid, and displays a snackbar to notify the user that
  /// their feedback has been sent.
  ///
  /// Returns:
  ///   'nothing' (void).
  void submit() async {
    // Validate.
    final isValid = _feedbackKey.currentState!.validate();

    // In case user's inputs aren't valid, display a snackbar and return.
    if (!isValid) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        snackBar(
          color: GeeLogicColourScheme.red,
          icon: Icons.warning_amber_rounded,
          title: 'Message NOT sent!',
          subtitle:
              'Apologies, but your input is invalid, please check input fields.',
        ),
      );
      return;
    }

    // In case user's inputs are valid, save them and send the email.
    _feedbackKey.currentState!.save();

    // Trigger send function.
    sendEmail(
      name: _enteredName,
      email: _enteredEmail,
      title: _enteredTitle,
      message: _enteredMessage,
    );

    // Let user know that their feedback has been sent.
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      snackBar(
        color: GeeLogicColourScheme.green,
        icon: Icons.mark_email_read_rounded,
        title: 'Feedback sent!',
        subtitle:
            'Your feedback has been successufully sent to the GeeLogic team!',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _feedbackKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50.0),

            // PAGE TITLE
            Text(
              'Please let us know what you think!',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 50.0),

            // NAME INPUT
            _InputField(
              title: 'name',
              onSaved: (value) {
                _enteredName = value!;
              },
            ),
            const SizedBox(height: 20.0),

            // EMAIL INPUT
            _InputField(
              title: 'email',
              isEmail: true,
              onSaved: (value) {
                _enteredEmail = value!;
              },
            ),
            const SizedBox(height: 30.0),

            // TITLE INPUT
            _InputField(
              title: 'title',
              bottomRadius: 0.0,
              onSaved: (value) {
                _enteredTitle = value!;
              },
            ),

            // MESSAGE INPUT (JOINT WITH TITLE)
            _InputField(
              title: 'message',
              minLines: 5,
              maxLines: null,
              topRadius: 0.0,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              onSaved: (value) {
                _enteredMessage = value!;
              },
            ),
            const SizedBox(height: 30.0),

            // SUBMIT BUTTON
            SubmitButton(
              onPressed: submit,
            ),
            const SizedBox(height: 200.0),
          ],
        ),
      ),
    );
  }
}

/// The [_InputField] class is a customizable text input field widget in Dart that includes validation
/// for empty values and email format.
class _InputField extends StatelessWidget {
  const _InputField(
      {required this.title,
      required this.onSaved,
      this.minLines = 1,
      this.maxLines = 1,
      this.topRadius = 20.0,
      this.bottomRadius = 20.0,
      this.floatingLabelBehavior = FloatingLabelBehavior.auto,
      this.isEmail = false});

  final String title;
  final void Function(String?) onSaved;
  final int minLines;
  final int? maxLines;
  final double topRadius;
  final double bottomRadius;
  final FloatingLabelBehavior floatingLabelBehavior;
  final bool isEmail;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: GeeLogicColourScheme.blue,
      decoration: InputDecoration(
        labelText: title,
        floatingLabelBehavior: floatingLabelBehavior,
        floatingLabelStyle: const TextStyle(color: GeeLogicColourScheme.blue),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: GeeLogicColourScheme.blue),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(topRadius),
            topRight: Radius.circular(topRadius),
            bottomLeft: Radius.circular(bottomRadius),
            bottomRight: Radius.circular(bottomRadius),
          ),
        ),
        constraints: const BoxConstraints(
          maxWidth: inputWidth,
        ),
      ),
      autocorrect: true,
      textCapitalization: TextCapitalization.sentences,
      minLines: minLines,
      maxLines: maxLines,
      validator: (value) {
        // Ensure all values are full.
        if (value == null || value.isEmpty) {
          return '$title must not be empty';
        }

        // If [TextFormField] is email, then validate it.
        if (isEmail) {
          final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
          if (!emailRegExp.hasMatch(value)) {
            return 'Please enter a valid email address.';
          }
        }

        // If all is well then send null.
        return null;
      },
      onSaved: onSaved,
    );
  }
}
