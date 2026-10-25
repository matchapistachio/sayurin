class ApiConstants {
  static const String baseUrl = 'https://api-mobile.dnccudinus.org';
  static const String vegetables = '/api/vegetables';
  static const String vegetableCategories = '/api/vegetables/categories';

  static String vegetableDetail(int id) => '/api/vegetables/$id';
}