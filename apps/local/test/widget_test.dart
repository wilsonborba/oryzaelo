import 'package:flutter_test/flutter_test.dart';
import 'package:local/app.dart';

/// Boots the real app widget tree end-to-end with no network access (as
/// flutter_test provides — every HTTP request comes back as a synthetic
/// 400). This is exactly the "engine unreachable, zero data" state a farmer
/// sees on first install before the Raspberry Pi engine is even running, so
/// it's a real scenario worth a smoke test, not just a placeholder.
void main() {
  testWidgets('FarmerApp boots with the engine offline and zero parcels without crashing or overflowing', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const FarmerApp());
    // Allow the fire-and-forget initialize() network calls (all of which
    // fail fast under flutter_test's synthetic HttpClient) to settle.
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // The dashboard shell must render — this is the real regression check:
    // no uncaught exception, no RenderFlex overflow, on the actual
    // production widget tree in its worst-case (fully offline) state.
    expect(tester.takeException(), isNull);
  });
}
