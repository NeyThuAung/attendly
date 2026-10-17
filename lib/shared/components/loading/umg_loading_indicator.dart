import 'package:flutter/material.dart';

class UMGLoadingIndicator extends StatefulWidget {
  final double size;
  final double strokeWidth;
  final Duration animationDuration;
  final Color firstCircleColor;
  final Color secondCircleColor;
  final Color thirdCircleColor;

  const UMGLoadingIndicator({
    super.key,
    this.size = 50,
    this.strokeWidth = 5,
    this.animationDuration = const Duration(seconds: 2),
    this.firstCircleColor = const Color(0xFFEA232A), // Red
    this.secondCircleColor = const Color(0xFFFFCB0C), // Yellow
    this.thirdCircleColor = const Color(0xFF024DA1), // Blue
  });

  @override
  State<UMGLoadingIndicator> createState() => _UMGLoadingIndicatorState();
}

class _UMGLoadingIndicatorState extends State<UMGLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            children: [
              // First circle (red by default)
              Transform(
                transform: Matrix4.identity()
                  ..rotateX(45 * 0.0174533)
                  ..rotateY(-25 * 0.0174533)
                  ..rotateZ(_controller.value * 6.28319),
                alignment: FractionalOffset.center,
                child: ClipPath(
                  clipper: _CircleBottomClipper(),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border(
                        bottom: BorderSide(
                          color: widget.firstCircleColor,
                          width: widget.strokeWidth,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // // Second circle (yellow by default)
              Transform(
                transform: Matrix4.identity()
                  ..rotateX(45 * 0.0174533)
                  ..rotateY(20 * 0.0174533)
                  ..rotateZ(_controller.value * 6.28319),
                alignment: FractionalOffset.center,
                child: ClipPath(
                  clipper: _CircleRightClipper(),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border(
                        right: BorderSide(
                          color: widget.secondCircleColor,
                          width: widget.strokeWidth,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Third circle (blue by default)
              Transform(
                transform: Matrix4.identity()
                  ..rotateX(5 * 0.0174533)
                  ..rotateY(60 * 0.0174533)
                  ..rotateZ(_controller.value * 6.28319),
                alignment: FractionalOffset.center,
                child: ClipPath(
                  clipper: _CircleTopClipper(),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border(
                        top: BorderSide(
                          color: widget.thirdCircleColor,
                          width: widget.strokeWidth,
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CircleTopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height / 2);
    path.lineTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height / 2);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _CircleRightClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width / 2, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _CircleBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height / 2);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height / 2);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
