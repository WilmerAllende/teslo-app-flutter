import 'package:formz/formz.dart';

// Define input validation errors
enum PasswordRpeatError { empty, length, format, mismatch }

// Extend FormzInput and provide the input type and error type.
class PasswordRpeat extends FormzInput<String, PasswordRpeatError> {
  final String password;

  static final RegExp passwordRegExp = RegExp(
    r'(?:(?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$',
  );

  // Call super.pure to represent an unmodified form input.
  //const PasswordRpeat.pure() : super.pure('');

  const PasswordRpeat.pure({this.password = ''}) : super.pure('');

  // Call super.dirty to represent a modified form input.
  //const PasswordRpeat.dirty( String value ) : super.dirty(value);

  const PasswordRpeat.dirty({required this.password, String value = ''})
      : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == PasswordRpeatError.empty) return 'El campo es requerido';
    if (displayError == PasswordRpeatError.length) return 'Mínimo 6 caracteres';
    if (displayError == PasswordRpeatError.format) return 'Debe de tener Mayúscula, letras y un número';
    if (displayError == PasswordRpeatError.mismatch) return 'Ambas contaseñas deben coincidir';

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  PasswordRpeatError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return PasswordRpeatError.empty;
    if (value.length < 6) return PasswordRpeatError.length;
    if (!passwordRegExp.hasMatch(value)) return PasswordRpeatError.format;
    if (value != password) return PasswordRpeatError.mismatch;

    return null;
  }
}
/*
extension Explanation on PasswordRpeatError {
  String? get name {
    switch (this) {
      case PasswordRpeatError.mismatch:
        return 'Las contraseñas deben coincidir';
      default:
        return null;
    }
  }
}
*/
