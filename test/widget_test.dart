import 'package:flutter_test/flutter_test.dart';
import 'package:weather_application/main.dart';

void main() {
  testWidgets(
    'Weather app starts successfully',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const WeatherApp(),
      );

      expect(
        find.byType(WeatherApp),
        findsOneWidget,
      );
    },
  );
}