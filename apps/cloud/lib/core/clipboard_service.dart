import 'clipboard_service_stub.dart'
    if (dart.library.js_interop) 'clipboard_service_web.dart';

class OryzaClipboard {
  OryzaClipboard._();

  /// Universally copies [text] to the system clipboard across Web (HTTP & HTTPS) and Native.
  static Future<bool> copy(String text) async {
    return copyToClipboardImpl(text);
  }
}
