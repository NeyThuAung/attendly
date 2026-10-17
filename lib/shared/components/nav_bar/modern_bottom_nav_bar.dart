import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:attendly/shared/extensions/extensions.dart';
import 'nav_item.dart';

class ModernBottomNavBar extends StatelessWidget {
  const ModernBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });

  final int currentIndex;
  final List<NavItem> items;
  final ValueChanged<int> onTap;

  static const double _borderRadius = 100;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark
        ? const Color(0xFF1B1B26).addOpacity(0.92)
        : Colors.white.addOpacity(0.92);

    final borderColor = isDark
        ? Colors.white.addOpacity(0.18)
        : Colors.white.addOpacity(0.8);

    final indicatorColor = isDark
        ? context.theme.primaryColor.addOpacity(0.55)
        : Colors.grey.shade300;

    final indicatorBorderColor = isDark
        ? const Color(0xFF64B5F6).addOpacity(0.4)
        : Colors.transparent;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, context.bottomPadding + 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 20),
          child: Container(
            height: 64,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(_borderRadius),
              border: Border.all(
                color: borderColor,
                width: 1.3,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.addOpacity(0.5)
                      : Colors.black.addOpacity(0.2),
                  blurRadius: 30,
                  spreadRadius: 2,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final double itemWidth = constraints.maxWidth / items.length;

                return Stack(
                  children: [
                    // ─────────────────────────────
                    // Sliding selected background
                    // ─────────────────────────────
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      left: currentIndex * itemWidth,
                      top: 0,
                      bottom: 0,
                      width: itemWidth,
                      child: Container(
                        decoration: BoxDecoration(
                          color: indicatorColor,
                          borderRadius: BorderRadius.circular(_borderRadius),
                          border: Border.all(
                            color: indicatorBorderColor,
                            width: 1,
                          ),
                        ),
                      ),
                    ),

                    // ─────────────────────────────
                    // Navigation items
                    // ─────────────────────────────
                    Row(
                      children: List.generate(items.length, (index) {
                        return Expanded(
                          child: _ModernBottomNavItem(
                            item: items[index],
                            isSelected: currentIndex == index,
                            onTap: () => onTap(index),
                          ),
                        );
                      }),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _ModernBottomNavItem extends StatelessWidget {
  const _ModernBottomNavItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final NavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final unselectedColor = item.color ??
        (isDark ? Colors.grey.shade400 : Colors.grey.shade700);

    final selectedColor = item.selectedColor ??
        (isDark ? Colors.white : context.theme.primaryColor);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        height: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: isSelected ? 1 : 0),
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                builder:
                    (BuildContext context, double animation, Widget? child) {
                      final Color color = Color.lerp(
                        unselectedColor,
                        selectedColor,
                        animation,
                      )!;

                      return Transform.scale(
                        scale: 0.96 + (animation * 0.04),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            NavIconWidget(
                              icon: isSelected ? item.selectedIcon : item.icon,
                              color: color,
                              size: 22,
                            ),
                            if (item.label != null) ...[
                              const SizedBox(height: 3),
                              Text(
                                item.label!,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: color,
                                  fontWeight: FontWeight.lerp(
                                    FontWeight.w400,
                                    FontWeight.w600,
                                    animation,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
              ),
            ),

            if (item.notiCount != 0)
              Positioned(
                top: 7,
                right: 18,
                child: _ModernNotificationBadge(count: item.notiCount),
              ),
          ],
        ),
      ),
    );
  }
}

class _ModernNotificationBadge extends StatelessWidget {
  const _ModernNotificationBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final String text = count >= 99 ? '99+' : '$count';

    return Container(
      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white, width: 0),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 8,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
