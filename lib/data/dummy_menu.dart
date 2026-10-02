import 'package:flutter/material.dart';

import '../modal/menu_item.dart';

class DummyMenu {
  DummyMenu._();

  static const List<String> categories = [
    'Starters',
    'Main Course',
    'Snacks',
    'Beverages',
  ];

  static const Map<String, IconData> categoryIcons = {
    'Starters': Icons.tapas_rounded,
    'Main Course': Icons.dinner_dining_rounded,
    'Snacks': Icons.fastfood_rounded,
    'Beverages': Icons.local_cafe_rounded,
  };

  static List<VendorMenuItem> items() => const [
        VendorMenuItem(
          id: 'm1',
          name: 'Hara Bhara Kebab',
          description: 'Spinach & green pea patties, pan-seared, served with mint chutney.',
          price: 110,
          category: 'Starters',
          isVeg: true,
          imageUrl:
              'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=400&q=80',
        ),
        VendorMenuItem(
          id: 'm2',
          name: 'Chicken Tikka',
          description: 'Tandoor-grilled boneless chicken marinated in yoghurt & spices.',
          price: 180,
          category: 'Starters',
          isVeg: false,
          imageUrl:
              'https://images.unsplash.com/photo-1599487488170-d11ec9c172f0?w=400&q=80',
        ),
        VendorMenuItem(
          id: 'm3',
          name: 'Chilli Paneer Dry',
          description: 'Crispy paneer tossed with peppers, onions and soy-chilli glaze.',
          price: 150,
          category: 'Starters',
          isVeg: true,
          isAvailable: false,
          imageUrl:
              'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=400&q=80',
        ),
        VendorMenuItem(
          id: 'm4',
          name: 'Veg Thali',
          description: 'Dal, two sabzis, jeera rice, 3 rotis, salad and sweet of the day.',
          price: 120,
          category: 'Main Course',
          isVeg: true,
          imageUrl:
              'https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=400&q=80',
        ),
        VendorMenuItem(
          id: 'm5',
          name: 'Paneer Butter Masala',
          description: 'Cottage cheese in a rich tomato-butter gravy. Pairs with naan.',
          price: 160,
          category: 'Main Course',
          isVeg: true,
          imageUrl:
              'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?w=400&q=80',
        ),
        VendorMenuItem(
          id: 'm6',
          name: 'Chicken Dum Biryani',
          description: 'Slow-cooked basmati with spiced chicken, served with raita.',
          price: 190,
          category: 'Main Course',
          isVeg: false,
          imageUrl:
              'https://images.unsplash.com/photo-1589302168068-964664d93dc0?w=400&q=80',
        ),
        VendorMenuItem(
          id: 'm7',
          name: 'Masala Dosa',
          description: 'Crispy rice crêpe with potato masala, sambar & coconut chutney.',
          price: 80,
          category: 'Main Course',
          isVeg: true,
          imageUrl:
              'https://images.unsplash.com/photo-1668236543090-82eba5ee5976?w=400&q=80',
        ),
        VendorMenuItem(
          id: 'm8',
          name: 'Veg Hakka Noodles',
          description: 'Wok-tossed noodles with crunchy vegetables.',
          price: 100,
          category: 'Main Course',
          isVeg: true,
          isAvailable: false,
          imageUrl:
              'https://images.unsplash.com/photo-1612929633739-465d7f0e0e0e?w=400&q=80',
        ),
        VendorMenuItem(
          id: 'm9',
          name: 'Samosa (2 pcs)',
          description: 'Classic potato-pea samosas with tamarind chutney.',
          price: 30,
          category: 'Snacks',
          isVeg: true,
          imageUrl:
              'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=400&q=80',
        ),
        VendorMenuItem(
          id: 'm10',
          name: 'Peri Peri Fries',
          description: 'Crispy fries dusted with peri peri seasoning.',
          price: 90,
          category: 'Snacks',
          isVeg: true,
          imageUrl:
              'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=400&q=80',
        ),
        VendorMenuItem(
          id: 'm11',
          name: 'Veg Club Sandwich',
          description: 'Triple-decker with veggies, cheese and house mayo.',
          price: 110,
          category: 'Snacks',
          isVeg: true,
          imageUrl:
              'https://images.unsplash.com/photo-1528735602780-2552fd46c7af?w=400&q=80',
        ),
        VendorMenuItem(
          id: 'm12',
          name: 'Chicken 65',
          description: 'Spicy deep-fried chicken bites, South Indian style.',
          price: 150,
          category: 'Snacks',
          isVeg: false,
          imageUrl:
              'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?w=400&q=80',
        ),
        VendorMenuItem(
          id: 'm13',
          name: 'Filter Coffee',
          description: 'Strong South Indian decoction with frothy milk.',
          price: 30,
          category: 'Beverages',
          isVeg: true,
          imageUrl:
              'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=400&q=80',
        ),
        VendorMenuItem(
          id: 'm14',
          name: 'Masala Chaas',
          description: 'Spiced buttermilk with roasted cumin and coriander.',
          price: 35,
          category: 'Beverages',
          isVeg: true,
          imageUrl:
              'https://images.unsplash.com/photo-1623065422902-30a2d94beca8?w=400&q=80',
        ),
        VendorMenuItem(
          id: 'm15',
          name: 'Cold Coffee',
          description: 'Chilled blended coffee with a scoop of vanilla ice cream.',
          price: 80,
          category: 'Beverages',
          isVeg: true,
          imageUrl:
              'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=400&q=80',
        ),
        VendorMenuItem(
          id: 'm16',
          name: 'Lemon Iced Tea',
          description: 'Fresh brewed tea with lemon and mint over ice.',
          price: 60,
          category: 'Beverages',
          isVeg: true,
          isAvailable: false,
          imageUrl:
              'https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=400&q=80',
        ),
      ];
}
