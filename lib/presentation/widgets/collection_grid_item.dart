import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models/product.dart';
import '../../data/models/collection_item.dart';

class CollectionGridItem extends StatelessWidget {
  final CollectionItem item;
  final Product? product;
  final VoidCallback onTap;

  const CollectionGridItem({
    super.key,
    required this.item,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (product != null)
              Hero(
                tag: 'collection_image_${item.id}',
                child: CachedNetworkImage(
                  imageUrl: product!.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (context, url, error) => const Center(
                    child: Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
              )
            else
              Container(
                color: Colors.grey[300],
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image_not_supported, color: Colors.grey),
                    SizedBox(height: 4),
                    Text('No Image', style: TextStyle(fontSize: 10)),
                  ],
                ),
              ),
            // グラーデーションオーバーレイ（テキストが見やすいように）
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black54, Colors.transparent],
                  ),
                ),
                padding: const EdgeInsets.all(4),
                child: Text(
                  product?.name ?? '不明な商品',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
