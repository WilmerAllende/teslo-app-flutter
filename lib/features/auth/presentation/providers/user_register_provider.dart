//! 1- State del provider

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auh_provider.dart';
import 'package:teslo_shop/features/shared/shared.dart';

// 3 - StateNotefiderPOTVIDER - CONSUM AFUERA

final registerUserFormProvider = StateNotifierProvider.autoDispose<
    RegisterUserFormNotifier, UserRegisterFormState>((ref) {
  final registerUserCallback = ref.watch(authProvider.notifier).registerUser;
  return RegisterUserFormNotifier(registerUserCallback: registerUserCallback);
});

// 2 como implementar notifider
class RegisterUserFormNotifier extends StateNotifier<UserRegisterFormState> {
  final Function(String, String, String) registerUserCallback;
  RegisterUserFormNotifier({required this.registerUserCallback})
      : super(UserRegisterFormState());

  onEmailChange(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWitch(
        email: newEmail,
        isValid: Formz.validate(
            [newEmail, state.password, state.fullName, state.repeatPassword]));
  }

  onPasswordChanged(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWitch(
        password: newPassword,
        isValid: Formz.validate(
            [state.email, newPassword, state.fullName, state.repeatPassword]));
  }
  
  onRepeatPasswordChanged(String value) {
    //final newPassword = PasswordRpeat.dirty(value);

    final confirmedPassword = PasswordRpeat.dirty(
      password: state.password.value,
      value: value,
    );

    state = state.copyWitch(
        repeatPassword: confirmedPassword,
        isValid: Formz.validate(
            [state.email, state.password, state.fullName, confirmedPassword ]));
  }


  onFullNameChange(String value) {
    final newFullName = FullName.dirty(value);
    state = state.copyWitch(
        fullName: newFullName,
        isValid: Formz.validate(
            [newFullName, state.password, state.email, state.repeatPassword]));
  }



  onFormSubmit() async {
    _touchEveryField();
    if (state.password.value != state.repeatPassword.value) return;
    if (!state.isValid) return;
    await registerUserCallback(
        state.email.value, state.password.value, state.fullName.value);
  }

  _touchEveryField() {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final fullName = FullName.dirty(state.fullName.value);
    final repeatPassword = PasswordRpeat.dirty( password:  state.repeatPassword.value,value:   state.password.value);

    state = state.copyWitch(
        isFormPosted: true,
        email: email,
        password: password,
        fullName: fullName,
        repeatPassword: repeatPassword,
        isValid: Formz.validate([
          email,
          password,
          fullName,
          repeatPassword,
          
        ]));
  }
}

class UserRegisterFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Email email;
  final Password password;
  final PasswordRpeat repeatPassword;
  final FullName fullName;

  UserRegisterFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.fullName = const FullName.pure(),
    this.repeatPassword = const PasswordRpeat.pure(),
  });

  UserRegisterFormState copyWitch({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Email? email,
    Password? password,
    PasswordRpeat? repeatPassword,
    FullName? fullName,
  }) =>
      UserRegisterFormState(
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        email: email ?? this.email,
        password: password ?? this.password,
        fullName: fullName ?? this.fullName,
        repeatPassword: repeatPassword ?? this.repeatPassword,
      );

  @override
  String toString() {
    return ''' 
    LoginFormState:
      isPosting  : $isPosting
      isFormPosted  : $isFormPosted
      isValid  : $isValid
      email  : $email
      password  : $password
      repeatPassword  : $repeatPassword
      fullName  : $fullName
    ''';
  }
}
