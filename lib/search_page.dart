import 'package:flutter/material.dart';
import 'package:sayurin/core/di/injection.dart';
import 'package:sayurin/models/vegetable.dart';
import 'package:sayurin/services/vegetable_service.dart';
import 'package:sayurin/ui/colors.dart';
import 'package:sayurin/ui/vegetable_list_item.dart';
import 'package:sayurin/ui/typography.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final VegetableService _vegetableService = getIt<VegetableService>();
  final TextEditingController _searchController = TextEditingController();

  List<Vegetable> _allVegetables = [];
  List<Vegetable> _filteredVegetables = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchVegetables();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchVegetables() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final vegetables = await _vegetableService.getVegetables();
      if (mounted) {
        setState(() {
          _allVegetables = vegetables;
          _filteredVegetables = vegetables;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceAll("Exception: ", "");
          _isLoading = false;
        });
      }
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredVegetables = _allVegetables;
      } else {
        _filteredVegetables = _allVegetables.where((vegetable) {
          final matchesNama = vegetable.nama.toLowerCase().contains(query);
          final matchesKategori = vegetable.kategori.toString().contains(query);
          final matchesDeskripsi = vegetable.deskripsi.toString().contains(query);
          final matchesAsal = vegetable.asal.toLowerCase().contains(query);
          return matchesNama || matchesKategori || matchesDeskripsi || matchesAsal;
        }).toList();
      }
    });
  }

  void _showSearchInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "Search Information",
          style: smBold.copyWith(color: white),
        ),
        content: Text(
          "Anda dapat mencari sayuran berdasarkan:\n• Nama Sayuran\n• Kategori Sayuran\n• Deskripsi Sayuran\n• Asal Sayuran",
          style: sRegular.copyWith(color: grey, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Mengerti", style: sBold.copyWith(color: blue)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 14,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF02A7FF).withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.cloud_rounded, color: white, size: 14),
                      ),
                    ),
                    Positioned(
                      bottom: 26,
                      right: 14,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF02A7FF).withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.cloud_rounded, color: white, size: 12),
                      ),
                    ),
                    Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: white,
                        border: Border.all(
                          color: const Color(0xFFFF8700),
                          width: 5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.more_horiz_rounded,
                          color: background,
                          size: 32,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      left: 20,
                      child: Transform.rotate(
                        angle: -0.78,
                        child: Container(
                          width: 10,
                          height: 32,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF8700),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "We Are Sorry, We Can Not Find The Vegetable :(",
                textAlign: TextAlign.center,
                style: smBold.copyWith(
                  color: white,
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Find your vegetable by Type name,\ncategory, description, etc",
                textAlign: TextAlign.center,
                style: sRegular.copyWith(
                  color: grey,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: background,
        elevation: 0,
        title: Text(
          "Search",
          style: smBold.copyWith(color: white, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: white),
            onPressed: _showSearchInfo,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0EED1),
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: sMedium.copyWith(color: const Color.fromARGB(255, 9, 0, 0)),
                        cursorColor: blue,
                        decoration: InputDecoration(
                          hintText: "Search",
                          hintStyle: sRegular.copyWith(color: const Color.fromARGB(255, 0, 0, 0)),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    if (_searchController.text.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          _searchController.clear();
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6.0),
                          child: Icon(Icons.close_rounded, color: grey, size: 20),
                        ),
                      ),
                    const Icon(
                      Icons.search_rounded,
                      color: grey,
                      size: 22,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: _buildSearchResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: blue),
      );
    }

    if (_errorMessage != null && _allVegetables.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off_rounded, color: Colors.redAccent, size: 48),
              const SizedBox(height: 12),
              Text("Gagal memuat sayuran", style: smBold.copyWith(color: white)),
              const SizedBox(height: 6),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: sRegular.copyWith(color: grey),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _fetchVegetables,
                style: ElevatedButton.styleFrom(backgroundColor: blue),
                child: const Text("Coba Lagi", style: TextStyle(color: white)),
              ),
            ],
          ),
        ),
      );
    }

    if (_filteredVegetables.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      itemCount: _filteredVegetables.length,
      separatorBuilder: (context, index) => const SizedBox(height: 20),
      itemBuilder: (context, index) {
        final vegetable = _filteredVegetables[index];
        return VegetableListItem(vegetable: vegetable);
      },
    );
  }
}