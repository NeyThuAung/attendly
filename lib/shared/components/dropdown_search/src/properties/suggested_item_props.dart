import 'package:flutter/material.dart';

import '../../dropdown_search.dart';

class SuggestedItemProps<T> {
  final bool showSuggestedItems;
  final FavoriteItemsBuilder<T>? suggestedItemBuilder;
  final SuggestedItems<T>? suggestedItems;
  final MainAxisAlignment suggestedItemsAlignment;
  final ClickProps itemClickProps;
  final ScrollProps scrollProps;

  const SuggestedItemProps({
    this.suggestedItemBuilder,
    this.suggestedItems,
    this.suggestedItemsAlignment = MainAxisAlignment.start,
    this.showSuggestedItems = false,
    this.itemClickProps = const ClickProps(),
    this.scrollProps = const ScrollProps(scrollDirection: Axis.horizontal),
  });
}
