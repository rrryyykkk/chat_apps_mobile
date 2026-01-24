import 'package:fe/core/network/api_client.dart';
import 'package:fe/data/datasources/chat_remote_datasource.dart';
import 'package:fe/data/datasources/contact_remote_datasource.dart';
import 'package:fe/data/datasources/media_remote_datasource.dart';
import 'package:fe/data/datasources/status_remote_datasource.dart';
import 'package:fe/data/repositories/chat_repository.dart';
import 'package:fe/data/repositories/contact_repository.dart';
import 'package:fe/data/repositories/status_repository.dart';
import 'package:fe/data/datasources/media_remote_datasource.dart';
import 'package:fe/services/isar_service.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

Future<void> initDependencies() async {
  // Services
  final isarService = IsarService();
  locator.registerSingleton<IsarService>(isarService);
  await isarService.openDB(); // Pre-open DB

  // ApiClient
  final apiClient = ApiClient(); // Assumes ApiClient has no heavy dependencies
  locator.registerSingleton<ApiClient>(apiClient);

  // Data Sources
  locator.registerLazySingleton(() => ContactRemoteDataSource(locator()));
  locator.registerLazySingleton(() => ChatRemoteDataSource(locator()));
  locator.registerLazySingleton(() => MediaRemoteDataSource(locator()));
  locator.registerLazySingleton(() => StatusRemoteDataSource(locator()));


  // Repositories
  locator.registerLazySingleton(() => ContactRepository(locator(), locator()));
  locator.registerLazySingleton(() => ChatRepository(locator(), locator()));
  locator.registerLazySingleton(() => StatusRepository(locator()));
}
