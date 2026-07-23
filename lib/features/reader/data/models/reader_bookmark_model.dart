import '../../domain/entities/reader_bookmark.dart';

/// Serializable bookmark model used by local persistence adapters.
class ReaderBookmarkModel {
  const ReaderBookmarkModel({
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

  factory ReaderBookmarkModel.fromEntity(ReaderBookmark bookmark) => ReaderBookmarkModel(
        id: bookmark.id,
        documentPath: bookmark.documentPath,
        pageNumber: bookmark.pageNumber,
        name: bookmark.name,
        createdAt: bookmark.createdAt,
        updatedAt: bookmark.updatedAt,
      );

  ReaderBookmark toEntity() => ReaderBookmark(
        id: id,
        documentPath: documentPath,
        pageNumber: pageNumber,
        name: name,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
