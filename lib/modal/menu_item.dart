class VendorMenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final bool isVeg;
  final bool isAvailable;
  final String? imageUrl;

  /// Locally picked photo; takes precedence over [imageUrl] until upload exists.
  final String? localImagePath;

  const VendorMenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.isVeg,
    this.isAvailable = true,
    this.imageUrl,
    this.localImagePath,
  });

  VendorMenuItem copyWith({
    String? name,
    String? description,
    double? price,
    String? category,
    bool? isVeg,
    bool? isAvailable,
    String? imageUrl,
    String? localImagePath,
  }) {
    return VendorMenuItem(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      isVeg: isVeg ?? this.isVeg,
      isAvailable: isAvailable ?? this.isAvailable,
      imageUrl: imageUrl ?? this.imageUrl,
      localImagePath: localImagePath ?? this.localImagePath,
    );
  }
}
