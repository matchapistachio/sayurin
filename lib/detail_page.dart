import 'package:flutter/material.dart';
import 'package:sayurin/models/vegetable.dart';

class DetailPage extends StatefulWidget {
  final Vegetable vegetable;

  const DetailPage({super.key, required this.vegetable});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int _selectedTabIndex = 0;

  String _getAssetPath(String raw) {
    if (raw.isEmpty) return 'assets/images/vegetables.png';
    if (raw.startsWith('assets/')) return 'assets/images/$raw';
    return raw;
  }

  @override
  Widget build(BuildContext context) {
    final vegetable = widget.vegetable;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 4, 49, 15),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Detail",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: "Poppins",
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 250,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 180,
                  child: Image.network(
                    _getAssetPath(vegetable.gambar),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[800],
                      child: const Icon(Icons.eco_outlined, color: Colors.white, size: 50),
                    ),
                  ),
                ),
                Positioned(
                  top: 135,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF252836).withOpacity(0.85),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.payments_rounded, color: Colors.orange, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          vegetable.harga.toString(),
                          style: const TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 90,
                  left: 24,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      _getAssetPath(vegetable.gambar),
                      width: 100,
                      height: 140,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 100,
                        height: 140,
                        color: Colors.grey[700],
                        child: const Icon(Icons.image_not_supported, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 190,
                  left: 140,
                  right: 24,
                  child: Text(
                    vegetable.nama,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(Icons.calendar_today_outlined, color: Colors.grey, size: 16),
                const SizedBox(width: 6),
                Text(
                  "${vegetable.kategori}",
                  style: const TextStyle(color: Colors.grey, fontFamily: "Poppins", fontSize: 13),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text("|", style: TextStyle(color: Colors.grey)),
                ),
                const Icon(Icons.confirmation_number_outlined, color: Colors.grey, size: 16),
                const SizedBox(width: 6),
                Text(
                  vegetable.getPrimaryManfaat(),
                  style: const TextStyle(color: Colors.grey, fontFamily: "Poppins", fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                _buildTabItem("About Vegetable", 0),
                const SizedBox(width: 24),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _selectedTabIndex == 0
                ? _buildAboutTab(vegetable)
                : _buildNutritionsTab(vegetable),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title, int index) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 15,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.white : Colors.grey,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: 4,
            width: index == 0 ? 90 : 60,
            decoration: BoxDecoration(
              color: isSelected ? Colors.grey[600] : Colors.transparent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutTab(Vegetable vegetable) {
    return Text(
      vegetable.deskripsi,
      style: const TextStyle(
        fontFamily: "Poppins",
        color: Colors.white70,
        fontSize: 14,
        height: 1.6,
      ),
    );
  }

  Widget _buildNutritionsTab(Vegetable vegetable) {
    if (vegetable.nutrisi.isEmpty) {
      return const Text(
        "Tidak ditemukan nutrisi untuk sayuran ini.",
        style: TextStyle(color: Colors.grey, fontFamily: "Poppins"),
      );
    }

    return Column(
      children: vegetable.nutrisi.map((nutrisi) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.purple.shade300,
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    nutrisi.kalori.toString(),
                    style: const TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nutrisi.karbohidrat,
                      style: const TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      nutrisi.protein,
                      style: const TextStyle(
                        fontFamily: "Poppins",
                        color: Colors.white70,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}