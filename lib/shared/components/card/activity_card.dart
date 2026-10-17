import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:attendly/shared/styles/styles.dart';
import 'package:attendly/shared/extensions/extensions.dart';
import '../icon/noti.dart';

class ActivityCard extends StatelessWidget {
  final String label;
  final Color color;
  final String imagePath;
  final int notiCount;
  final VoidCallback onTap;

  const ActivityCard({
    required this.label,
    required this.color,
    required this.imagePath,
    required this.notiCount,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: context.width,
            decoration: BoxDecoration(
              color: color,
              border: notiCount > 0
                  ? Border.all(
                      color: context.theme.primaryColor,
                      width: 2,
                    )
                  : null,
              borderRadius: BorderRadius.circular(
                $styles.insets.xs * 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  imagePath,
                  width: $styles.size.size100 * 5.7,
                  height: $styles.size.size100 * 5.7,
                  placeholderBuilder: (BuildContext context) => SizedBox(
                    width: $styles.size.size100 * 5.7,
                    height: $styles.size.size100 * 5.7,
                    child: CircularProgressIndicator(),
                  ),
                ),
                $styles.insets.xs.toHeightSizedBox,
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: $styles.insets.xxs,
                  ),
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: context.textTheme.titleMedium,
                  ),
                ),
              ],
            ),
          ),
          if (notiCount > 0)
            Positioned(
              top: 5,
              right: notiCount > 99 ? 5 : 7,
              child: NotiIcon(count: notiCount),
            ),
        ],
      ),
    );
  }
}

class ActivityItems {
  final String label;
  final Color color;
  final String imagePath;
  String homeRoutePath;
  final int notiCount;

  ActivityItems({
    required this.label,
    required this.color,
    required this.imagePath,
    this.homeRoutePath = '',
    this.notiCount = 0,
  });
}
