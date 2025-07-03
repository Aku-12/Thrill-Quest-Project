import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:thrill_quest/core/network/api_service.dart';
import 'package:thrill_quest/features/auth/data/data_source/remote_local_source/auth_remote_datasource.dart';
import 'package:thrill_quest/features/auth/data/repository/auth_remote_repository.dart';
// import 'package:thrill_quest/core/network/hive_service.dart';
// import 'package:thrill_quest/features/auth/data/data_source/local_data_source/auth_local_data_source.dart';
// import 'package:thrill_quest/features/auth/data/repository/auth_local_repository.dart';
import 'package:thrill_quest/features/auth/domain/use_case/auth_login_usecase.dart';
import 'package:thrill_quest/features/auth/domain/use_case/auth_register_usecase.dart';
import 'package:thrill_quest/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:thrill_quest/features/auth/presentation/view_model/signup_view_model/signup_view_model.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuthModule();
  // _initHiveService();
  _initApiService();
}

// Future<void> _initHiveService() async {
//   serviceLocator.registerLazySingleton<HiveService>(() => HiveService());
// }

Future<void> _initApiService() async {
  serviceLocator.registerLazySingleton<ApiService>(() => ApiService(Dio()));
}

Future<void> _initAuthModule() async {
  // serviceLocator.registerFactory(
  //   () => AuthLocalDataSource(hiveService: serviceLocator<HiveService>()),
  // );

  // serviceLocator.registerFactory(
  //   () => AuthLocalRepository(
  //     authLocalDataSource: serviceLocator<AuthLocalDataSource>(),
  //   ),
  // );

  // serviceLocator.registerFactory(
  //   () => AuthRegisterUsecase(authRepository: serviceLocator<AuthLocalRepository>())
  // );

  // serviceLocator.registerFactory(
  //   () => AuthLoginUsecase(authRepository: serviceLocator<AuthLocalRepository>())
  // );

  serviceLocator.registerFactory(
    () => AuthRegisterUsecase(
      authRepository: serviceLocator<AuthRemoteRepository>(),
    ),
  );

  serviceLocator.registerFactory(
    () =>
        AuthLoginUsecase(authRepository: serviceLocator<AuthRemoteRepository>()),
  );

  serviceLocator.registerFactory<SignupViewModel>(
    () => SignupViewModel(serviceLocator<AuthRegisterUsecase>()),
  );

  serviceLocator.registerFactory<LoginViewModel>(
    () => LoginViewModel(serviceLocator<AuthLoginUsecase>()),
  );

  serviceLocator.registerFactory(
    () => AuthRemoteDatasource(apiService: serviceLocator<ApiService>()),
  );

  serviceLocator.registerFactory(
    () => AuthRemoteRepository(
      authRemoteDatasource: serviceLocator<AuthRemoteDatasource>(),
    ),
  );
}
