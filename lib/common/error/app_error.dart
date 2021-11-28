class AppError extends Error {
  final String message;

  AppError(this.message);

  @override
  String toString() => "Something went wrong!\n$message";
}
