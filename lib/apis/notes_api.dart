import 'package:flutter/foundation.dart' show immutable;
import 'package:testingbloc_course/models/model.dart';

@immutable
abstract class NotesApiProtocol {
  const NotesApiProtocol();

  // need token to access this
  Future<Iterable<Note>?> getNotes({required LoginHandle loginHandle});
}

@immutable
class NotesApi implements NotesApiProtocol {
  @override
  Future<Iterable<Note>?> getNotes({required LoginHandle loginHandle}) => Future.delayed(
        const Duration(seconds: 3),
        () => loginHandle == const LoginHandle.fooBar() ? mockNotes : null,
      );
}
