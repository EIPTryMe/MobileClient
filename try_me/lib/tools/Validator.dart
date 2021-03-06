class Validator {
  static String nameValidator(String name) {
    if (name.isEmpty)
      return ('Champ obligatoire');
    return (null);
  }

  static String phoneValidator(String phone) {
    if (phone.isNotEmpty && !RegExp(r"^[0-9]{10}$").hasMatch(phone))
      return ("Téléphone invalide");
    return (null);
  }

  static String emailValidator(String email) {
    if (email.isNotEmpty &&
        !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
            .hasMatch(email)) return ("Adresse mail invalide");
    return (null);
  }
}
