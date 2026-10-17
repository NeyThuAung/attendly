// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:attendly/core/database/app_database.dart' as _i565;
import 'package:attendly/core/services/cloudinary_service.dart' as _i595;
import 'package:attendly/core/services/location_service.dart' as _i147;
import 'package:attendly/core/services/snack_shower.dart' as _i159;
import 'package:attendly/core/storage/storage.dart' as _i75;
import 'package:attendly/di/third_party_modules/app_logger.dart' as _i649;
import 'package:attendly/di/third_party_modules/firebase_module.dart' as _i165;
import 'package:attendly/di/third_party_modules/logger_module.dart' as _i434;
import 'package:attendly/di/third_party_modules/shared_preferences_provider.dart'
    as _i692;
import 'package:attendly/features/admin/data/data_source/admin_remote_data_source.dart'
    as _i798;
import 'package:attendly/features/admin/data/repository_impl/admin_repository_impl.dart'
    as _i712;
import 'package:attendly/features/admin/domain/repository/admin_repository.dart'
    as _i614;
import 'package:attendly/features/admin/domain/usecases/get_all_user_history_use_case.dart'
    as _i466;
import 'package:attendly/features/admin/domain/usecases/get_dashboard_summary_use_case.dart'
    as _i489;
import 'package:attendly/features/admin/domain/usecases/get_users_list_use_case.dart'
    as _i96;
import 'package:attendly/features/admin/presentation/pages/dashboard/cubit/admin_dashboard_cubit.dart'
    as _i663;
import 'package:attendly/features/admin/presentation/pages/user_history/cubit/admin_history_cubit.dart'
    as _i426;
import 'package:attendly/features/admin/presentation/pages/users_list/cubit/users_list_cubit.dart'
    as _i1067;
import 'package:attendly/features/attendance/data/data_source/attendance_local_data_source.dart'
    as _i735;
import 'package:attendly/features/attendance/data/data_source/attendance_remote_data_source.dart'
    as _i594;
import 'package:attendly/features/attendance/data/repository_impl/attendance_repository_impl.dart'
    as _i405;
import 'package:attendly/features/attendance/domain/repository/attendance_repository.dart'
    as _i50;
import 'package:attendly/features/attendance/domain/usecases/check_in_use_case.dart'
    as _i457;
import 'package:attendly/features/attendance/domain/usecases/check_out_use_case.dart'
    as _i535;
import 'package:attendly/features/attendance/domain/usecases/get_last_attendance_log_use_case.dart'
    as _i516;
import 'package:attendly/features/attendance/domain/usecases/get_user_history_use_case.dart'
    as _i838;
import 'package:attendly/features/attendance/domain/usecases/sync_offline_attendance_use_case.dart'
    as _i994;
import 'package:attendly/features/attendance/presentation/pages/history/cubit/user_history_cubit.dart'
    as _i830;
import 'package:attendly/features/attendance/presentation/pages/home/cubit/home_page_cubit.dart'
    as _i105;
import 'package:attendly/features/auth/data/data_source/auth_remote_data_source.dart'
    as _i225;
import 'package:attendly/features/auth/data/repository_impl/auth_repository_impl.dart'
    as _i935;
import 'package:attendly/features/auth/domain/repository/auth_repository.dart'
    as _i1020;
import 'package:attendly/features/auth/domain/usecases/get_current_user_use_case.dart'
    as _i132;
import 'package:attendly/features/auth/domain/usecases/login_use_case.dart'
    as _i871;
import 'package:attendly/features/auth/domain/usecases/logout_use_case.dart'
    as _i482;
import 'package:attendly/features/auth/domain/usecases/register_use_case.dart'
    as _i686;
import 'package:attendly/features/auth/presentation/cubit/authentication_cubit.dart'
    as _i568;
import 'package:attendly/features/auth/presentation/cubit/authentication_cubit_provider.dart'
    as _i80;
import 'package:attendly/features/auth/presentation/pages/login_register/login/cubit/login_cubit.dart'
    as _i1053;
import 'package:attendly/features/auth/presentation/pages/login_register/register/cubit/register_cubit.dart'
    as _i408;
import 'package:attendly/navigation/navigation_key_provider.dart' as _i515;
import 'package:attendly/navigation/router.dart' as _i782;
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:firebase_storage/firebase_storage.dart' as _i457;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:logger/logger.dart' as _i974;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final sharedPreferencesModule = _$SharedPreferencesModule();
    final firebaseModule = _$FirebaseModule();
    final loggerModule = _$LoggerModule();
    final authenticationCubitProvider = _$AuthenticationCubitProvider();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => sharedPreferencesModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i565.AppDatabase>(() => _i565.AppDatabase());
    gh.lazySingleton<_i59.FirebaseAuth>(() => firebaseModule.firebaseAuth);
    gh.lazySingleton<_i974.FirebaseFirestore>(
        () => firebaseModule.firebaseFirestore);
    gh.lazySingleton<_i457.FirebaseStorage>(
        () => firebaseModule.firebaseStorage);
    gh.lazySingleton<_i974.Logger>(() => loggerModule.logger);
    gh.lazySingleton<_i595.ICloudinaryService>(() => _i595.CloudinaryService());
    gh.singleton<_i515.INavigationKeyProvider>(
        () => _i515.NavigationKeyProvider());
    gh.lazySingleton<_i147.LocationService>(() => _i147.LocationServiceImpl());
    gh.lazySingleton<_i735.AttendanceLocalDataSource>(
        () => _i735.AttendanceLocalDataSourceImpl(gh<_i565.AppDatabase>()));
    gh.lazySingleton<_i649.AppLogger>(
        () => loggerModule.appLogger(gh<_i974.Logger>()));
    gh.lazySingleton<_i594.AttendanceRemoteDataSource>(() =>
        _i594.AttendanceRemoteDataSourceImpl(gh<_i974.FirebaseFirestore>()));
    gh.lazySingleton<_i225.AuthRemoteDataSource>(
        () => _i225.AuthRemoteDataSourceImpl(
              gh<_i59.FirebaseAuth>(),
              gh<_i974.FirebaseFirestore>(),
              gh<_i595.ICloudinaryService>(),
            ));
    gh.lazySingleton<_i75.Storage>(
        () => _i75.StorageImpl(gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i159.ISnackShower>(
        () => _i159.SnackShower(gh<_i515.INavigationKeyProvider>()));
    gh.lazySingleton<_i798.AdminRemoteDataSource>(
        () => _i798.AdminRemoteDataSourceImpl(gh<_i974.FirebaseFirestore>()));
    gh.lazySingleton<_i614.AdminRepository>(
        () => _i712.AdminRepositoryImpl(gh<_i798.AdminRemoteDataSource>()));
    gh.lazySingleton<_i1020.AuthRepository>(
        () => _i935.AuthRepositoryImpl(gh<_i225.AuthRemoteDataSource>()));
    gh.lazySingleton<_i50.AttendanceRepository>(
        () => _i405.AttendanceRepositoryImpl(
              gh<_i594.AttendanceRemoteDataSource>(),
              gh<_i735.AttendanceLocalDataSource>(),
            ));
    gh.lazySingleton<_i132.GetCurrentUserUseCase>(
        () => _i132.GetCurrentUserUseCase(gh<_i1020.AuthRepository>()));
    gh.lazySingleton<_i871.LoginUseCase>(
        () => _i871.LoginUseCase(gh<_i1020.AuthRepository>()));
    gh.lazySingleton<_i482.LogoutUseCase>(
        () => _i482.LogoutUseCase(gh<_i1020.AuthRepository>()));
    gh.lazySingleton<_i686.RegisterUseCase>(
        () => _i686.RegisterUseCase(gh<_i1020.AuthRepository>()));
    await gh.singletonAsync<_i568.AuthenticationCubit>(
      () => authenticationCubitProvider.provide(
        gh<_i132.GetCurrentUserUseCase>(),
        gh<_i482.LogoutUseCase>(),
        gh<_i1020.AuthRepository>(),
      ),
      preResolve: true,
    );
    gh.lazySingleton<_i466.GetAllUserHistoryUseCase>(
        () => _i466.GetAllUserHistoryUseCase(gh<_i614.AdminRepository>()));
    gh.lazySingleton<_i489.GetDashboardSummaryUseCase>(
        () => _i489.GetDashboardSummaryUseCase(gh<_i614.AdminRepository>()));
    gh.lazySingleton<_i96.GetUsersListUseCase>(
        () => _i96.GetUsersListUseCase(gh<_i614.AdminRepository>()));
    gh.lazySingleton<_i457.CheckInUseCase>(
        () => _i457.CheckInUseCase(gh<_i50.AttendanceRepository>()));
    gh.lazySingleton<_i535.CheckOutUseCase>(
        () => _i535.CheckOutUseCase(gh<_i50.AttendanceRepository>()));
    gh.lazySingleton<_i516.GetLastAttendanceLogUseCase>(() =>
        _i516.GetLastAttendanceLogUseCase(gh<_i50.AttendanceRepository>()));
    gh.lazySingleton<_i838.GetUserHistoryUseCase>(
        () => _i838.GetUserHistoryUseCase(gh<_i50.AttendanceRepository>()));
    gh.lazySingleton<_i994.SyncOfflineAttendanceUseCase>(() =>
        _i994.SyncOfflineAttendanceUseCase(gh<_i50.AttendanceRepository>()));
    gh.factory<_i105.HomePageCubit>(() => _i105.HomePageCubit(
          gh<_i568.AuthenticationCubit>(),
          gh<_i147.LocationService>(),
          gh<_i457.CheckInUseCase>(),
          gh<_i535.CheckOutUseCase>(),
          gh<_i994.SyncOfflineAttendanceUseCase>(),
          gh<_i516.GetLastAttendanceLogUseCase>(),
          gh<_i50.AttendanceRepository>(),
          gh<_i159.ISnackShower>(),
        ));
    gh.lazySingleton<_i782.NavigationRouter>(() => _i782.NavigationRouter(
          gh<_i515.INavigationKeyProvider>(),
          gh<_i159.ISnackShower>(),
          gh<_i568.AuthenticationCubit>(),
        ));
    gh.factory<_i1053.LoginCubit>(() => _i1053.LoginCubit(
          gh<_i568.AuthenticationCubit>(),
          gh<_i159.ISnackShower>(),
          gh<_i871.LoginUseCase>(),
          gh<_i75.Storage>(),
        ));
    gh.factory<_i426.AdminHistoryCubit>(() => _i426.AdminHistoryCubit(
          gh<_i466.GetAllUserHistoryUseCase>(),
          gh<_i96.GetUsersListUseCase>(),
          gh<_i159.ISnackShower>(),
        ));
    gh.factory<_i830.UserHistoryCubit>(() => _i830.UserHistoryCubit(
          gh<_i568.AuthenticationCubit>(),
          gh<_i838.GetUserHistoryUseCase>(),
          gh<_i159.ISnackShower>(),
        ));
    gh.factory<_i663.AdminDashboardCubit>(() => _i663.AdminDashboardCubit(
          gh<_i489.GetDashboardSummaryUseCase>(),
          gh<_i159.ISnackShower>(),
        ));
    gh.factory<_i1067.UsersListCubit>(() => _i1067.UsersListCubit(
          gh<_i96.GetUsersListUseCase>(),
          gh<_i159.ISnackShower>(),
        ));
    gh.factory<_i408.RegisterCubit>(() => _i408.RegisterCubit(
          gh<_i568.AuthenticationCubit>(),
          gh<_i159.ISnackShower>(),
          gh<_i686.RegisterUseCase>(),
        ));
    return this;
  }
}

class _$SharedPreferencesModule extends _i692.SharedPreferencesModule {}

class _$FirebaseModule extends _i165.FirebaseModule {}

class _$LoggerModule extends _i434.LoggerModule {}

class _$AuthenticationCubitProvider extends _i80.AuthenticationCubitProvider {}
