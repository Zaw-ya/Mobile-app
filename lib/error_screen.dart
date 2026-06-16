import 'package:app/core/theming/colors.dart';
import 'package:app/core/widgets/title_text.dart';
import 'package:app/generated/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
              Text(
                'An error occurred',
                style: TextStyle(fontFamily: FontFamily.manchetteFine, fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Error: $errorMessage',
                style: TextStyle(fontFamily: FontFamily.manchetteFine, fontSize: 16.sp),
              ),
              const SizedBox(height: 16),
              Text(
                'Stack Trace:',
                style: TextStyle(fontFamily: FontFamily.manchetteFine, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.grey[200],
                child: Text(
                  stackTrace,
                  style: TextStyle(fontFamily: FontFamily.manchetteFine, fontSize: 12.sp),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Please take a screenshot and send it to the development team.',
                style: TextStyle(fontFamily: FontFamily.manchetteFine, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
