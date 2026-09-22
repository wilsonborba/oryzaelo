import 'package:flutter/services.dart';

Future<bool> copyToClipboardImpl(String text) async {
  try {
    await Clipboard.setData(ClipboardData(text: text));
    return true;
  } catch (_) {
    return false;
  }
}
