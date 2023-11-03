import 'package:flutter/material.dart';
import 'package:fraction/feedbackform/services/feedbackform_services.dart';
import 'package:fraction/utils/constants.dart';

class FeedbackFormScreen extends StatefulWidget {
  const FeedbackFormScreen({super.key});

  @override
  State<StatefulWidget> createState() => _FeedbackFormScreenState();
}

class _FeedbackFormScreenState extends State<FeedbackFormScreen> {
  final _feedbackController = TextEditingController();

  late GlobalKey<FormState> _feedbackFormKey;
  late FeedbackFormServices _feedbackFormServices;

  @override
  void initState() {
    _feedbackFormKey = GlobalKey<FormState>();
    _feedbackFormServices = FeedbackFormServices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Feedback'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: FractionallySizedBox(
              widthFactor: 0.9,
              child: Form(
                key: _feedbackFormKey,
                child: Column(
                  children: [
                    const Text(
                      'How can we improve ?',
                      style: TextStyle(fontSize: 20),
                    ),
                    Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextFormField(
                        controller: _feedbackController,
                        keyboardType: TextInputType.multiline,
                        minLines: 4,
                        maxLines: 10,
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                      ),
                    ),
                    FilledButton(
                        onPressed: () {
                          _feedbackFormServices
                              .addFeedback(feedback: _feedbackController.text)
                              .then((result) {
                            if (result == Constants().success) {
                              _feedbackController.clear();

                              showDialog(
                                context: context,
                                builder: (context) {
                                  return const AlertDialog(
                                    icon: Icon(
                                      Icons.check_circle_rounded,
                                      color: Colors.green,
                                    ),
                                  );
                                },
                              );
                            }
                          });
                        },
                        child: const Text('Submit'))
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
