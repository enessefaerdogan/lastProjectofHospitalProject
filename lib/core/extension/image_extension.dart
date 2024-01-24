extension ImageExtension on String{
  String get toPng  => "assets/$this.png";
  String get toJpg  => "assets/$this.jpg";
  String get lottieToJson => "assets/lottie/$this.json";
}