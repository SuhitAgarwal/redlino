class Failure {
  final String message;
  String? code;

  Failure(this.message, {this.code});

  @override
  String toString() => "Code $code; $message";
}
