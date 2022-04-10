import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:testingbloc_course/bloc/bloc_actions.dart';
import 'package:testingbloc_course/bloc/person.dart';
import 'package:testingbloc_course/bloc/persons_bloc.dart';

const mockPersons1 = [
  Person(age: 20, name: 'Foo'),
  Person(age: 30, name: 'boo'),
];

const mockPersons2 = [
  Person(age: 20, name: 'Foo'),
  Person(age: 30, name: 'boo'),
];

// these two mock function will conform the PersonLoader type
Future<Iterable<Person>> mockLoadPersons1(String url) async {
  return mockPersons1;
}

Future<Iterable<Person>> mockLoadPersons2(String url) async {
  return mockPersons2;
}

void main() {
  group('Testing Persons Bloc', () {
    //tests

    late PersonsBloc personsBloc;
    setUp(() {
      personsBloc = PersonsBloc();
    });

    blocTest<PersonsBloc, FetchResult?>(
      'Test initial stae',
      build: () => personsBloc,
      verify: (personsBloc) => expect(personsBloc.state, null),
    );

    // fetch mock data (persons1) and compareit with the FetchResult
    blocTest<PersonsBloc, FetchResult?>(
      'Mock retrieving persons from the first iterable',
      build: () => personsBloc,
      act: (personsBloc) {
        personsBloc.add(
          const LoadPersonsAction(
            url: 'dummy_url_1',
            loader: mockLoadPersons1,
          ),
        );
        personsBloc.add(
          const LoadPersonsAction(
            url: 'dummy_url_1',
            loader: mockLoadPersons1,
          ),
        );
      },
      expect: () => [
        const FetchResult(persons: mockPersons1, isRetrivedFromCache: false),
        const FetchResult(persons: mockPersons1, isRetrivedFromCache: true),
      ],
    );

    // fetch mock data (persons1) and compareit with the FetchResult
    blocTest<PersonsBloc, FetchResult?>(
      'Mock retrieving persons from the second iterable',
      build: () => personsBloc,
      act: (personsBloc) {
        personsBloc.add(
          const LoadPersonsAction(
            url: 'dummy_url_2',
            loader: mockLoadPersons2,
          ),
        );
        personsBloc.add(
          const LoadPersonsAction(
            url: 'dummy_url_2',
            loader: mockLoadPersons2,
          ),
        );
      },
      expect: () => [
        const FetchResult(persons: mockPersons2, isRetrivedFromCache: false),
        const FetchResult(persons: mockPersons2, isRetrivedFromCache: true),
      ],
    );
  });
}
