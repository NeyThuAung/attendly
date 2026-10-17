import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:attendly/shared/styles/styles.dart';
import 'package:attendly/shared/extensions/extensions.dart';
import '../icon/svg_icon.dart';
import 'nav_item.dart';

class NavBarItem extends StatelessWidget {
  final bool isSelected;
  final NavItem navItem;
  final double iconSize;
  final String? username;
  final String? imageUrl;
  final int notiCount;

  const NavBarItem({
    super.key,
    required this.navItem,
    this.isSelected = false,
    this.iconSize = SvgIcon.kSize,
    this.username,
    this.imageUrl,
    required this.notiCount,
  });

  bool get hasImage => (imageUrl ?? '').isNotEmpty;

  bool get hasUsername => username?.trim().isNotEmpty ?? false;

  @override
  Widget build(BuildContext context) {
    final effectiveColor =
        (isSelected ? navItem.selectedColor : navItem.color) ??
            (isSelected ? context.theme.primaryColor : Colors.grey);

    return Stack(
      alignment: Alignment.topRight,
      children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            _SelectionBar(isSelected: isSelected),
            ($styles.insets.xxs * 1.8).toHeightSizedBox,
            if (hasImage)
              _ProfileImage(
                imageUrl: imageUrl!,
                username: username!,
                iconSize: iconSize,
                isSelected: isSelected,
              )
            else if (hasUsername)
              _UsernameAvatar(
                username: username!,
                iconSize: iconSize,
                isSelected: isSelected,
              )
            else
              NavIconWidget(
                icon: isSelected ? navItem.selectedIcon : navItem.icon,
                color: effectiveColor,
                size: iconSize,
              ),
            SizedBox(height: $styles.insets.xxs),
            if (navItem.label != null)
              _NavLabel(
                label: navItem.label!,
                color: effectiveColor,
                isSelected: isSelected,
              ),
            ($styles.insets.xxs / 2).toHeightSizedBox,
          ],
        ),
        if (notiCount != 0) _NotificationBadge(notiCount: notiCount),
      ],
    );
  }
}

// ───────────────────────────── Sub Widgets ─────────────────────────────

class _SelectionBar extends StatelessWidget {
  final bool isSelected;

  const _SelectionBar({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      width: context.width / 6,
      decoration: BoxDecoration(
        color: isSelected
            ? context.theme.colorScheme.primary
            : Colors.transparent,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _ProfileImage extends StatelessWidget {
  final String imageUrl;
  final String username;
  final double iconSize;
  final bool isSelected;

  const _ProfileImage({
    required this.imageUrl,
    required this.username,
    required this.iconSize,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isSelected
        ? $styles.color.clrPrimary
        : context.textTheme.bodySmall!.color!;

    return Container(
      width: iconSize,
      height: iconSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(width: 2, color: borderColor),
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => _ProfilePlaceholder(username),
          errorWidget: (context, url, error) => _UsernameAvatar(
            username: username,
            isSelected: isSelected,
            iconSize: iconSize,
          ),
        ),
      ),
    );
  }
}

class _ProfilePlaceholder extends StatelessWidget {
  final String username;

  const _ProfilePlaceholder(this.username);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: $styles.color.getRandomColor(username.trim().isEmpty ? '' : username.trim()[0].toUpperCase()),
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: $styles.color.clrPrimary,
        ),
      ),
    );
  }
}

class _UsernameAvatar extends StatelessWidget {
  final String username;
  final double iconSize;
  final bool isSelected;

  const _UsernameAvatar({
    required this.username,
    required this.iconSize,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final firstLetter = username.trim().isEmpty ? '' : username.trim()[0].toUpperCase();

    return Container(
      width: iconSize,
      height: iconSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: isSelected
            ? Border.all(width: 2, color: $styles.color.clrPrimary)
            : null,
      ),
      padding: isSelected ? const EdgeInsets.all(0.5) : null,
      child: CircleAvatar(
        backgroundColor: $styles.color.getRandomColor(firstLetter),
        child: Text(
          firstLetter,
          style: TextStyle(
            fontSize: isSelected ? 12.5 : 14,
            fontWeight: FontWeight.bold,
            color: context.theme.colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}

class _NavLabel extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSelected;

  const _NavLabel({
    required this.label,
    required this.color,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: context.textTheme.titleMedium?.size13.copyWith(
        fontSize: 10,
        color: color,
        fontWeight: isSelected ? FontWeight.bold : null,
      ),
    );
  }
}

class _NotificationBadge extends StatelessWidget {
  final int notiCount;

  const _NotificationBadge({required this.notiCount});

  @override
  Widget build(BuildContext context) {
    final topOffset = 5 + (notiCount < 10 ? -3 : 0);
    final rightOffset =
        $styles.grid.columnsMargin / 2 +
        (notiCount < 10
            ? 5
            : notiCount > 99
            ? 0
            : 4);
    final paddingValue =
        5 +
        (notiCount < 10
            ? 3
            : notiCount > 99
            ? 0
            : 0);

    return Positioned(
      top: topOffset.toDouble(),
      right: rightOffset,
      child: Container(
        padding: EdgeInsets.all(paddingValue.toDouble()),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.red,
        ),
        child: Center(
          child: Text(
            notiCount >= 99 ? "99+" : "$notiCount",
            style: TextStyle(
              color: Colors.white,
              fontSize: notiCount <= 99 ? 8.5 : 9.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
