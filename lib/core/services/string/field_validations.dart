import 'package:string_validator/string_validator.dart';

import 'string.dart';

String? requiredField(String value, {String? message}) {
  if (StringService.isEmpty(value)) {
    return message ?? "Campo obrigatório";
  }
  return null;
}

String? minLength(String value, int min, {String? message}) {
  if (value.length < min) {
    return message ?? "Mínimo de $min caracteres";
  }
  return null;
}

String? containsCharacter(String value, String character, {String? message}) {
  if (value.contains(character)) {
    return message ?? "Caracter $character necessário";
  }
  return null;
}

String? name(String value) {
  return requiredField(value);
}

String? password(String value) {
  return requiredField(value) ?? minLength(value, 8);
}

String? tag(String value) {
  return requiredField(value) ?? minLength(value, 4) ?? _tag(value);
}

String? _tag(String value, {String? message}) {
  if (!RegExp(r'^[a-zA-Z0-9_.]+$').hasMatch(value)) {
    return message ?? "Use apenas letras, números e/ou , . _";
  }
  return null;
}

String? email(String value, {String? message}) {
  if (!isEmail(value)) {
    return message ?? "E-mail inválido";
  }
  return null;
}

String? message(String value, {String? message}) {
  if (requiredField(value) != null) {
    return message ?? "Campo obrigatório";
  } else if (minLength(value, 10) != null) {
    return message ?? "Mínimo de 10 caracteres";
  }

  return null;
}

String? communityDescription(String value, {String? message}) {
  if (requiredField(value) != null) {
    return message ?? "Campo obrigatório";
  } else if (minLength(value, 10) != null) {
    return message ?? "Mínimo de 10 caracteres";
  }

  return null;
}
