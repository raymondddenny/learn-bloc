import 'package:flutter/foundation.dart' show immutable;
import 'package:testingbloc_course/bloc/person.dart';

const persons1 = 'http://10.0.2.2:5500/api/person1.json';
const persons2 = 'http://10.0.2.2:5500/api/person2.json';

typedef PersonLoader = Future<Iterable<Person>> Function(String url);

@immutable
abstract class LoadAction {
  const LoadAction();
}

@immutable
class LoadPersonsAction implements LoadAction {
  final String url;
  final PersonLoader loader;
  const LoadPersonsAction({required this.url, required this.loader}) : super();
}
