import 'dart:ui' as ui;

bool isBigDevice() {
  double devicePixelRatio = ui.window.devicePixelRatio;
  ui.Size size = ui.window.physicalSize;
  double width = size.width;
  double height = size.height;
  double screenWidth = width / devicePixelRatio;
  double screenHeight = height / devicePixelRatio;
  return screenHeight == 812 ||
      screenWidth == 812 ||
      screenHeight == 896 ||
      screenWidth == 896;
}
