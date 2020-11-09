class Validator {
  static String empty = 'Champ vide';

  static String nameValidator(String name) {
    if (name.isEmpty) return (empty);
    return (null);
  }

  static String phoneValidator(String phone) {
    if (phone.isEmpty) return (empty);
    return (null);
  }

  static String emailValidator(String email) {
    if (email.isEmpty) return (empty);
    if (!RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(email))
      return ("Adresse mail invalide");
    return (null);
  }
}