import 'package:flutter_test/flutter_test.dart';
import 'package:cloud/main.dart';

void main() {
  testWidgets('OryzaCloudApp builds and renders LandingPage', (WidgetTester tester) async {
    await tester.pumpWidget(const OryzaCloudApp());
    expect(find.byType(OryzaCloudApp), findsOneWidget);
  });
}
