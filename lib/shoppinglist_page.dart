import 'package:flutter/material.dart';
import 'package:sayurin/core/di/injection.dart';
import 'package:sayurin/models/vegetable.dart';
import 'package:sayurin/services/shoppinglist_service.dart';
import 'package:sayurin/ui/colors.dart';
import 'package:sayurin/ui/vegetable_list_item.dart';
import 'package:sayurin/ui/typography.dart';

class ShoppinglistPage extends StatefulWidget {
  const ShoppinglistPage({super.key});

  @override
  State<ShoppinglistPage> createState() => _ShoppinglistPageState();
}

class _ShoppinglistPageState extends State<ShoppinglistPage> {
  final ShoppinglistService _shoppinglistService = getIt<ShoppinglistService>();

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: const Color(0xFF2E3541),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF02A7FF).withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.bookmark_border_rounded,
                    color: blue,
                    size: 44,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "There Is No Movie Yet!",
                textAlign: TextAlign.center,
                style: smBold.copyWith(
                  color: white,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Find your movie by Type title,\ncategories, years, etc",
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
          "Shopping list",
          style: smBold.copyWith(color: white, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _shoppinglistService,
          builder: (context, _) {
            final List<Vegetable> vegetables = _shoppinglistService.shoppingList;

            if (vegetables.isEmpty) {
              return _buildEmptyState();
            }

            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              itemCount: vegetables.length,
              separatorBuilder: (context, index) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                final vegetable = vegetables[index];
                return Dismissible(
                  key: ValueKey("shoppinglist_${vegetable.id}"),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.delete_outline, color: white, size: 28),
                  ),
                  onDismissed: (_) {
                    _shoppinglistService.removeFromShoppinglist(vegetable.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("${vegetable.nama} dihapus dari Shopping list"),
                        duration: const Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: buttonGrey,
                      ),
                    );
                  },
                  child: VegetableListItem(vegetable: vegetable),
                );
              },
            );
          },
        ),
      ),
    );
  }
}