import 'package:flutter/services.dart';

class MyFonts {
  static const String openSans = 'OpenSans';
}

Future<void> loadFont() async {
  final fontData = await rootBundle.load("assets/open-sans.ttf");
  final fontLoader = FontLoader(MyFonts.openSans);
  fontLoader.addFont(Future.value(ByteData.sublistView(fontData)));
  await fontLoader.load();
}
