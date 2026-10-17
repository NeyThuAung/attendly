import 'package:flutter/material.dart';

extension IntSizedBoxExtension on num {
  Widget get heightBox => SizedBox(height: toDouble());
  Widget get widthBox => SizedBox(width: toDouble());

  SizedBox get toWidthSizedBox => SizedBox(width: toDouble());
  SizedBox get toHeightSizedBox => SizedBox(height: toDouble());
}
