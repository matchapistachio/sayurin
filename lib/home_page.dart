import 'package:flutter/material.dart';
import 'package:sayurin/core/di/injection.dart';
import 'package:sayurin/detail_page.dart';
import 'package:sayurin/models/category.dart';
import 'package:sayurin/models/vegetable.dart';
import 'package:sayurin/search_page.dart';
import 'package:sayurin/services/vegetable_service.dart';
import 'package:sayurin/services/shoppinglist_service.dart';
import 'package:sayurin/ui/colors.dart';
import 'package:sayurin/ui/typography.dart';
import 'package:sayurin/shoppinglist_page.dart';

typedef homePage = HomePage;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final VegetableService _vegetableService = getIt<VegetableService>();
  final ShoppinglistService _shoppinglistService = getIt<ShoppinglistService>();

  int _currentIndex = 0;

  List<Vegetable> _vegetables = [];
  List<Category> _categories = [];
  bool _isLoading = true;
  String? _errorMessage;

  int _selectedCategoryIndex = 0;

  List<String> get _categoryTabs {
    final defaultTabs = ["Sayuran Daun", "Sayuran Buah", "Sayuran Umbi", "Sayuran Polong"];
      return defaultTabs;
  }

  @override
  void initState() {
    super.initState();
    _fetchVegetables();
  }

  Future<void> _fetchVegetables() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final results = await Future.wait([
        _vegetableService.getVegetables(),
        _vegetableService.getCategories(),
      ]);
      final loadedVegetables = results[0] as List<Vegetable>;
      final loadedCategories = results[1] as List<Category>;

      _shoppinglistService.seedInitialVegetables(loadedVegetables);

      if (mounted) {
        setState(() {
          _vegetables = loadedVegetables;
          _categories = loadedCategories;
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

  Widget _buildPosterImage(String rawUrl, {BoxFit fit = BoxFit.cover}) {
    if (rawUrl.isEmpty) {
      return Container(
        color: buttonGrey,
        child: const Center(
          child: Icon(Icons.payment, color: white, size: 36),
        ),
      );
    }

    if (rawUrl.startsWith('http://') || rawUrl.startsWith('https://')) {
      return Image.network(
        rawUrl,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: buttonGrey,
            child: const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2, color: blue),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => Container(
          color: buttonGrey,
          child: const Center(
            child: Icon(Icons.broken_image, color: white, size: 36),
          ),
        ),
      );
    }

    final assetPath = rawUrl.startsWith('assets/') ? rawUrl : 'assets/images/$rawUrl';
    return Image.asset(
      assetPath,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => Container(
        color: buttonGrey,
        child: const Center(
          child: Icon(Icons.payment, color: white, size: 36),
        ),
      ),
    );
  }

  void _navigateToDetail(BuildContext context, Vegetable vegetable) {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailPage(vegetable: vegetable),
        ),
      );
    } catch (e) {
      debugPrint("Gagal navigasi ke detail page: $e");
    }
  }

  List<Vegetable> _getFilteredCategoryVegetables() {
    if (_vegetables.isEmpty) return [];

    final tabs = _categoryTabs;
    if (_selectedCategoryIndex < 0 || _selectedCategoryIndex >= tabs.length) {
      return _vegetables;
    }

    final selected = tabs[_selectedCategoryIndex];

    switch (selected) {
      case "Sayuran Buah":
      case "Sayuran Daun":
      case "Sayuran Umbi":
      case "Sayuran Polong":
        return _vegetables
            .where((vegetable) => vegetable.kategori == selected)
            .toList();

      default:
        return _vegetables;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeView(),
          const SearchPage(),
          const ShoppinglistPage(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: background,
          border: Border(
            top: BorderSide(
              color: blue.withValues(alpha: 0.25),
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: background,
          selectedItemColor: blue,
          unselectedItemColor: const Color(0xFF67686D),
          selectedLabelStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_rounded),
              activeIcon: Icon(Icons.search_rounded),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              activeIcon: Icon(Icons.shopping_cart_rounded),
              label: 'Shopping list',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeView() {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;

    final int crossAxisCount = screenWidth > 900
        ? 5
        : screenWidth > 600
            ? 4
            : screenWidth > 380
                ? 3
                : 2;

    final affordableVegetables = _vegetables.where((m) => m.harga <= 5000).toList();
    final categoryVegetables = _getFilteredCategoryVegetables();

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: background,
        elevation: 0,
        title: Text(
          "What do you want to buy?",
          style: mBold.copyWith(color: white),
        ),
      ),
      body: _buildBody(crossAxisCount, affordableVegetables, categoryVegetables),
    );
  }

  Widget _buildBody(int crossAxisCount, List<Vegetable> affordableVegetables, List<Vegetable> categoryVegetables) {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: blue),
            const SizedBox(height: 16),
            Text(
              "Memuat sayuran dari server...",
              style: sMedium.copyWith(color: grey),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null && _vegetables.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off_rounded, color: Colors.redAccent, size: 64),
              const SizedBox(height: 16),
              Text(
                "Gagal Memuat Data",
                style: mBold.copyWith(color: white),
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: sRegular.copyWith(color: grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _fetchVegetables,
                icon: const Icon(Icons.refresh, color: white),
                label: const Text("Coba Lagi", style: TextStyle(color: white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: blue,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final tabs = _categoryTabs;

    return RefreshIndicator(
      color: blue,
      backgroundColor: buttonGrey,
      onRefresh: _fetchVegetables,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _currentIndex = 1;
                  });
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  height: 48,
                  margin: const EdgeInsets.only(bottom: 24),
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0EED1),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Search",
                          style: sRegular.copyWith(color: const Color.fromARGB(255, 0, 0, 0)),
                        ),
                      ),
                      const Icon(
                        Icons.search_rounded,
                        color: Color(0xFF92929D),
                        size: 22,
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                "Affordable Vegetables",
                style: smBold.copyWith(color: white),
              ),
              const SizedBox(height: 8),
              Container(
                height: 4,
                width: 64,
                decoration: BoxDecoration(
                  color: blue,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 220,
                child: affordableVegetables.isEmpty
                    ? Center(
                        child: Text("Tidak ada sayuran terjangkau", style: sRegular.copyWith(color: grey)),
                      )
                    : ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: affordableVegetables.length,
                        separatorBuilder: (context, index) => const SizedBox(width: 14),
                        itemBuilder: (context, index) {
                          final vegetable = affordableVegetables[index];
                          return GestureDetector(
                            onTap: () => _navigateToDetail(context, vegetable),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: AspectRatio(
                                    aspectRatio: 2 / 3,
                                    child: _buildPosterImage(vegetable.gambar),
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(alpha: 0.75),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.payment, color: Colors.amber, size: 14),
                                        const SizedBox(width: 4),
                                        Text(
                                          vegetable.harga.toString(),
                                          style: xsBold.copyWith(color: Colors.amber),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 6,
                                  left: 8,
                                  child: Text(
                                    "${index + 1}",
                                    style: TextStyle(
                                      fontSize: 44,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: "Poppins",
                                      color: white.withValues(alpha: 0.85),
                                      shadows: const [
                                        Shadow(
                                          blurRadius: 8,
                                          color: Colors.black,
                                          offset: Offset(2, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 28),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(tabs.length, (index) {
                    return Padding(
                      padding: EdgeInsets.only(right: index == tabs.length - 1 ? 0 : 20),
                      child: _buildCategoryTab(tabs[index], index),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 18),
              categoryVegetables.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Center(
                        child: Text(
                          "Belum ada sayuran di kategori ini",
                          style: sRegular.copyWith(color: grey),
                        ),
                      ),
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: categoryVegetables.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.58,
                      ),
                      itemBuilder: (context, index) {
                        final vegetable = categoryVegetables[index];
                        return GestureDetector(
                          onTap: () => _navigateToDetail(context, vegetable),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: AspectRatio(
                                      aspectRatio: 2 / 3,
                                      child: _buildPosterImage(vegetable.gambar),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 6,
                                    right: 6,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(alpha: 0.75),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.payment, color: Colors.amber, size: 12),
                                          const SizedBox(width: 2),
                                          Text(
                                            vegetable.harga.toString(),
                                            style: xxsBold.copyWith(color: Colors.amber),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Expanded(
                                child: Text(
                                  vegetable.nama,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: xsMedium.copyWith(color: white),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTab(String title, int index) {
    final bool isSelected = _selectedCategoryIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategoryIndex = index;
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: smMedium.copyWith(
              color: isSelected ? white : grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: 4,
            width: isSelected ? 32 : 0,
            decoration: BoxDecoration(
              color: isSelected ? blue : Colors.transparent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}