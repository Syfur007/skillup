// Core: Input validation logic (placeholder)

bool isValidEmail(String? email) {
  if (email == null) return false;
  final emailRegex = RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+$");
  return emailRegex.hasMatch(email);
}

bool isValidPassword(String? password) {
  if (password == null) return false;
  // Simple rule: at least 6 characters. Update rules as needed.
  return password.length >= 6 ;
}

