import 'package:flutter/material.dart';
import 'package:sayurin/detail_page.dart';
import 'package:sayurin/models/vegetable.dart';
import 'package:sayurin/ui/colors.dart';
import 'package:sayurin/ui/typography.dart';

class VegetableListItem extends StatelessWidget {
  final Vegetable vegetable;
  final VoidCallback? onTap;
  final Widget? trailing;

  const VegetableListItem({
    super.key,
    required this.vegetable,
    this.onTap,
    this.trailing,
  });

  Widget _buildPosterImage(String rawUrl) {
    if (rawUrl.isEmpty) {
      return Container(
        color: buttonGrey,
        child: const Center(
          child: Icon(Icons.movie, color: white, size: 32),
        ),
      );
    }

    if (rawUrl.startsWith('http://') || rawUrl.startsWith('https://')) {
      return Image.network(
        rawUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: buttonGrey,
            child: const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: blue),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => Container(
          color: buttonGrey,
          child: const Center(
            child: Icon(Icons.broken_image, color: white, size: 28),
          ),
        ),
      );
    }

    final assetPath = rawUrl.startsWith('assets/') ? rawUrl : 'assets/images/$rawUrl';
    return Image.asset(
      assetPath,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        color: buttonGrey,
        child: const Center(
          child: Icon(Icons.movie, color: white, size: 28),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailPage(vegetable: vegetable),
              ),
            );
          },
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              width: 95,
              height: 125,
              child: _buildPosterImage(vegetable.gambar),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vegetable.nama,
                  style: smBold.copyWith(
                    color: white,
                    fontSize: 16,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.sell_outlined,
                      color: Color(0xFFFF8700),
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      vegetable.harga.toString(),
                      style: sBold.copyWith(
                        color: const Color(0xFFFF8700),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(
                      Icons.confirmation_number_outlined,
                      color: white,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      vegetable.getPrimaryManfaat(),
                      style: xsRegular.copyWith(color: white),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      color: white,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      vegetable.kategori.toString(),
                      style: xsRegular.copyWith(color: white),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      color: white,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      vegetable.deskripsi,
                      style: xsRegular.copyWith(color: white),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}