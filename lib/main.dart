import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dart:developer' as devtools show log;

import 'bloc/bloc_actions.dart';
import 'bloc/person.dart';
import 'bloc/persons_bloc.dart';

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

Future<Iterable<Person>> loadPersons(String url) => HttpClient()
    .getUrl(Uri.parse(url))
    .then((req) => req.close())
    .then((resp) => resp.transform(utf8.decoder).join())
    .then((str) => jsonDecode(str) as List<dynamic>)
    .then((list) => list.map((e) => Person.fromJson(e)));

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
                            url: persons1,
                            loader: loadPersons,
                          ),
                        );
                  },
                  child: const Text('Load Person Json #1')),
              const SizedBox(width: 20),
              TextButton(
                  onPressed: () {
                    context.read<PersonsBloc>().add(
                          const LoadPersonsAction(
                            url: persons2,
                            loader: loadPersons,
                          ),
                        );
                  },
                  child: const Text('Load Person Json #2')),
            ],
          ),
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
      ),
    );
  }
}
