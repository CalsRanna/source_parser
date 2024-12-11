class ReaderState {
  int chapter = 0;
  int page = 0;

  ReaderState copyWith({int? chapter, int? page}) {
    return ReaderState()
      ..chapter = chapter ?? this.chapter
      ..page = page ?? this.page;
  }
}
