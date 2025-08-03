import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:thrill_quest/app/context/auth_service.dart';
import 'package:thrill_quest/core/common/internet_checker/internet_checker_impl.dart';

import 'package:thrill_quest/core/network/api_service.dart';
import 'package:thrill_quest/core/network/hive_service.dart';
import 'package:thrill_quest/core/utils/internet_checker.dart';
import 'package:thrill_quest/features/auth/data/data_source/local_data_source/auth_local_data_source.dart';

import 'package:thrill_quest/features/auth/data/data_source/remote_local_source/auth_remote_datasource.dart';
import 'package:thrill_quest/features/auth/data/repository/auth_remote_repository.dart';
import 'package:thrill_quest/features/auth/domain/repository/auth_repository.dart';
import 'package:thrill_quest/features/auth/domain/repository/auth_repository_impl.dart';
import 'package:thrill_quest/features/auth/domain/use_case/auth_login_usecase.dart';
import 'package:thrill_quest/features/auth/domain/use_case/auth_register_usecase.dart';
import 'package:thrill_quest/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:thrill_quest/features/auth/presentation/view_model/signup_view_model/signup_view_model.dart';
import 'package:thrill_quest/features/bookings/data/data_source/local_data_source/bookings_local_data_source.dart';
import 'package:thrill_quest/features/bookings/data/data_source/remote_data_source/bookings_remote_data_source.dart';
import 'package:thrill_quest/features/bookings/data/repository/bookings_local_repository.dart';
import 'package:thrill_quest/features/bookings/data/repository/bookings_remote_repository.dart';
import 'package:thrill_quest/features/bookings/domain/repository/bookings_repository.dart';
import 'package:thrill_quest/features/bookings/domain/repository/bookings_repository_impl.dart';
import 'package:thrill_quest/features/bookings/domain/use_case/create_booking_usecase.dart';
import 'package:thrill_quest/features/bookings/domain/use_case/get_my_bookings_usecase.dart';
import 'package:thrill_quest/features/bookings/domain/use_case/update_booking_usecase.dart';
import 'package:thrill_quest/features/bookings/presentation/view_model/all_bookings_view_model.dart';
import 'package:thrill_quest/features/dashboard/presentation/view_model/dashboard_view_model.dart';
import 'package:thrill_quest/features/favorites/data/data_source/local_data_source/favorite_local_data_source.dart';
import 'package:thrill_quest/features/favorites/data/data_source/remote_data_source/favorite_remote_data_source.dart';
import 'package:thrill_quest/features/favorites/domain/repository/favorite_repository.dart';
import 'package:thrill_quest/features/favorites/domain/repository/favorite_repository_impl.dart';
import 'package:thrill_quest/features/favorites/domain/usecase/add_to_favorite_usecase.dart';
import 'package:thrill_quest/features/favorites/domain/usecase/get_favorites_usecase.dart';
import 'package:thrill_quest/features/favorites/domain/usecase/remove_from_favorite.dart';
import 'package:thrill_quest/features/favorites/presentation/view_model/favorites_view_model.dart';
import 'package:thrill_quest/features/guides/data/data_source/local_data_source/guide_local_data_source.dart';
import 'package:thrill_quest/features/guides/data/data_source/remote_data_source/guide_remote_data_source.dart';
import 'package:thrill_quest/features/guides/data/repository/guide_local_repository.dart';
import 'package:thrill_quest/features/guides/data/repository/guide_remote_repository.dart';
import 'package:thrill_quest/features/guides/domain/repository/guide_repository.dart';
import 'package:thrill_quest/features/guides/domain/repository/guide_repository_impl.dart';
import 'package:thrill_quest/features/guides/domain/use_case/cache_guides_usecase.dart';
import 'package:thrill_quest/features/guides/domain/use_case/get_all_guides_usecase.dart';
import 'package:thrill_quest/features/home/data/data_source/remote_data_source/activity_remote_data_source.dart';
import 'package:thrill_quest/features/home/data/repository/activity_remote_repository.dart';
import 'package:thrill_quest/features/home/domain/repository/activity_repository.dart';
import 'package:thrill_quest/features/home/domain/use_case/create_activity_usecase.dart';
import 'package:thrill_quest/features/home/domain/use_case/delete_activity_usecase.dart';
import 'package:thrill_quest/features/home/domain/use_case/get_activity_id_usecase.dart';
import 'package:thrill_quest/features/home/domain/use_case/get_all_activties_usecase.dart';
import 'package:thrill_quest/features/home/domain/use_case/update_activity_usecase.dart';
import 'package:thrill_quest/features/bookings/presentation/view_model/booking_view_model.dart';
import 'package:thrill_quest/features/home/presentation/view_model/home_view_model.dart';
import 'package:thrill_quest/features/profile/domain/use_case/get_user_profile_usecase.dart';
import 'package:thrill_quest/features/profile/domain/use_case/update_user_profile_usecase.dart';
import 'package:thrill_quest/features/profile/presentation/view_model/profile_view_model.dart';
import 'package:thrill_quest/features/splash/presentation/view_model/splash_view_model.dart';

// Home Module

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  serviceLocator.registerLazySingleton<HiveService>(() => HiveService());
  serviceLocator.registerLazySingleton<AuthService>(() => AuthService());
  serviceLocator.registerLazySingleton<FlutterSecureStorage>(
    () => FlutterSecureStorage(),
  );
  serviceLocator.registerLazySingleton<InternetChecker>(
    () => InternetCheckerImpl(),
  );
  _initSplash();
  _initDashboard();
  _initApiService();
  _initAuthModule();
  _initHomeModule();
  _initGuideModule();
  _initBookingModule();
  _initMyBooking();
  _initProfile();
  _initFavorites();
}

Future<void> _initApiService() async {
  serviceLocator.registerLazySingleton<ApiService>(
    () => ApiService(Dio(), serviceLocator()),
  );
}

// -------------------- AUTH MODULE --------------------
Future<void> _initAuthModule() async {
  serviceLocator.registerFactory(
    () => AuthRemoteDatasource(apiService: serviceLocator<ApiService>()),
  );

  serviceLocator.registerFactory(
    () => AuthLocalDatasource(
      hiveService: serviceLocator<HiveService>(),
      secureStorage: serviceLocator<FlutterSecureStorage>(),
    ),
  );

  serviceLocator.registerFactory(
    () => AuthRemoteRepository(
      authRemoteDatasource: serviceLocator<AuthRemoteDatasource>(),
    ),
  );

  serviceLocator.registerFactory(
    () => AuthRegisterUsecase(
      authRepository: serviceLocator<AuthRemoteRepository>(),
    ),
  );

  serviceLocator.registerFactory(
    () => AuthLoginUsecase(
      authRepository: serviceLocator<AuthRemoteRepository>(),
      authService: serviceLocator<AuthService>(),
    ),
  );

  serviceLocator.registerFactory<SignupViewModel>(
    () => SignupViewModel(serviceLocator<AuthRegisterUsecase>()),
  );

  serviceLocator.registerFactory<LoginViewModel>(
    () => LoginViewModel(serviceLocator<AuthLoginUsecase>()),
  );
}

// -------------------- HOME MODULE --------------------
Future<void> _initHomeModule() async {
  serviceLocator.registerFactory<ActivityRemoteDatasource>(
    () => ActivityRemoteDatasource(apiService: serviceLocator<ApiService>()),
  );

  serviceLocator.registerFactory<IActivityRepository>(
    () => ActivityRemoteRepository(
      activityRemoteDatasource: serviceLocator<ActivityRemoteDatasource>(),
      remoteDatasource: serviceLocator<ActivityRemoteDatasource>(),
    ),
  );

  serviceLocator.registerLazySingleton<GetAllActivitiesUseCase>(
    () => GetAllActivitiesUseCase(
      repository: serviceLocator<IActivityRepository>(),
    ),
  );

  serviceLocator.registerFactory<CreateActivityUseCase>(
    () => CreateActivityUseCase(
      repository: serviceLocator<IActivityRepository>(),
    ),
  );

  // Register other use cases as needed
  serviceLocator.registerFactory<GetActivityByIdUseCase>(
    () => GetActivityByIdUseCase(
      repository: serviceLocator<IActivityRepository>(),
    ),
  );

  serviceLocator.registerFactory<UpdateActivityUseCase>(
    () => UpdateActivityUseCase(
      repository: serviceLocator<IActivityRepository>(),
    ),
  );

  serviceLocator.registerFactory<DeleteActivityUseCase>(
    () => DeleteActivityUseCase(
      repository: serviceLocator<IActivityRepository>(),
    ),
  );

  serviceLocator.registerFactory<HomeViewModel>(
    () => HomeViewModel(
      getAllActivitiesUseCase: serviceLocator<GetAllActivitiesUseCase>(),
    ), 
  );
}

Future<void> _initDashboard() async {
  serviceLocator.registerFactory<DashboardViewModel>(
    () => DashboardViewModel(authService: serviceLocator<AuthService>(), navigate: (context, route) {  }),
  );
}

Future<void> _initGuideModule() async {
  // Data Sources
  serviceLocator.registerFactory<GuideRemoteDataSource>(
    () => GuideRemoteDataSource(apiService: serviceLocator<ApiService>()),
  );

  serviceLocator.registerFactory<GuideLocalDataSource>(
    () => GuideLocalDataSource(hiveService: serviceLocator<HiveService>()),
  );

  serviceLocator.registerFactory<GuideRemoteRepository>(
    () => GuideRemoteRepository(
      remoteDataSource: serviceLocator<GuideRemoteDataSource>(),
    ),
  );

  serviceLocator.registerFactory<GuideLocalRepository>(
    () => GuideLocalRepository(hiveService: serviceLocator<HiveService>()),
  );

  // Repository
  serviceLocator.registerFactory<IGuideRepository>(
    () => GuideRepositoryImpl(
      remoteRepository: serviceLocator<GuideRemoteRepository>(),
      localRepository: serviceLocator<GuideLocalRepository>(),
      internetChecker: serviceLocator<InternetChecker>(),
    ),
  );

  // Usecases
  serviceLocator.registerFactory<GetAllGuidesUsecase>(
    () => GetAllGuidesUsecase(serviceLocator<IGuideRepository>()),
  );

  serviceLocator.registerFactory<CacheGuidesUsecase>(
    () => CacheGuidesUsecase(serviceLocator<IGuideRepository>()),
  );
}

Future<void> _initBookingModule() async {
  // Data Sources
  serviceLocator.registerLazySingleton<BookingsRemoteDataSource>(
    () => BookingsRemoteDataSource(apiService: serviceLocator<ApiService>()),
  );

  serviceLocator.registerLazySingleton<BookingsLocalDataSource>(
    () => BookingsLocalDataSource(hiveService: serviceLocator<HiveService>()),
  );

  serviceLocator.registerLazySingleton<BookingsRemoteRepository>(
    () => BookingsRemoteRepository(
      remoteDataSource: serviceLocator<BookingsRemoteDataSource>(),
    ),
  );

  serviceLocator.registerLazySingleton<BookingsLocalRepository>(
    () => BookingsLocalRepository(
      localDataSource: serviceLocator<BookingsLocalDataSource>(),
    ),
  );

  // Repository
  serviceLocator.registerLazySingleton<IBookingsRepository>(
    () => BookingsRepositoryImpl(
      remoteRepository: serviceLocator<BookingsRemoteRepository>(),
      localRepository: serviceLocator<BookingsLocalRepository>(),
      internetChecker: serviceLocator<InternetChecker>(),
    ),
  );

  // Usecases
  serviceLocator.registerLazySingleton<GetMyBookingsUsecase>(
    () => GetMyBookingsUsecase(
      bookingsRepository: serviceLocator<IBookingsRepository>(),
    ),
  );

  serviceLocator.registerLazySingleton<UpdateBookingUsecase>(
    () => UpdateBookingUsecase(
      bookingsRepository: serviceLocator<IBookingsRepository>(),
    ),
  );

  serviceLocator.registerLazySingleton<CreateBookingUsecase>(
    () => CreateBookingUsecase(
      bookingsRepository: serviceLocator<IBookingsRepository>(),
    ),
  );

  serviceLocator.registerLazySingleton<BookingViewModel>(
    () => BookingViewModel(
      createBookingUsecase: serviceLocator<CreateBookingUsecase>(),
      getAllGuidesUsecase: serviceLocator<GetAllGuidesUsecase>(),
      authService: serviceLocator<AuthService>(),
    ),
  );
}

Future<void> _initMyBooking() async {
  serviceLocator.registerFactory<AllBookingsViewModel>(
    () => AllBookingsViewModel(
      getMyBookingsUsecase: serviceLocator<GetMyBookingsUsecase>(),
    ),
  );
}

Future<void> _initProfile() async {
  serviceLocator.registerFactory<GetUserProfileUsecase>(
    () => GetUserProfileUsecase(
      authRepository: serviceLocator<IAuthRepository>(),
    ),
  );

  serviceLocator.registerFactory<UpdateProfileUsecase>(
    () =>
        UpdateProfileUsecase(authRepository: serviceLocator<IAuthRepository>()),
  );

  serviceLocator.registerFactory<IAuthRepository>(
    () => AuthRepositoryImpl(
      authRemoteDatasource: serviceLocator(),
      authLocalDatasource: serviceLocator(),
      internetChecker: serviceLocator<InternetChecker>(),
    ),
  );

  serviceLocator.registerFactory<ProfileViewModel>(
    () => ProfileViewModel(
      getUserProfileUsecase: serviceLocator<GetUserProfileUsecase>(),
      updateUserProfileUsecase: serviceLocator<UpdateProfileUsecase>(),
    ),
  );
}

void _initSplash() {
  serviceLocator.registerFactory<SplashViewModel>(
    () => SplashViewModel(authService: serviceLocator<AuthService>()),
  );
}

void _initFavorites() {
  serviceLocator.registerFactory<FavoritesLocalDatasource>(
    () => FavoritesLocalDatasource(hiveService: serviceLocator<HiveService>()),
  );
  serviceLocator.registerFactory<FavoritesRemoteDataSource>(
    () => FavoritesRemoteDataSource(apiService: serviceLocator<ApiService>()),
  );
  serviceLocator.registerFactory<IFavoritesRepository>(
    () => FavoritesRepositoryImpl(
      localDataSource: serviceLocator<FavoritesLocalDatasource>(),
      remoteDataSource: serviceLocator<FavoritesRemoteDataSource>(),
      internetChecker: serviceLocator<InternetChecker>(),
    ),
  );

  serviceLocator.registerFactory<GetFavoritesUseCase>(
    () => GetFavoritesUseCase(
      favoritesRepository: serviceLocator<IFavoritesRepository>(),
    ),
  );

  serviceLocator.registerFactory<AddToFavoritesUseCase>(
    () => AddToFavoritesUseCase(serviceLocator<IFavoritesRepository>()),
  );

  serviceLocator.registerFactory<RemoveFromFavoritesUseCase>(
    () => RemoveFromFavoritesUseCase(serviceLocator<IFavoritesRepository>()),
  );

  serviceLocator.registerLazySingleton<FavoritesViewModel>(
    () => FavoritesViewModel(
      addToFavoritesUseCase: serviceLocator<AddToFavoritesUseCase>(),
      removeFromFavoritesUseCase: serviceLocator<RemoveFromFavoritesUseCase>(),
      getFavoritesUseCase: serviceLocator<GetFavoritesUseCase>(),
    ),
  );
}
