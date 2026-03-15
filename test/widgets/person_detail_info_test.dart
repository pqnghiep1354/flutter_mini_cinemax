import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cinemax/screens/person_detail/widgets/person_detail_info.dart';
import 'package:cinemax/models/person.dart';

void main() {
  testWidgets('PersonDetailInfo renders name and known department', (WidgetTester tester) async {
    final person = Person(
      id: 1,
      name: 'John Doe',
      knownForDepartment: 'Acting',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PersonDetailInfo(person: person),
        ),
      ),
    );

    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('Acting'), findsOneWidget);
  });

  testWidgets('PersonDetailInfo renders birthday and place of birth', (WidgetTester tester) async {
    final person = Person(
      id: 1,
      name: 'John Doe',
      birthday: '1990-05-20',
      placeOfBirth: 'Paris, France',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PersonDetailInfo(person: person),
        ),
      ),
    );

    expect(find.textContaining('1990-05-20'), findsOneWidget);
    expect(find.textContaining('Paris, France'), findsOneWidget);
  });
}
