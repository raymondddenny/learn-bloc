import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dart:developer' as devtools show log;

extension Log on Object {
  void log() => devtools.log(toString());
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (_) => PersonsBloc(),
        child: const MyHomePage(),
      ),
    );
  }
}

@immutable
abstract class LoadAction {
  const LoadAction();
}

@immutable
class LoadPersonsAction implements LoadAction {
  final PersonsUrl url;
  const LoadPersonsAction({required this.url}) : super();
}

enum PersonsUrl {
  person1,
  person2,
}

class Person {
  final String name;
  final int age;

  Person.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        age = json['age'] as int;

  @override
  String toString() => 'Person(name: $name, age: $age)';
}

Future<Iterable<Person>> loadPersons(String url) => HttpClient()
    .getUrl(Uri.parse(url))
    .then((req) => req.close())
    .then((resp) => resp.transform(utf8.decoder).join())
    .then((str) => jsonDecode(str) as List<dynamic>)
    .then((list) => list.map((e) => Person.fromJson(e)));

extension UrlString on PersonsUrl {
  String get urlString {
    switch (this) {
      case PersonsUrl.person1:
        return 'http://127.0.0.1:5500/api/person1.json';
      case PersonsUrl.person2:
        return 'http://127.0.0.1:5500/api/person2.json';
    }
  }
}

@immutable
class FetchResult {
  final Iterable<Person> persons;
  final bool isRetrivedFromCache; // for caching
  const FetchResult({
    required this.persons,
    required this.isRetrivedFromCache,
  });

  @override
  String toString() => 'FetchResult (isRetrievedFromCache = $isRetrivedFromCache), persons = $persons';
}

class PersonsBloc extends Bloc<LoadAction, FetchResult?> {
  final Map<PersonsUrl, Iterable<Person>> _cache = {};
  PersonsBloc() : super(null) {
    on<LoadPersonsAction>((event, emit) async {
      final url = event.url;

      if (_cache.containsKey(url)) {
        // we have the value in the cache
        final cachedPersons = _cache[url]!;
        final result = FetchResult(persons: cachedPersons, isRetrivedFromCache: true);
        emit(result);
      } else {
        final persons = await loadPersons(url.urlString);
        final result = FetchResult(persons: persons, isRetrivedFromCache: false);
        _cache[url] = persons; // save to cache
        emit(result);
      }
    });
  }
}

/// if the length is more than index then show the item on that index, else return null
extension Subscript<T> on Iterable<T> {
  T? operator [](int index) => length > index ? elementAt(index) : null;
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Home Page'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              TextButton(
                  onPressed: () {
                    context.read<PersonsBloc>().add(
                          const LoadPersonsAction(
                            url: PersonsUrl.person1,
                          ),
                        );
                  },
                  child: const Text('Load Person Json #1')),
              const SizedBox(width: 20),
              TextButton(
                  onPressed: () {
                    context.read<PersonsBloc>().add(
                          const LoadPersonsAction(
                            url: PersonsUrl.person2,
                          ),
                        );
                  },
                  child: const Text('Load Person Json #2')),
              BlocBuilder<PersonsBloc, FetchResult?>(
                buildWhen: (previousResult, currentResult) {
                  return previousResult?.persons != currentResult?.persons;
                },
                builder: (context, fetchResult) {
                  fetchResult?.log();
                  final persons = fetchResult?.persons;
                  if (persons == null) {
                    return const SizedBox();
                  }
                  return Expanded(
                    child: ListView.builder(
                      itemCount: fetchResult?.persons.length,
                      itemBuilder: ((context, index) {
                        final person = persons[index]!;
                        return ListTile(
                          title: Text(person.name),
                        );
                      }),
                    ),
                  );
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
