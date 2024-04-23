import 'package:bim_app_task/core/core.dart';
import 'package:bim_app_task/features/auth/domain/repositories/auth_repository.dart';
import 'package:bim_app_task/features/home/data/data.dart';
import 'package:bim_app_task/features/home/domain/domain.dart';
import 'package:bim_app_task/features/home/domain/repositories/BMI_repository.dart';
import 'package:bim_app_task/features/home/domain/usecases/DeleteBMI.dart';
import 'package:bim_app_task/features/home/domain/usecases/editBMI.dart';
import 'package:bim_app_task/features/home/presentation/cubit/bmi_cubit.dart';
import 'package:get_it/get_it.dart';
import 'features/auth/auth.dart';
import 'utils/services/hive/main_box.dart';

GetIt sl = GetIt.instance;

Future<void> serviceLocator({
  bool isUnitTest = false,
  bool isHiveEnable = true,
}) async {
  /// For unit testing only
  if (isUnitTest) {
    await sl.reset();
  }
  _dataSources();
  _repositories();
  _useCase();
  _cubit();
  await CacheHelper.init(); // Ensure sharedPreferences is initialized

  if (isHiveEnable) await _initHiveBoxes(isUnitTest: isUnitTest);
}

Future<void> _initHiveBoxes({bool isUnitTest = false}) async {
  await MainBoxMixin.initHive();

  sl.registerSingleton<MainBoxMixin>(MainBoxMixin());
}

/// Register repositories
void _repositories() {
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton<BMIRepository>(
    () => BMIRepositoryImpl(sl(), sl()),
  );
}

/// Register dataSources
void _dataSources() {
  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(),
  );
  sl.registerLazySingleton<BMIRemoteDatasource>(
    () => BMIRemoteDatasourceImpl(),
  );
}

void _useCase() {
  sl.registerLazySingleton(() => PostLogin(sl()));
  sl.registerLazySingleton(() => PostRegister(sl()));
  sl.registerLazySingleton(() => SaveBMI(sl()));
  sl.registerLazySingleton(() => GetBMIList(sl()));
  sl.registerLazySingleton(() => DeleteBMI(sl()));
  sl.registerLazySingleton(() => EditBMI(sl()));
}

void _cubit() {
  sl.registerFactory(() => AuthCubit(
        sl(),
        sl(),
      ));
  sl.registerFactory(() => BMICubit(sl(), sl(), sl(), sl()));
}
