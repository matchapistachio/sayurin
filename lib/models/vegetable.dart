import 'package:sayurin/models/nutrition.dart';

class Vegetable{
  final int id;
  final String nama;
  final String kategori;
  final int harga;
  final String gambar;
  final String deskripsi;
  final List<String> manfaat;
  final String tipsPenyimpanan;
  final String asal;
  final List<Nutrition> nutrisi;

  Vegetable({
    required this.id,
    required this.nama,
    required this.kategori,
    required this.harga,
    required this.gambar,
    required this.deskripsi,
    required this.tipsPenyimpanan,
    required this.asal,
    this.manfaat = const [],
    this.nutrisi = const [],
  });

  factory Vegetable.fromJson(Map<String, dynamic> json) {
    List<String> parsedManfaat = [];
    if (json['manfaat'] is List) {
      parsedManfaat = (json['manfaat'] as List)
          .map((item) => item.toString())
          .toList();
    }

    List<Nutrition> parsedNutrisi = [];
    if (json['nutrisi'] is List) {
      parsedNutrisi = (json['nutrisi'] as List)
          .map((item) => Nutrition.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return Vegetable(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      nama: json['nama']?.toString() ?? '',
      kategori: json['kategori']?.toString() ?? '',
      harga: json['harga'] is int
          ? json['harga'] as int
          : int.tryParse(json['harga']?.toString() ?? '0') ?? 0,
      gambar: json['gambar']?.toString() ?? '',
      deskripsi: json['deskripsi']?.toString() ?? '',
      tipsPenyimpanan: json['tipsPenyimpanan']?.toString() ?? '',
      asal: json['asal']?.toString() ?? '',
      manfaat: parsedManfaat,
      nutrisi: parsedNutrisi,
    );
  }

  Vegetable copyWith({
    int? id,
    String? nama,
    String? kategori,
    int? harga,
    String? gambar,
    String? deskripsi,
    String? tipsPenyimpanan,
    String? asal,
    List<String>? manfaat,
    List<Nutrition>? nutrisi,
  }) {
    return Vegetable(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      kategori: kategori ?? this.kategori,
      harga: harga ?? this.harga,
      gambar: gambar ?? this.gambar,
      deskripsi: deskripsi ?? this.deskripsi,
      tipsPenyimpanan: tipsPenyimpanan ?? this.tipsPenyimpanan,
      asal: asal ?? this.asal,
      manfaat: manfaat ?? this.manfaat,
      nutrisi: nutrisi ?? this.nutrisi,
    );
  }

  String getPrimaryManfaat() {
    if (manfaat.isNotEmpty) {
      return manfaat.first;
    }
    return 'Menyehatkan';
  }
}