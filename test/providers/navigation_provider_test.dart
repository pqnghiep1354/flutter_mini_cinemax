import 'package:flutter_test/flutter_test.dart';
import 'package:cinemax/providers/navigation_provider.dart';

void main() {
  group('NavigationProvider Tests', () {
    test('initial index should be 0', () {
      final provider = NavigationProvider();
      expect(provider.currentIndex, 0);
    });

    test('setTab should update index and notify listeners', () {
      final provider = NavigationProvider();
      int callCount = 0;
      provider.addListener(() => callCount++);

      provider.setTab(2);

      expect(provider.currentIndex, 2);
      expect(callCount, 1);
    });
  });
}
