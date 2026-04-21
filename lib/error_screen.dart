import 'package:app/core/theming/colors.dart';
import 'package:app/core/widgets/title_text.dart';
import 'package:flutter/material.dart';

class ErrorDisplayScreen extends StatelessWidget {
  final String errorMessage;
  final String stackTrace;

  const ErrorDisplayScreen({
    super.key,
    required this.errorMessage,
    required this.stackTrace,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: TitleText(
            text: 'App Error',
            color: Colors.white,
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: const Icon(Icons.error_outline,
                      color: Colors.red, size: 64)),
              const SizedBox(height: 16),
              const Text(
                'An error occurred',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Error: $errorMessage',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Text(
                'Stack Trace:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.grey[200],
                child: Text(
                  stackTrace,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Please take a screenshot and send it to the development team.',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
