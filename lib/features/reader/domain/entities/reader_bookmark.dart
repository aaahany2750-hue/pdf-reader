/// User-managed bookmark inside a PDF document.
class ReaderBookmark {
  const ReaderBookmark({
    required this.id,
    required this.documentPath,
    required this.pageNumber,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String documentPath;
  final int pageNumber;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  ReaderBookmark copyWith({String? name, int? pageNumber, DateTime? updatedAt}) =>
      ReaderBookmark(
        id: id,
        documentPath: documentPath,
        pageNumber: pageNumber ?? this.pageNumber,
        name: name ?? this.name,
        createdAt: createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
}
