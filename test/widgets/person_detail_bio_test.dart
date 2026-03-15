import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cinemax/screens/person_detail/widgets/person_detail_bio.dart';

void main() {
  testWidgets('PersonDetailBio renders biography when not empty', (WidgetTester tester) async {
    const biography = 'Test biography text.';

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: PersonDetailBio(biography: biography),
        ),
      ),
    );

    expect(find.text('Biography'), findsOneWidget);
    expect(find.text(biography), findsOneWidget);
  });

  testWidgets('PersonDetailBio renders nothing when biography is empty', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: PersonDetailBio(biography: ''),
        ),
      ),
    );

    expect(find.text('Biography'), findsNothing);
  });
}
