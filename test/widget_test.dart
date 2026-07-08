import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ai_daily_meal_planner/logic/app_service.dart';
import 'package:ai_daily_meal_planner/main.dart';

void main() {
  testWidgets('shows splash then disclaimer on first launch', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final appService = await AppService.bootstrap();

    await tester.pumpWidget(MyApp(appService: appService));
    await tester.pumpAndSettle();

    expect(find.text('AI Daily Meal Planner'), findsOneWidget);
    expect(find.text('Get started'), findsOneWidget);

    await tester.tap(find.text('Get started'));
    await tester.pumpAndSettle();

    expect(find.text('Before you start'), findsOneWidget);
    expect(find.text('I understand, continue'), findsOneWidget);
  });
}
