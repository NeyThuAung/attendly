import 'package:flutter/material.dart';
import 'package:attendly/shared/styles/styles.dart';

class LoadingBody extends StatelessWidget {
  const LoadingBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: $styles.color.clrPrimary,
      ),
    );
  }
}
