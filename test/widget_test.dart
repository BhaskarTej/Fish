import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:virtual_aquarium/aquarium_app.dart';

void main() {
  testWidgets('Add Fish button adds a new fish to the aquarium', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: AquariumApp()));

    // Verify that no fish are initially present.
    expect(find.byType(Container), findsOneWidget); // This is the aquarium container.
    expect(find.byType(AnimatedBuilder), findsNothing); // No fish initially.

    // Tap the 'Add Fish' button.
    await tester.tap(find.text('Add Fish'));
    await tester.pump(); // Rebuild the widget tree.

    // Verify that a fish has been added.
    expect(find.byType(AnimatedBuilder), findsOneWidget); // One fish should be present.

    // Tap the 'Add Fish' button again.
    await tester.tap(find.text('Add Fish'));
    await tester.pump();

    // Verify that another fish has been added (total 2).
    expect(find.byType(AnimatedBuilder), findsNWidgets(2)); // Now there should be 2 fish.
  });
}
