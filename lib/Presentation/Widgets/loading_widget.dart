import 'package:flutter/material.dart';

class LoadingWdg extends StatelessWidget {
  const LoadingWdg({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        CircularProgressIndicator(),
        SizedBox(height: 10),
        Text('Loading...'),
      ],
    );
  }
}
