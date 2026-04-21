import 'package:flutter/material.dart';
import '../../../../../core/dimensions/dimensions_constants.dart';
import '../../../../../core/widgets/title_text.dart';

class MessagesStatisticsHeader extends StatelessWidget {
  final String title;

  const MessagesStatisticsHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: edge, vertical: edge * 0.8),
      child: TitleText(
        text: title,
        color: Colors.white,
        fontSize: 20,
      ),
    );
  }
}
