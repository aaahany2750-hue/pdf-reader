/// File-system metadata required to open and restore a PDF document.
class ReaderDocument {
  const ReaderDocument({
    required this.path,
    required this.name,
    required this.size,
    required this.initialPage,
  });

  final String path;
  final String name;
  final int size;
  final int initialPage;
}
