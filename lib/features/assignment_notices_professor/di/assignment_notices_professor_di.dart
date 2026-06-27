import '../../../core/di/app_container.dart';
import '../data/datasources/notice_remote_datasource.dart';
import '../data/repositories/notice_repository_impl.dart';
import '../domain/repositories/notice_repository.dart';
import '../domain/usecases/create_notice_usecase.dart';
import '../domain/usecases/get_notices_usecase.dart';

class AssignmentNoticesProfessorDI {
  final AppContainer appContainer;

  late final NoticeRemoteDataSource noticeRemoteDataSource;
  late final NoticeRepository noticeRepository;
  late final GetNoticesUsecase getNoticesUsecase;
  late final CreateNoticeUsecase createNoticeUsecase;

  AssignmentNoticesProfessorDI(this.appContainer) {
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
    createNoticeUsecase = CreateNoticeUsecase(repository: noticeRepository);
  }
}
