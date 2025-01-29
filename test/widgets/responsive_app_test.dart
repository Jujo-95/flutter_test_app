import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_app/main.dart';
import 'package:flutter_test_app/widgets/chips_filter.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('ResponsiveApp shows NavigationRail on wide screens', (WidgetTester tester) async {
    // Define a widget to test
    final testWidget = MaterialApp(
      home: MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => CharacterProvider()  )],
        child: ResponsiveApp()),
    );

    // Build the widget with a wide screen size
    await tester.pumpWidget(
      MediaQuery(
        data: MediaQueryData(size: Size(800, 600)),
        child: testWidget,
      ),
    );

    // Verify that the NavigationRail is shown
    expect(find.byType(NavigationRail), findsOneWidget);

    // Build the widget with a narrow screen size
    await tester.pumpWidget(
      MediaQuery(
        data: MediaQueryData(size: Size(400, 600)),
        child: testWidget,
      ),
    );

    // Verify that the NavigationRail is not shown
    expect(find.byType(NavigationRail), findsNothing);
  });
}