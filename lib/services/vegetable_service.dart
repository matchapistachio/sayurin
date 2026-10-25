import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:sayurin/core/constants/api_constants.dart';
import 'package:sayurin/models/category.dart';
import 'package:sayurin/models/vegetable.dart';

class VegetableService {
  final Dio _dio;

  VegetableService(this._dio);

  Future<List<Vegetable>> getVegetables() async {
    try {
      final response = await _dio.get(ApiConstants.vegetables);

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['data'] is List) {
          final List listData = data['data'];
          return listData
              .map((item) => Vegetable.fromJson(item as Map<String, dynamic>))
              .toList();
        }
      }
      return [];
    } on DioException catch (e) {
      debugPrint("Dio error saat getMovies: ${e.message}");
      throw _handleDioError(e);
    } catch (e) {
      debugPrint("Error umum saat getMovies: $e");
      throw Exception("Gagal memuat sayuran: Terjadi kesalahan sistem.");
    }
  }
  
  Future<List<Category>> getCategories() async {
    try {
      final response = await _dio.get(ApiConstants.vegetableCategories);

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['data'] is List) {
          final List listData = data['data'];
          return listData
              .map((item) => Category.fromJson(item as Map<String, dynamic>))
              .toList();
        }
      }
      return [];
    } on DioException catch (e) {
      debugPrint("Dio error saat getMovies: ${e.message}");
      throw _handleDioError(e);
    } catch (e) {
      debugPrint("Error umum saat getMovies: $e");
      throw Exception("Gagal memuat sayuran: Terjadi kesalahan sistem.");
    }
  }


  Future<Vegetable> getVegetableDetail(int id) async {
    try {
      final response = await _dio.get(ApiConstants.vegetableDetail(id));

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['data'] != null) {
          return Vegetable.fromJson(data['data'] as Map<String, dynamic>);
        }
      }
      throw Exception("Data sayuran dengan ID $id tidak ditemukan.");
    } on DioException catch (e) {
      debugPrint("Dio error saat getMovieDetail: ${e.message}");
      throw _handleDioError(e);
    } catch (e) {
      debugPrint("Error umum saat getMovieDetail: $e");
      throw Exception("Gagal memuat detail sayuran.");
    }
  }

  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception("Koneksi internet lambat / time out. Silakan coba lagi.");
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        return Exception("Server mengalami kendala (Kode error: $statusCode).");
      case DioExceptionType.connectionError:
        return Exception("Tidak dapat terhubung ke internet. Periksa koneksi Anda.");
      default:
        return Exception("Terjadi gangguan jaringan: ${error.message ?? 'Coba lagi nanti.'}");
    }
  }
}