import 'package:flutter_test/flutter_test.dart';
import 'package:oryzaelo_ui/oryzaelo_ui.dart';

void main() {
  test('OryzaTheme uses Ubuntu Sans as canonical font family', () {
    final light = OryzaTheme.lightTheme;
    final dark = OryzaTheme.darkTheme;

    expect(light.textTheme.displayLarge?.fontFamily, contains('Ubuntu Sans'));
    expect(dark.textTheme.displayLarge?.fontFamily, contains('Ubuntu Sans'));
    expect(light.colorScheme.primary, OryzaColors.burntOrange);
    expect(dark.colorScheme.secondary, OryzaColors.militaryGreen);
    expect(light.colorScheme.tertiary, OryzaColors.mustardYellow);
  });
}
