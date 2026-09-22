import 'package:flutter/services.dart';
import 'package:web/web.dart' as web;

Future<bool> copyToClipboardImpl(String text) async {
  bool success = false;

  // 1. Try fallback via hidden textarea and execCommand('copy') FIRST synchronously.
  // This is synchronous within the user-click event, guaranteeing user-gesture activation,
  // and works on HTTP, local IP, iframes, and insecure origins where navigator.clipboard is null.
  try {
    final textarea = web.document.createElement('textarea') as web.HTMLTextAreaElement;
    textarea.value = text;
    textarea.style.position = 'fixed';
    textarea.style.top = '0';
    textarea.style.left = '0';
    textarea.style.width = '2em';
    textarea.style.height = '2em';
    textarea.style.padding = '0';
    textarea.style.border = 'none';
    textarea.style.outline = 'none';
    textarea.style.boxShadow = 'none';
    textarea.style.background = 'transparent';
    textarea.style.opacity = '0';
    web.document.body?.appendChild(textarea);
    textarea.focus();
    textarea.select();
    textarea.setSelectionRange(0, text.length);
    final execResult = web.document.execCommand('copy');
    textarea.remove();
    if (execResult) {
      success = true;
    }
  } catch (_) {}

  // 2. Also attempt Flutter's Clipboard.setData (which calls navigator.clipboard in secure HTTPS contexts).
  try {
    await Clipboard.setData(ClipboardData(text: text));
    success = true;
  } catch (_) {}

  return success;
}
