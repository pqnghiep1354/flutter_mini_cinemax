import 'package:flutter_test/flutter_test.dart';
import 'package:cinemax/myapp.dart';

void main() {
  testWidgets('App builds', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
  });
}
