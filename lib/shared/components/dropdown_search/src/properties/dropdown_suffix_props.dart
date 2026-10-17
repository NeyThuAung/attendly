import 'package:flutter/material.dart';

import 'clear_button_props.dart';
import 'dropdown_props.dart';

class DropdownSuffixProps {
  final ClearButtonProps clearButtonProps;
  final DropdownButtonProps dropdownButtonProps;
  final TextDirection? direction;

  const DropdownSuffixProps({
    this.clearButtonProps = const ClearButtonProps(),
    this.dropdownButtonProps = const DropdownButtonProps(),
    this.direction = TextDirection.ltr,
  });
}
