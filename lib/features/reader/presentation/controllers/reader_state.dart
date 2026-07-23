import '../../domain/entities/reader_document.dart';

enum ReaderStatus { empty, loading, ready, error }

class ReaderState {
  const ReaderState({
    required this.status,
    this.document,
    this.currentPage = 1,
    this.pageCount,
    this.errorMessage,
  });

  const ReaderState.empty() : this(status: ReaderStatus.empty);
  const ReaderState.loading({ReaderDocument? document})
      : this(status: ReaderStatus.loading, document: document);
  const ReaderState.ready({
    required ReaderDocument document,
    int currentPage = 1,
    int? pageCount,
  }) : this(
          status: ReaderStatus.ready,
          document: document,
          currentPage: currentPage,
          pageCount: pageCount,
        );
  const ReaderState.error(String message)
      : this(status: ReaderStatus.error, errorMessage: message);

  final ReaderStatus status;
  final ReaderDocument? document;
  final int currentPage;
  final int? pageCount;
  final String? errorMessage;

  ReaderState copyWith({
    ReaderStatus? status,
    ReaderDocument? document,
    int? currentPage,
    int? pageCount,
    String? errorMessage,
  }) =>
      ReaderState(
        status: status ?? this.status,
        document: document ?? this.document,
        currentPage: currentPage ?? this.currentPage,
        pageCount: pageCount ?? this.pageCount,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}
