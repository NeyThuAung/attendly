import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'src/properties/dropdown_props.dart';
import 'src/properties/dropdown_suffix_props.dart';
import 'src/properties/infinite_scroll_props.dart';
import 'src/properties/popup_props.dart';
import 'src/properties/scroll_props.dart';
import 'src/utils.dart';
import 'src/widgets/custom_icon_button.dart';
import 'src/widgets/custom_inkwell.dart';
import 'src/widgets/custom_scroll_view.dart';
import 'src/widgets/popup_menu.dart';
import 'src/widgets/dropdown_search_popup.dart';

export 'src/properties/bottom_sheet_props.dart';
export 'src/properties/clear_button_props.dart';
export 'src/properties/dialog_props.dart';
export 'src/properties/dropdown_props.dart';
export 'src/properties/suggested_item_props.dart';
export 'src/properties/icon_button_props.dart';
export 'src/properties/list_view_props.dart';
export 'src/properties/menu_props.dart';
export 'src/properties/modal_bottom_sheet_props.dart';
export 'src/properties/popup_props.dart';
export 'src/properties/scrollbar_props.dart';
export 'src/properties/text_field_props.dart';
export 'src/properties/infinite_scroll_props.dart';
export 'src/properties/scroll_props.dart';
export 'src/widgets/dropdown_search_popup.dart';
export 'src/properties/dropdown_suffix_props.dart';

typedef DropdownSearchOnFind<T> = FutureOr<List<T>> Function(
    String filter, LoadProps? loadProps);
typedef DropdownSearchItemAsString<T> = String Function(T item);
typedef DropdownSearchFilterFn<T> = bool Function(T item, String filter);
typedef DropdownSearchCompareFn<T> = bool Function(T item1, T item2);
typedef DropdownSearchBuilder<T> = Widget Function(
    BuildContext context, T? selectedItem);
typedef DropdownSearchBuilderMultiSelection<T> = Widget Function(
    BuildContext context, List<T> selectedItems);
typedef DropdownSearchPopupItemBuilder<T> = Widget Function(
    BuildContext context, T item, bool isDisabled, bool isSelected);
typedef DropdownSearchPopupItemEnabled<T> = bool Function(T item);
typedef ErrorBuilder<T> = Widget Function(
    BuildContext context, String searchEntry, dynamic exception);
typedef EmptyBuilder<T> = Widget Function(
    BuildContext context, String searchEntry);
typedef LoadingBuilder<T> = Widget Function(
    BuildContext context, String searchEntry);
typedef BeforeChange<T> = Future<bool?> Function(T? prevItem, T? nextItem);
typedef BeforePopupOpening<T> = Future<bool?> Function(T? selectedItem);
typedef BeforePopupOpeningMultiSelection<T> = Future<bool?> Function(
    List<T> selectedItem);
typedef BeforeChangeMultiSelection<T> = Future<bool?> Function(
    List<T> prevItems, List<T> nextItems);
typedef FavoriteItemsBuilder<T> = Widget Function(
    BuildContext context, T item, bool isSelected);
typedef ValidationMultiSelectionBuilder<T> = Widget Function(
    BuildContext context, List<T> items);
typedef PositionCallback = RelativeRect Function(
    RenderBox dropdownBox, RenderBox overlay);
typedef OnItemAdded<T> = void Function(List<T> selectedItems, T addedItem);
typedef OnItemRemoved<T> = void Function(List<T> selectedItems, T removedItem);
typedef PopupBuilder<T> = Widget Function(
    BuildContext context, Widget popupWidget);

typedef SuggestedItems<T> = List<T> Function(List<T> items);

enum PopupMode { dialog, modalBottomSheet, menu, bottomSheet }

enum Mode { form, custom }

class DropdownSearch<T> extends StatefulWidget {
  final List<T> selectedItems;
  final DropdownSearchOnFind<T>? items;
  final ValueChanged<T?>? onChanged;
  final ValueChanged<List<T>>? onChangedMultiSelection;
  final DropdownSearchBuilder<T>? dropdownBuilder;
  final DropdownSearchBuilderMultiSelection<T>? dropdownBuilderMultiSelection;
  final ScrollProps? selectedItemsScrollProps;
  final DropdownSearchItemAsString<T>? itemAsString;
  final DropdownSearchFilterFn<T>? filterFn;
  final bool enabled;
  final DropdownSearchCompareFn<T>? compareFn;
  final AutovalidateMode? autoValidateMode;
  final FormFieldSetter<T>? onSaved;
  final FormFieldSetter<List<T>>? onSavedMultiSelection;
  final FormFieldValidator<T>? validator;
  final FormFieldValidator<List<T>>? validatorMultiSelection;
  final BeforeChange<T>? onBeforeChange;
  final BeforeChangeMultiSelection<T>? onBeforeChangeMultiSelection;
  final bool isMultiSelectionMode;
  final DropdownSuffixProps suffixProps;
  final ClickProps clickProps;
  final PopupPropsMultiSelection<T> popupProps;
  final DropDownDecoratorProps decoratorProps;
  final BeforePopupOpening<T>? onBeforePopupOpening;
  final BeforePopupOpeningMultiSelection<T>? onBeforePopupOpeningMultiSelection;
  final Mode mode;

  DropdownSearch({
    super.key,
    T? selectedItem,
    this.mode = Mode.form,
    this.autoValidateMode = AutovalidateMode.disabled,
    this.onChanged,
    this.items,
    this.dropdownBuilder,
    this.suffixProps = const DropdownSuffixProps(),
    this.clickProps = const ClickProps(),
    this.enabled = true,
    this.filterFn,
    this.itemAsString,
    this.compareFn,
    this.onBeforeChange,
    this.onBeforePopupOpening,
    PopupProps<T> popupProps = const PopupProps.menu(),
    this.onSaved,
    this.validator,
    DropDownDecoratorProps? decoratorProps,
  })  : assert(
          T == String || T == int || T == double || compareFn != null,
          '`compareFn` is required',
        ),
        assert(
          mode != Mode.custom || dropdownBuilder != null,
          'Please implement your `dropdownBuilder`',
        ),
        assert(
          mode != Mode.custom ||
              (decoratorProps == null && onSaved == null && validator == null),
          'Custom mode has no form properties',
        ),
        decoratorProps = decoratorProps ?? const DropDownDecoratorProps(),
        selectedItems = _itemToList(selectedItem),
        popupProps = PopupPropsMultiSelection.from(popupProps),
        isMultiSelectionMode = false,
        dropdownBuilderMultiSelection = null,
        validatorMultiSelection = null,
        onBeforeChangeMultiSelection = null,
        onSavedMultiSelection = null,
        onChangedMultiSelection = null,
        onBeforePopupOpeningMultiSelection = null,
        selectedItemsScrollProps = null;

  const DropdownSearch.multiSelection({
    super.key,
    this.mode = Mode.form,
    this.autoValidateMode = AutovalidateMode.disabled,
    this.items,
    this.suffixProps = const DropdownSuffixProps(),
    this.clickProps = const ClickProps(),
    this.enabled = true,
    this.filterFn,
    this.itemAsString,
    this.compareFn,
    this.selectedItems = const [],
    this.popupProps = const PopupPropsMultiSelection.menu(),
    this.selectedItemsScrollProps,
    ValueChanged<List<T>>? onChanged,
    BeforeChangeMultiSelection<T>? onBeforeChange,
    BeforePopupOpeningMultiSelection<T>? onBeforePopupOpening,
    DropdownSearchBuilderMultiSelection<T>? dropdownBuilder,
    FormFieldSetter<List<T>>? onSaved,
    FormFieldValidator<List<T>>? validator,
    DropDownDecoratorProps? decoratorProps,
  })  : assert(
          T == String || T == int || T == double || compareFn != null,
          '`compareFn` is required',
        ),
        assert(
          mode != Mode.custom || dropdownBuilder != null,
          'Please implement your `dropdownBuilder`',
        ),
        assert(
          mode != Mode.custom ||
              (decoratorProps == null && onSaved == null && validator == null),
          "Custom mode has no form properties",
        ),
        decoratorProps = decoratorProps ?? const DropDownDecoratorProps(),
        onChangedMultiSelection = onChanged,
        onBeforePopupOpeningMultiSelection = onBeforePopupOpening,
        onSavedMultiSelection = onSaved,
        onBeforeChangeMultiSelection = onBeforeChange,
        validatorMultiSelection = validator,
        dropdownBuilderMultiSelection = dropdownBuilder,
        isMultiSelectionMode = true,
        dropdownBuilder = null,
        validator = null,
        onBeforeChange = null,
        onSaved = null,
        onChanged = null,
        onBeforePopupOpening = null;

  static List<T> _itemToList<T>(T? item) {
    List<T?> nullableList = List.filled(1, item);
    return nullableList.whereType<T>().toList();
  }

  @override
  DropdownSearchState<T> createState() => DropdownSearchState<T>();
}

class DropdownSearchState<T> extends State<DropdownSearch<T>> {
  final ValueNotifier<List<T>> _selectedItemsNotifier = ValueNotifier([]);
  final ValueNotifier<bool> _isFocused = ValueNotifier(false);
  final _popupStateKey = GlobalKey<DropdownSearchPopupState<T>>();

  @override
  void initState() {
    super.initState();
    _selectedItemsNotifier.value = List.from(widget.selectedItems);
  }

  @override
  void didUpdateWidget(DropdownSearch<T> oldWidget) {
    if (!listEquals(oldWidget.selectedItems, widget.selectedItems)) {
      _selectedItemsNotifier.value = List.from(widget.selectedItems);
    }

    if (widget.popupProps.containerBuilder !=
        oldWidget.popupProps.containerBuilder) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _popupStateKey.currentState?.setState(() {});
      });
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<T>>(
      valueListenable: _selectedItemsNotifier,
      builder: (context, data, wt) {
        return IgnorePointer(
          ignoring: !widget.enabled,
          child: CustomInkWell(
            clickProps: widget.clickProps,
            onTap: () => _selectSearchMode(),
            child: _dropDown(),
          ),
        );
      },
    );
  }

  Widget _dropDown() {
    if (widget.mode == Mode.custom) {
      return _customField();
    } else {
      return _formField();
    }
  }

  Widget _defaultSelectedItemWidget() {
    Widget defaultItemMultiSelectionMode(T item) {
      return Container(
        padding: EdgeInsets.only(left: 8, right: 1),
        margin: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).primaryColorLight,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _itemAsString(item),
              style: Theme.of(context).textTheme.titleSmall,
              overflow: TextOverflow.ellipsis,
            ),
            Padding(padding: EdgeInsets.only(left: 8)),
            SizedBox(
              width: 32,
              height: 32,
              child: IconButton(
                iconSize: 20,
                padding: EdgeInsets.zero,
                icon: Icon(Icons.close_outlined, size: 20),
                onPressed: () => removeItem(item),
              ),
            )
          ],
        ),
      );
    }

    Widget selectedItemWidget() {
      if (widget.dropdownBuilder != null) {
        return widget.dropdownBuilder!(context, getSelectedItem);
      } else if (widget.dropdownBuilderMultiSelection != null) {
        return widget.dropdownBuilderMultiSelection!(context, getSelectedItems);
      } else if (isMultiSelectionMode) {
        return CustomSingleScrollView(
          scrollProps: widget.selectedItemsScrollProps ?? ScrollProps(),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: getSelectedItems
                .map((e) => defaultItemMultiSelectionMode(e))
                .toList(),
          ),
        );
      }
      return Text(
        _itemAsString(getSelectedItem),
        style: _getBaseTextStyle(),
        textAlign: widget.decoratorProps.textAlign,
      );
    }

    return selectedItemWidget();
  }

  TextStyle? _getBaseTextStyle() {
    return widget.enabled
        ? widget.decoratorProps.baseStyle
        : TextStyle(color: Theme.of(context).disabledColor)
            .merge(widget.decoratorProps.baseStyle);
  }

  Widget _formField() {
    return isMultiSelectionMode
        ? _formFieldMultiSelection()
        : _formFieldSingleSelection();
  }

  Widget _customField() => _defaultSelectedItemWidget();

  Widget _formFieldSingleSelection() {
    return FormField<T>(
      enabled: widget.enabled,
      onSaved: widget.onSaved,
      validator: widget.validator,
      autovalidateMode: widget.autoValidateMode,
      initialValue: getSelectedItem,
      builder: (FormFieldState<T> state) {
        if (state.value != getSelectedItem) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              state.didChange(getSelectedItem);
            }
          });
        }
        return ValueListenableBuilder<bool>(
            valueListenable: _isFocused,
            builder: (context, isFocused, w) {
              return InputDecorator(
                baseStyle: _getBaseTextStyle(),
                textAlign: widget.decoratorProps.textAlign,
                textAlignVertical: widget.decoratorProps.textAlignVertical,
                isEmpty: getSelectedItem == null,
                isFocused: isFocused,
                expands: widget.decoratorProps.expands,
                isHovering: widget.decoratorProps.isHovering,
                decoration: _manageDropdownDecoration(state),
                child: _defaultSelectedItemWidget(),
              );
            });
      },
    );
  }

  Widget _formFieldMultiSelection() {
    return FormField<List<T>>(
      enabled: widget.enabled,
      onSaved: widget.onSavedMultiSelection,
      validator: widget.validatorMultiSelection,
      autovalidateMode: widget.autoValidateMode,
      initialValue: widget.selectedItems,
      builder: (FormFieldState<List<T>> state) {
        if (!listEquals(state.value, getSelectedItems)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              state.didChange(getSelectedItems);
            }
          });
        }
        return ValueListenableBuilder<bool>(
            valueListenable: _isFocused,
            builder: (context, isFocused, w) {
              return InputDecorator(
                baseStyle: _getBaseTextStyle(),
                textAlign: widget.decoratorProps.textAlign,
                textAlignVertical: widget.decoratorProps.textAlignVertical,
                isEmpty: getSelectedItems.isEmpty,
                expands: widget.decoratorProps.expands,
                isHovering: widget.decoratorProps.isHovering,
                isFocused: isFocused,
                decoration: _manageDropdownDecoration(state),
                child: _defaultSelectedItemWidget(),
              );
            });
      },
    );
  }

  InputDecoration _manageDropdownDecoration(FormFieldState state) {
    return widget.decoratorProps.decoration
        .applyDefaults(Theme.of(state.context).inputDecorationTheme)
        .copyWith(
          enabled: widget.enabled,
          suffixIcon: _manageSuffixIcons(),
          errorText: state.errorText,
        );
  }

  String _itemAsString(T? data) {
    if (data == null) {
      return "";
    } else if (widget.itemAsString != null) {
      return widget.itemAsString!(data);
    }

    return data.toString();
  }

  Widget? _manageSuffixIcons() {
    clearButtonPressed() => clear();
    dropdownButtonPressed() => _selectSearchMode();

    if (!widget.suffixProps.dropdownButtonProps.isVisible &&
        !widget.suffixProps.clearButtonProps.isVisible) {
      return null;
    }

    return Row(
      textDirection: TextDirection.ltr,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        if (widget.suffixProps.clearButtonProps.isVisible &&
            getSelectedItems.isNotEmpty)
          CustomIconButton(
              props: widget.suffixProps.clearButtonProps,
              onPressed: clearButtonPressed),
        if (widget.suffixProps.dropdownButtonProps.isVisible)
          CustomIconButton(
            props: widget.suffixProps.dropdownButtonProps,
            icon: isFocused
                ? widget.suffixProps.dropdownButtonProps.iconOpened
                : widget.suffixProps.dropdownButtonProps.icon,
            onPressed: dropdownButtonPressed,
          ),
      ],
    );
  }

  RelativeRect _position(RenderBox dropdown, RenderBox overlay) {
    var menuMinWidth = widget.popupProps.constraints.minWidth;
    var menuMaxWidth = widget.popupProps.constraints.maxWidth;

    var menuMinHeight = widget.popupProps.constraints.minHeight;
    var menuMaxHeight = widget.popupProps.constraints.maxHeight;

    var menuWidth = dropdown.size.width;
    var menuHeight = 350.0;

    if (menuMinWidth > 0) {
      menuWidth = menuMinWidth;
    }
    if (menuMaxWidth > 0 && menuMaxWidth < menuWidth) {
      menuWidth = menuMaxWidth;
    }
    if (widget.mode == Mode.custom && dropdown.size.width < 64) {
      menuWidth = 180;
    }

    if (menuMinHeight > 0) {
      menuHeight = menuMinHeight;
    }
    if (menuMaxHeight > 0 && menuMaxHeight < menuHeight) {
      menuHeight = menuMaxHeight;
    }

    return getPosition(dropdown, overlay, Size(menuWidth, menuHeight),
        widget.popupProps.menuProps.align);
  }

  Future _openSelectDialog() {
    return showGeneralDialog(
      context: context,
      barrierDismissible: widget.popupProps.dialogProps.barrierDismissible,
      barrierLabel: widget.popupProps.dialogProps.barrierLabel,
      transitionDuration: widget.popupProps.dialogProps.transitionDuration,
      barrierColor:
          widget.popupProps.dialogProps.barrierColor ?? Colors.black54,
      useRootNavigator: widget.popupProps.dialogProps.useRootNavigator,
      anchorPoint: widget.popupProps.dialogProps.anchorPoint,
      transitionBuilder: widget.popupProps.dialogProps.transitionBuilder,
      pageBuilder: (context, animation, secondaryAnimation) {
        return AlertDialog(
          buttonPadding: widget.popupProps.dialogProps.buttonPadding,
          actionsOverflowButtonSpacing:
              widget.popupProps.dialogProps.actionsOverflowButtonSpacing,
          insetPadding: widget.popupProps.dialogProps.insetPadding,
          actionsPadding: widget.popupProps.dialogProps.actionsPadding,
          actionsOverflowDirection:
              widget.popupProps.dialogProps.actionsOverflowDirection,
          actionsOverflowAlignment:
              widget.popupProps.dialogProps.actionsOverflowAlignment,
          actionsAlignment: widget.popupProps.dialogProps.actionsAlignment,
          actions: widget.popupProps.dialogProps.actions,
          alignment: widget.popupProps.dialogProps.alignment,
          clipBehavior: widget.popupProps.dialogProps.clipBehavior,
          elevation: widget.popupProps.dialogProps.elevation,
          contentPadding: widget.popupProps.dialogProps.contentPadding,
          shape: widget.popupProps.dialogProps.shape,
          backgroundColor: widget.popupProps.dialogProps.backgroundColor,
          semanticLabel: widget.popupProps.dialogProps.semanticLabel,
          shadowColor: widget.popupProps.dialogProps.shadowColor,
          surfaceTintColor: widget.popupProps.dialogProps.surfaceTintColor,
          content: _popupWidgetInstance(),
        );
      },
    );
  }

  Future _openBottomSheet() {
    return showBottomSheet(
      context: context,
      showDragHandle: widget.popupProps.bottomSheetProps.showDragHandle,
      sheetAnimationStyle:
          widget.popupProps.bottomSheetProps.sheetAnimationStyle,
      enableDrag: widget.popupProps.bottomSheetProps.enableDrag,
      backgroundColor: widget.popupProps.bottomSheetProps.backgroundColor,
      clipBehavior: widget.popupProps.bottomSheetProps.clipBehavior,
      elevation: widget.popupProps.bottomSheetProps.elevation,
      shape: widget.popupProps.bottomSheetProps.shape,
      transitionAnimationController:
          widget.popupProps.bottomSheetProps.transitionAnimationController,
      constraints: widget.popupProps.bottomSheetProps.constraints,
      builder: (ctx) => _popupWidgetInstance(),
    ).closed;
  }

  Future _openModalBottomSheet() {
    final sheetTheme = Theme.of(context).bottomSheetTheme;
    return showModalBottomSheet<T>(
        context: context,
        barrierLabel: widget.popupProps.modalBottomSheetProps.barrierLabel,
        scrollControlDisabledMaxHeightRatio: widget.popupProps
            .modalBottomSheetProps.scrollControlDisabledMaxHeightRatio,
        showDragHandle: widget.popupProps.modalBottomSheetProps.showDragHandle,
        sheetAnimationStyle:
            widget.popupProps.modalBottomSheetProps.sheetAnimationStyle,
        useSafeArea: widget.popupProps.modalBottomSheetProps.useSafeArea,
        barrierColor: widget.popupProps.modalBottomSheetProps.barrierColor,
        backgroundColor:
            widget.popupProps.modalBottomSheetProps.backgroundColor ??
                sheetTheme.modalBackgroundColor ??
                sheetTheme.backgroundColor ??
                Colors.white,
        isDismissible:
            widget.popupProps.modalBottomSheetProps.barrierDismissible,
        isScrollControlled:
            widget.popupProps.modalBottomSheetProps.isScrollControlled,
        enableDrag: widget.popupProps.modalBottomSheetProps.enableDrag,
        clipBehavior: widget.popupProps.modalBottomSheetProps.clipBehavior,
        elevation: widget.popupProps.modalBottomSheetProps.elevation,
        shape: widget.popupProps.modalBottomSheetProps.shape,
        anchorPoint: widget.popupProps.modalBottomSheetProps.anchorPoint,
        useRootNavigator:
            widget.popupProps.modalBottomSheetProps.useRootNavigator,
        transitionAnimationController:
            widget.popupProps.modalBottomSheetProps.animation,
        constraints: widget.popupProps.modalBottomSheetProps.constraints,
        builder: (ctx) {
          return Container(
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: _popupWidgetInstance(),
          );
        });
  }

  Future _openMenu() {
    final dropdownObject = context.findRenderObject() as RenderBox;
    var overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    return showCustomMenu<T>(
      menuModeProps: widget.popupProps.menuProps,
      context: context,
      position: (widget.popupProps.menuProps.positionCallback ?? _position)(
          dropdownObject, overlay),
      child: _popupWidgetInstance(),
    );
  }

  Widget _popupWidgetInstance() {
    return DropdownSearchPopup<T>(
      key: _popupStateKey,
      popupProps: widget.popupProps,
      itemAsString: widget.itemAsString,
      filterFn: widget.filterFn,
      items: widget.items,
      onChanged: _handleOnChangeSelectedItems,
      compareFn: widget.compareFn,
      isMultiSelectionMode: isMultiSelectionMode,
      defaultSelectedItems: List.from(getSelectedItems),
    );
  }

  void _handleFocus(bool isFocused) {
    if (isFocused && !_isFocused.value) {
      FocusScope.of(context).unfocus();
      _isFocused.value = true;
    } else if (!isFocused && _isFocused.value) {
      _isFocused.value = false;
    }
  }

  void _handleOnChangeSelectedItems(List<T> selectedItems) {
    changeItem() {
      _selectedItemsNotifier.value = List.from(selectedItems);
      if (widget.onChanged != null) {
        widget.onChanged!(getSelectedItem);
      } else if (widget.onChangedMultiSelection != null) {
        widget.onChangedMultiSelection!(selectedItems);
      }
    }

    if (widget.onBeforeChange != null) {
      widget.onBeforeChange!(getSelectedItem,
              selectedItems.isEmpty ? null : selectedItems.first)
          .then((value) {
        if (value == true) {
          changeItem();
        }
      });
    } else if (widget.onBeforeChangeMultiSelection != null) {
      widget.onBeforeChangeMultiSelection!(getSelectedItems, selectedItems)
          .then((value) {
        if (value == true) {
          changeItem();
        }
      });
    } else {
      changeItem();
    }

    _handleFocus(false);
  }

  bool _isEqual(T i1, T i2) {
    if (widget.compareFn != null) {
      return widget.compareFn!(i1, i2);
    } else {
      return i1 == i2;
    }
  }

  Future<void> _selectSearchMode() async {
    if (_popupStateKey.currentState != null) return;

    if (widget.onBeforePopupOpening != null) {
      if (await widget.onBeforePopupOpening!(getSelectedItem) == false) return;
    } else if (widget.onBeforePopupOpeningMultiSelection != null) {
      if (await widget.onBeforePopupOpeningMultiSelection!(getSelectedItems) ==
          false) {
        return;
      }
    }

    _handleFocus(true);
    if (widget.popupProps.mode == PopupMode.menu) {
      await _openMenu();
    } else if (widget.popupProps.mode == PopupMode.modalBottomSheet) {
      await _openModalBottomSheet();
    } else if (widget.popupProps.mode == PopupMode.bottomSheet) {
      await _openBottomSheet();
    } else {
      await _openSelectDialog();
    }

    _handleFocus(false);
  }

  @override
  void dispose() {
    _popupStateKey.currentState?.closePopup();
    super.dispose();
  }

  void changeSelectedItem(T? selectedItem) =>
      _handleOnChangeSelectedItems(DropdownSearch._itemToList(selectedItem));

  void changeSelectedItems(List<T> selectedItems) =>
      _handleOnChangeSelectedItems(selectedItems);

  void removeItem(T itemToRemove) => _handleOnChangeSelectedItems(
      getSelectedItems..removeWhere((i) => _isEqual(itemToRemove, i)));

  void clear() => _handleOnChangeSelectedItems([]);

  T? get getSelectedItem =>
      getSelectedItems.isEmpty ? null : getSelectedItems.first;

  List<T> get getSelectedItems => _selectedItemsNotifier.value;

  bool get isFocused => _isFocused.value;

  bool get isMultiSelectionMode => widget.isMultiSelectionMode;

  void popupDeselectItems(List<T> itemsToDeselect) {
    _popupStateKey.currentState?.deselectItems(itemsToDeselect);
  }

  void popupDeselectAllItems() {
    _popupStateKey.currentState?.deselectAllItems();
  }

  void popupSelectAllItems() {
    _popupStateKey.currentState?.selectAllItems();
  }

  void popupSelectItems(List<T> itemsToSelect) {
    _popupStateKey.currentState?.selectItems(itemsToSelect);
  }

  void popupOnValidate() {
    _popupStateKey.currentState?.onValidate();
  }

  void popupValidate(List<T> itemsToValidate) {
    closeDropDownSearch();
    changeSelectedItems(itemsToValidate);
  }

  void openDropDownSearch() => _selectSearchMode();

  DropdownSearchPopupState<T>? get getPopupState => _popupStateKey.currentState;

  void closeDropDownSearch() => _popupStateKey.currentState?.closePopup();

  bool get popupIsAllItemSelected =>
      _popupStateKey.currentState?.isAllItemSelected ?? false;
}
