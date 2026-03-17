/// 阅读器初始状态，由 delegate 提供给 controller。
class ReaderInitialState {
  final String bookName;
  final int totalChapterCount;
  final int initialChapterIndex;
  final int initialPageIndex;

  const ReaderInitialState({
    required this.bookName,
    required this.totalChapterCount,
    required this.initialChapterIndex,
    required this.initialPageIndex,
  });
}

/// 阅读器宿主委托，抽象了本地/云端的数据来源差异。
///
/// controller 只依赖此接口获取数据，不直接接触数据库或 API。
abstract class ReaderDelegate {
  /// 加载初始状态（书名、章节数、初始阅读位置）。
  Future<ReaderInitialState> loadInitialState();

  /// 获取章节名称。
  String getChapterName(int index);

  /// 获取当前章节总数（可能在换源后变化）。
  int get totalChapterCount;

  /// 获取章节正文。失败时应抛异常，由 controller 统一处理。
  Future<String> fetchContent(int chapterIndex, {bool reacquire = false});

  /// 持久化阅读进度。由 controller 防抖后调用。
  Future<void> saveProgress({
    required int chapterIndex,
    required int pageIndex,
  });

  /// 页面离开时的清理工作（如同步书架、远程同步进度）。
  Future<void> onLeave();
}
