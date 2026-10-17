import 'package:flutter/material.dart';

import 'icon_button_props.dart';

class DropdownButtonProps extends IconButtonProps {
  final Widget iconOpened;

  const DropdownButtonProps({
    this.iconOpened = const Icon(Icons.arrow_drop_up, size: 24),
    Widget iconClosed = const Icon(Icons.arrow_drop_down, size: 24),
    super.isVisible = true,
    super.iconSize,
    super.visualDensity,
    super.padding,
    super.alignment,
    super.splashRadius,
    super.color,
    super.focusColor,
    super.hoverColor,
    super.highlightColor,
    super.splashColor,
    super.disabledColor,
    super.mouseCursor,
    super.focusNode,
    super.autofocus,
    super.tooltip,
    super.enableFeedback,
    super.constraints,
    super.style,
    super.isSelected,
    super.selectedIcon,
  }) : super(icon: iconClosed);
}

class ClickProps {
  final GestureTapDownCallback? onTapDown;
  final GestureTapUpCallback? onTapUp;
  final GestureTapCallback? onTapCancel;
  final GestureTapCallback? onDoubleTap;
  final GestureLongPressCallback? onLongPress;
  final GestureTapCallback? onSecondaryTap;
  final GestureTapDownCallback? onSecondaryTapDown;
  final GestureTapUpCallback? onSecondaryTapUp;
  final GestureTapCallback? onSecondaryTapCancel;
  final ValueChanged<bool>? onHighlightChanged;
  final ValueChanged<bool>? onHover;
  final MouseCursor? mouseCursor;
  final bool containedInkWell;
  final BoxShape highlightShape;
  final double? radius;
  final BorderRadius? borderRadius;
  final ShapeBorder? customBorder;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? highlightColor;
  final WidgetStateProperty<Color?>? overlayColor;
  final Color? splashColor;
  final InteractiveInkFeatureFactory? splashFactory;
  final bool enableFeedback;
  final bool excludeFromSemantics;
  final ValueChanged<bool>? onFocusChange;
  final bool autofocus;
  final FocusNode? focusNode;
  final bool canRequestFocus;
  RectCallback? getRectCallback(RenderBox referenceBox) => null;
  final WidgetStatesController? statesController;
  final Duration? hoverDuration;

  const ClickProps({
    this.containedInkWell = true,
    this.highlightShape = BoxShape.rectangle,
    this.onFocusChange,
    this.focusNode,
    this.statesController,
    this.borderRadius,
    this.customBorder,
    this.enableFeedback = true,
    this.excludeFromSemantics = false,
    this.splashFactory,
    this.autofocus = false,
    this.canRequestFocus = true,
    this.focusColor,
    this.highlightColor,
    this.hoverColor,
    this.hoverDuration,
    this.mouseCursor,
    this.onDoubleTap,
    this.onHover,
    this.onSecondaryTap,
    this.onLongPress,
    this.onSecondaryTapCancel,
    this.onSecondaryTapDown,
    this.onSecondaryTapUp,
    this.overlayColor,
    this.radius,
    this.splashColor,
    this.onHighlightChanged,
    this.onTapCancel,
    this.onTapUp,
    this.onTapDown,
  });
}

class DropDownDecoratorProps {
  final InputDecoration decoration;
  final TextStyle? baseStyle;
  final TextAlign? textAlign;
  final TextAlignVertical? textAlignVertical;
  final bool expands;
  final bool isHovering;

  const DropDownDecoratorProps({
    this.decoration = const InputDecoration(
      contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
      border: OutlineInputBorder(),
    ),
    this.baseStyle,
    this.textAlign,
    this.textAlignVertical,
    this.expands = false,
    this.isHovering = false,
  });
}
