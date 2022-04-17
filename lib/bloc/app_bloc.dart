import 'package:bloc/bloc.dart';
import 'package:testingbloc_course/apis/login_api.dart';
import 'package:testingbloc_course/apis/notes_api.dart';
import 'package:testingbloc_course/bloc/app_state.dart';
import 'package:testingbloc_course/models/model.dart';

import 'actions.dart';

class AppBloc extends Bloc<AppAction, AppState> {
  final LoginApiProtocol loginApi;
  final NotesApiProtocol notesApi;

  AppBloc({
    required this.loginApi,
    required this.notesApi,
  }) : super(const AppState.empty()) {
    on<LoginAction>(
      (event, emit) async {
        // start loading
        emit(
          const AppState(
            isLoading: true,
            loginHandle: null,
            loginError: null,
            fetchNotes: null,
          ),
        );

        // login
        final LoginHandle? loginHandle = await loginApi.login(email: event.email, password: event.password);

        emit(
          AppState(
            isLoading: false,
            loginHandle: loginHandle,
            loginError: loginHandle == null ? LoginErrors.invalidHandle : null,
            fetchNotes: null,
          ),
        );
      },
    );

    on<LoadingNotesAction>(
      (event, emit) async {
        // start loading
        emit(
          AppState(
            isLoading: true,
            loginHandle: state.loginHandle,
            loginError: null,
            fetchNotes: null,
          ),
        );

        // get the login handle
        final LoginHandle? loginHandle = state.loginHandle;

        if (loginHandle != const LoginHandle.fooBar()) {
          // invalid login handle, cannot fetch notes
          emit(
            AppState(
              isLoading: false,
              fetchNotes: null,
              loginError: LoginErrors.invalidHandle,
              loginHandle: loginHandle,
            ),
          );
          return;
        }

        // we have valid login handle, now fetch notes
        final Iterable<Note>? notes = await notesApi.getNotes(loginHandle: loginHandle!);
        emit(
          AppState(
            isLoading: false,
            fetchNotes: notes,
            loginError: null,
            loginHandle: loginHandle,
          ),
        );
      },
    );
  }
}
