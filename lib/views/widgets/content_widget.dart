import 'package:flutter/material.dart';
import 'package:weather_app/views/widgets/bottom_content_widget.dart';
import 'package:weather_app/views/widgets/top_content_widget.dart';

class ContentWidget extends StatelessWidget {
  const ContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 60.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [TopContentWidget(), BottomContentWidget()],
        ),
      ),
    );
  }
}
