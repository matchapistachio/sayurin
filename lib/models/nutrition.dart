class Nutrition {
  final String kalori;
  final String karbohidrat;
  final String protein;
  final String serat;

  Nutrition({
    required this.kalori,
    required this.karbohidrat,
    required this.protein,
    required this.serat,
  }); 
  
  factory Nutrition.fromJson(Map<String, dynamic> json) {
    return Nutrition(
      kalori: json['kalori']?.toString() ?? '',
      karbohidrat: json['karbohidrat']?.toString() ?? '',
      protein: json['protein']?.toString() ?? '',
      serat: json['serat']?.toString() ?? '',
    );
  }
  
} 
