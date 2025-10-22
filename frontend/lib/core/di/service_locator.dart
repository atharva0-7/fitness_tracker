import 'package:get_it/get_it.dart';
import '../../data/data_sources/remote_data_source.dart';
import '../../data/data_sources/local_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../data/repositories/workout_repository_impl.dart';
import '../../data/repositories/meal_repository_impl.dart';
import '../../data/repositories/progress_repository_impl.dart';
import '../../data/repositories/ai_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/repositories/workout_repository.dart';
import '../../domain/repositories/meal_repository.dart';
import '../../domain/repositories/progress_repository.dart';
import '../../domain/repositories/ai_repository.dart';
import '../../domain/usecases/auth_usecases.dart';
import '../../domain/usecases/ai_usecases.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // Data Sources
  sl.registerLazySingleton<RemoteDataSource>(() => RemoteDataSource());
  sl.registerLazySingleton<LocalDataSource>(() => LocalDataSource());

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  sl.registerLazySingleton<WorkoutRepository>(
    () => WorkoutRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  sl.registerLazySingleton<MealRepository>(
    () => MealRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  sl.registerLazySingleton<ProgressRepository>(
    () => ProgressRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  sl.registerLazySingleton<AiRepository>(
    () => AiRepositoryImpl(remoteDataSource: sl()),
  );

  // Use Cases
  sl.registerLazySingleton<AuthUseCases>(
    () => AuthUseCases(authRepository: sl()),
  );

  sl.registerLazySingleton<AiUseCases>(() => AiUseCases(aiRepository: sl()));
}
