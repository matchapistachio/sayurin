class Category {
  final String slug;
  final String nama;
  final int jumlah;

  Category({
    required this.slug,
    required this.nama,
    required this.jumlah,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      slug: '',
      nama: '',
      jumlah: 0,

    );
  }
}