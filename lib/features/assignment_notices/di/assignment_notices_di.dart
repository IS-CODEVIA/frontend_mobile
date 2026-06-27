import '../../../core/di/app_container.dart';
import '../data/datasources/notice_remote_datasource.dart';
import '../data/repositories/notice_repository_impl.dart';
import '../domain/repositories/notice_repository.dart';
import '../domain/usecases/get_notices_usecase.dart';

class AssignmentNoticesDI {
  final AppContainer appContainer;

  late final NoticeRemoteDataSource noticeRemoteDataSource;
  late final NoticeRepository noticeRepository;
  late final GetNoticesUsecase getNoticesUsecase;

  AssignmentNoticesDI(this.appContainer) {
    _init();
  }

  void _init() {
    noticeRemoteDataSource = NoticeRemoteDataSource(
      apiClient: appContainer.apiClient,
    );

    noticeRepository = NoticeRepositoryImpl(
      remoteDataSource: noticeRemoteDataSource,
    );

    getNoticesUsecase = GetNoticesUsecase(repository: noticeRepository);
  }
}
