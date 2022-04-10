import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testingbloc_course/bloc/bloc_actions.dart';
import 'package:testingbloc_course/bloc/person.dart';
import 'package:flutter/foundation.dart' show immutable;

extension IsEqualToIgnoringOrdering<T> on Iterable<T> {
  bool isEqualToIgnoringOrdering(Iterable<T> other) =>
      length == other.length && {...this}.intersection({...other}).length == length;
}

class PersonsBloc extends Bloc<LoadAction, FetchResult?> {
  final Map<String, Iterable<Person>> _cache = {};
  PersonsBloc() : super(null) {
    on<LoadPersonsAction>((event, emit) async {
      final url = event.url;

      if (_cache.containsKey(url)) {
        // we have the value in the cache
        final cachedPersons = _cache[url]!;
        final result = FetchResult(persons: cachedPersons, isRetrivedFromCache: true);
        emit(result);
      } else {
        final loader = event.loader;
        final persons = await loader(url);
        final result = FetchResult(persons: persons, isRetrivedFromCache: false);
        _cache[url] = persons; // save to cache
        emit(result);
      }
    });
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

  @override
  bool operator ==(covariant FetchResult other) =>
      persons.isEqualToIgnoringOrdering(other.persons) && isRetrivedFromCache == other.isRetrivedFromCache;

  @override
  int get hashCode => Object.hash(persons, isRetrivedFromCache);
}
