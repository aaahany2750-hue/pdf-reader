/// Domain-specific exception used by the reader feature boundary.
class ReaderException implements Exception {
  const ReaderException(this.message, [this.cause]);

  final String message;
  final Object? cause;

  @override
  String toString() => cause == null ? message : '$message: $cause';
}
