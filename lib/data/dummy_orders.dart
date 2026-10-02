import '../modal/pickup_point.dart';
import '../modal/vendor_order.dart';

/// Today's mock order book, timestamped relative to app launch so "x min ago"
/// labels look realistic. Covers every status so all tabs can be reviewed.
class DummyOrders {
  DummyOrders._();

  static List<VendorOrder> today() {
    final now = DateTime.now();
    DateTime ago(int mins) => now.subtract(Duration(minutes: mins));

    return [
      // ── New ──────────────────────────────────────────────
      VendorOrder(
        id: 'MC-10492',
        customerFirstName: 'Aarav',
        customerLastName: 'Sharma',
        pickupPoint: PickupPoint.mainGate,
        status: OrderStatus.newOrder,
        placedAt: ago(2),
        note: 'Less spicy please, no onions in the biryani.',
        items: const [
          OrderItem(name: 'Chicken Dum Biryani', quantity: 1, unitPrice: 190, isVeg: false),
          OrderItem(name: 'Masala Chaas', quantity: 2, unitPrice: 35, isVeg: true),
        ],
      ),
      VendorOrder(
        id: 'MC-10491',
        customerFirstName: 'Diya',
        customerLastName: 'Menon',
        pickupPoint: PickupPoint.hostelGate,
        status: OrderStatus.newOrder,
        placedAt: ago(4),
        items: const [
          OrderItem(name: 'Masala Dosa', quantity: 2, unitPrice: 80, isVeg: true),
          OrderItem(name: 'Filter Coffee', quantity: 2, unitPrice: 30, isVeg: true),
        ],
      ),
      VendorOrder(
        id: 'MC-10490',
        customerFirstName: 'Kabir',
        customerLastName: 'Verma',
        pickupPoint: PickupPoint.mainGate,
        status: OrderStatus.newOrder,
        placedAt: ago(7),
        note: 'Please pack the fries separately.',
        items: const [
          OrderItem(name: 'Veg Club Sandwich', quantity: 1, unitPrice: 110, isVeg: true),
          OrderItem(name: 'Peri Peri Fries', quantity: 1, unitPrice: 90, isVeg: true),
          OrderItem(name: 'Cold Coffee', quantity: 1, unitPrice: 80, isVeg: true),
        ],
      ),
      VendorOrder(
        id: 'MC-10489',
        customerFirstName: 'Sneha',
        customerLastName: 'Iyer',
        pickupPoint: PickupPoint.hostelGate,
        status: OrderStatus.newOrder,
        placedAt: ago(11),
        items: const [
          OrderItem(name: 'Veg Thali', quantity: 1, unitPrice: 120, isVeg: true),
        ],
      ),

      // ── Accepted / Preparing ────────────────────────────
      VendorOrder(
        id: 'MC-10488',
        customerFirstName: 'Rohan',
        customerLastName: 'Gupta',
        pickupPoint: PickupPoint.mainGate,
        status: OrderStatus.accepted,
        placedAt: ago(14),
        acceptedAt: ago(12),
        items: const [
          OrderItem(name: 'Paneer Butter Masala', quantity: 1, unitPrice: 160, isVeg: true),
          OrderItem(name: 'Veg Thali', quantity: 1, unitPrice: 120, isVeg: true),
        ],
      ),
      VendorOrder(
        id: 'MC-10487',
        customerFirstName: 'Ananya',
        customerLastName: 'Reddy',
        pickupPoint: PickupPoint.hostelGate,
        status: OrderStatus.preparing,
        placedAt: ago(19),
        acceptedAt: ago(18),
        preparingAt: ago(15),
        note: 'Extra chutney if possible 🙏',
        items: const [
          OrderItem(name: 'Hara Bhara Kebab', quantity: 2, unitPrice: 110, isVeg: true),
          OrderItem(name: 'Samosa (2 pcs)', quantity: 2, unitPrice: 30, isVeg: true),
        ],
      ),
      VendorOrder(
        id: 'MC-10486',
        customerFirstName: 'Vikram',
        customerLastName: 'Singh',
        pickupPoint: PickupPoint.mainGate,
        status: OrderStatus.preparing,
        placedAt: ago(24),
        acceptedAt: ago(23),
        preparingAt: ago(20),
        items: const [
          OrderItem(name: 'Chicken Tikka', quantity: 1, unitPrice: 180, isVeg: false),
          OrderItem(name: 'Chicken 65', quantity: 1, unitPrice: 150, isVeg: false),
          OrderItem(name: 'Cold Coffee', quantity: 2, unitPrice: 80, isVeg: true),
        ],
      ),
      VendorOrder(
        id: 'MC-10485',
        customerFirstName: 'Meera',
        customerLastName: 'Nair',
        pickupPoint: PickupPoint.hostelGate,
        status: OrderStatus.preparing,
        placedAt: ago(28),
        acceptedAt: ago(27),
        preparingAt: ago(25),
        items: const [
          OrderItem(name: 'Masala Dosa', quantity: 1, unitPrice: 80, isVeg: true),
        ],
      ),

      // ── Ready for pickup ────────────────────────────────
      VendorOrder(
        id: 'MC-10484',
        customerFirstName: 'Arjun',
        customerLastName: 'Patel',
        pickupPoint: PickupPoint.mainGate,
        status: OrderStatus.ready,
        placedAt: ago(36),
        acceptedAt: ago(35),
        preparingAt: ago(32),
        readyAt: ago(18),
        items: const [
          OrderItem(name: 'Chicken Dum Biryani', quantity: 2, unitPrice: 190, isVeg: false),
        ],
      ),
      VendorOrder(
        id: 'MC-10483',
        customerFirstName: 'Ishita',
        customerLastName: 'Bose',
        pickupPoint: PickupPoint.hostelGate,
        status: OrderStatus.ready,
        placedAt: ago(41),
        acceptedAt: ago(40),
        preparingAt: ago(37),
        readyAt: ago(22),
        note: 'Will pick up after my 4 PM class.',
        items: const [
          OrderItem(name: 'Veg Club Sandwich', quantity: 1, unitPrice: 110, isVeg: true),
          OrderItem(name: 'Lemon Iced Tea', quantity: 1, unitPrice: 60, isVeg: true),
        ],
      ),
      VendorOrder(
        id: 'MC-10482',
        customerFirstName: 'Nikhil',
        customerLastName: 'Joshi',
        pickupPoint: PickupPoint.mainGate,
        status: OrderStatus.ready,
        placedAt: ago(47),
        acceptedAt: ago(46),
        preparingAt: ago(43),
        readyAt: ago(30),
        items: const [
          OrderItem(name: 'Samosa (2 pcs)', quantity: 3, unitPrice: 30, isVeg: true),
          OrderItem(name: 'Filter Coffee', quantity: 3, unitPrice: 30, isVeg: true),
        ],
      ),

      // ── Completed ───────────────────────────────────────
      _completed('MC-10481', 'Priya', 'Kapoor', PickupPoint.hostelGate, now, 62, const [
        OrderItem(name: 'Paneer Butter Masala', quantity: 1, unitPrice: 160, isVeg: true),
        OrderItem(name: 'Masala Chaas', quantity: 1, unitPrice: 35, isVeg: true),
      ]),
      _completed('MC-10479', 'Aditya', 'Rao', PickupPoint.mainGate, now, 85, const [
        OrderItem(name: 'Chicken Dum Biryani', quantity: 1, unitPrice: 190, isVeg: false),
        OrderItem(name: 'Cold Coffee', quantity: 1, unitPrice: 80, isVeg: true),
      ]),
      _completed('MC-10478', 'Tanvi', 'Desai', PickupPoint.mainGate, now, 104, const [
        OrderItem(name: 'Veg Thali', quantity: 2, unitPrice: 120, isVeg: true),
      ]),
      _completed('MC-10476', 'Rahul', 'Mishra', PickupPoint.hostelGate, now, 131, const [
        OrderItem(name: 'Chicken Tikka', quantity: 1, unitPrice: 180, isVeg: false),
        OrderItem(name: 'Peri Peri Fries', quantity: 1, unitPrice: 90, isVeg: true),
      ]),
      _completed('MC-10475', 'Kavya', 'Pillai', PickupPoint.mainGate, now, 158, const [
        OrderItem(name: 'Masala Dosa', quantity: 2, unitPrice: 80, isVeg: true),
        OrderItem(name: 'Filter Coffee', quantity: 1, unitPrice: 30, isVeg: true),
      ]),
      _completed('MC-10473', 'Siddharth', 'Kulkarni', PickupPoint.hostelGate, now, 186, const [
        OrderItem(name: 'Veg Club Sandwich', quantity: 2, unitPrice: 110, isVeg: true),
        OrderItem(name: 'Cold Coffee', quantity: 2, unitPrice: 80, isVeg: true),
      ]),
      _completed('MC-10472', 'Pooja', 'Chauhan', PickupPoint.mainGate, now, 214, const [
        OrderItem(name: 'Samosa (2 pcs)', quantity: 2, unitPrice: 30, isVeg: true),
        OrderItem(name: 'Masala Chaas', quantity: 2, unitPrice: 35, isVeg: true),
      ]),

      // ── Cancelled ───────────────────────────────────────
      VendorOrder(
        id: 'MC-10480',
        customerFirstName: 'Harsh',
        customerLastName: 'Agarwal',
        pickupPoint: PickupPoint.mainGate,
        status: OrderStatus.cancelled,
        placedAt: ago(75),
        cancelledAt: ago(73),
        cancelReason: 'Out of stock',
        items: const [
          OrderItem(name: 'Chilli Paneer Dry', quantity: 1, unitPrice: 150, isVeg: true),
        ],
      ),
      VendorOrder(
        id: 'MC-10477',
        customerFirstName: 'Riya',
        customerLastName: 'Saxena',
        pickupPoint: PickupPoint.hostelGate,
        status: OrderStatus.cancelled,
        placedAt: ago(120),
        cancelledAt: ago(118),
        cancelReason: 'Cancelled by customer',
        cancelledByCustomer: true,
        items: const [
          OrderItem(name: 'Veg Hakka Noodles', quantity: 1, unitPrice: 100, isVeg: true),
          OrderItem(name: 'Lemon Iced Tea', quantity: 1, unitPrice: 60, isVeg: true),
        ],
      ),
      VendorOrder(
        id: 'MC-10474',
        customerFirstName: 'Yash',
        customerLastName: 'Thakur',
        pickupPoint: PickupPoint.mainGate,
        status: OrderStatus.cancelled,
        placedAt: ago(170),
        cancelledAt: ago(168),
        cancelReason: 'Too busy',
        items: const [
          OrderItem(name: 'Chicken 65', quantity: 2, unitPrice: 150, isVeg: false),
        ],
      ),
    ];
  }

  static VendorOrder _completed(
    String id,
    String first,
    String last,
    PickupPoint pickup,
    DateTime now,
    int placedMinsAgo,
    List<OrderItem> items,
  ) {
    DateTime at(int offset) =>
        now.subtract(Duration(minutes: placedMinsAgo - offset));
    return VendorOrder(
      id: id,
      customerFirstName: first,
      customerLastName: last,
      pickupPoint: pickup,
      status: OrderStatus.completed,
      placedAt: at(0),
      acceptedAt: at(1),
      preparingAt: at(3),
      readyAt: at(16),
      completedAt: at(24),
      items: items,
    );
  }
}
