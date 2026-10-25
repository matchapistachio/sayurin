import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:sayurin/core/network/dio_client.dart';
import 'package:sayurin/services/vegetable_service.dart';
import 'package:sayurin/services/shoppinglist_service.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<Dio>(() => DioClient.createDio());
  getIt.registerLazySingleton<VegetableService>(() => VegetableService(getIt<Dio>()));
  getIt.registerLazySingleton<ShoppinglistService>(() => ShoppinglistService());
}