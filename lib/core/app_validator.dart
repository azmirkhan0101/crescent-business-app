bool isEmailValid({required String email}) {
  return RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  ).hasMatch(email);
}

bool isPasswordValid({required String password}) {
  final regex = RegExp(
    r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$&*~?%^()_\-+=<>.,;:{}\[\]|/]).{8,}$',
  );
  return regex.hasMatch(password);
}