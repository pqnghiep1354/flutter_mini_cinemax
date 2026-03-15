import 'package:flutter_test/flutter_test.dart';
import 'package:cinemax/models/person.dart';

void main() {
  group('Person Model Tests', () {
    test('fromJson should create a valid Person object', () {
      final json = {
        'id': 123,
        'name': 'John Doe',
        'biography': 'A famous actor.',
        'birthday': '1980-01-01',
        'place_of_birth': 'New York, USA',
        'profile_path': '/path.jpg',
        'known_for_department': 'Acting',
      };

      final person = Person.fromJson(json);

      expect(person.id, 123);
      expect(person.name, 'John Doe');
      expect(person.biography, 'A famous actor.');
      expect(person.birthday, '1980-01-01');
      expect(person.placeOfBirth, 'New York, USA');
      expect(person.profilePath, '/path.jpg');
      expect(person.knownForDepartment, 'Acting');
      expect(person.fullProfilePath, 'https://image.tmdb.org/t/p/w500/path.jpg');
    });

    test('fromJson should handle null values correctly', () {
      final json = {
        'id': 123,
        'name': 'John Doe',
      };

      final person = Person.fromJson(json);

      expect(person.id, 123);
      expect(person.name, 'John Doe');
      expect(person.biography, isNull);
      expect(person.fullProfilePath, '');
    });
  });
}
