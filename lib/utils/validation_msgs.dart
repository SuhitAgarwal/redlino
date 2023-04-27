class FieldValidationMessages {
  static const nameRequired = "Name is required";
  static const emailRequired = "Email address is required";
  static const emailInvalid = "Email address is invalid";
  static const passwordRequired = "Password is required";
  static const passwordMinLength = "Password must be atleast 8 characters";
  static const number = "Must be a valid number";
  static String max(int max) => "Max is $max";
  static String min(int min) => "Min is $min";
}
