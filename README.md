# MiCampus Vendor

Flutter app for campus food / canteen vendors to manage their **shop**, **menu**
and **incoming orders** from the MiCampus Food Ordering module.

> **Status: Phase 1 — UI only.** Every screen runs on dummy data held in
> in-memory GetX controllers. There are **no API calls and no persistence**;
> all state resets when the app restarts (or on logout). Backend wiring comes
> after these screens are reviewed and approved.

---

## Quick start

```bash
flutter pub get
flutter run            # pick an Android emulator / device
```

- **Flutter:** 3.32.x · **Dart:** 3.8.x
- **Platforms:** Android, iOS
- **Checks:** `flutter analyze` · `flutter test`

### Login (mock)

There are no credentials — **any input (even empty fields) logs you in**.
The dashboard loads the dummy vendor from `lib/data/dummy_vendor.dart`:

| Field | Value |
|-------|-------|
| Shop  | Annapurna Canteen (Canteen, approved) |
| Owner | Ramesh Kumar |
| Phone | +91 98765 43210 |
| Email | annapurna.canteen@micampus.in |

Logging out and back in resets all orders, menu edits and the open/closed
toggle to their dummy defaults.

---

## Screens

| # | Screen | Highlights |
|---|--------|-----------|
| 1 | **Splash** | Branded gradient, auto-navigates to Login after ~2 s. |
| 1 | **Login** | Phone/email + password using the main app's auth style (gradient scaffold, auth card, text fields, primary button). Mock success. "Register your shop" link opens onboarding. |
| 2 | **Onboarding (4 steps)** | Shop & owner details → category + shop photo → pickup points (multi-select) → operating hours + review. Per-step validation. |
| 2 | **Pending approval** | "Registration submitted — pending admin approval" state with a Submitted → Admin review → Go live tracker. |
| 3 | **Dashboard** | Prominent Shop Open/Closed toggle, today's summary cards (New, In Progress, Completed Today, Today's Earnings — tap to deep-link), recent active orders with **View All**. |
| 4 | **Orders** | Tabs: New · Preparing · Ready for Pickup · Completed · Cancelled (with live counts). Cards show order ID, customer (first name + last initial), items, total, placed time, pickup point and the status action. |
| 5 | **Order detail** | Item list with qty / unit price / line total, special instructions, order total, pickup point, placed time, status timeline with timestamps, status action + Reject (reason picker). |
| 6 | **Menu** | Items grouped by category with photo, name, price, veg/non-veg mark and an Available toggle. **+** FAB to add; tap / ⋮ menu to edit or delete; swipe left to delete (with confirm + Undo). |
| 6 | **Add / Edit item** | Photo, name, description, price, category picker, Veg/Non-veg, Available toggle. |
| 7 | **Earnings** | Today / This Week / This Month, 7-day bar chart (tap a bar for details), payout history (Paid / Pending). |
| 8 | **Profile** | Shop info, approval badge, Edit shop info, Notifications, Logout. |
| 8 | **Edit shop info** | Name, photo, category, pickup points, operating hours (same fields as onboarding). |
| 8 | **Notifications** | Dummy order alerts, cancellations, payouts, approval updates. Unread badge on the bell (Dashboard / Orders). Tapping an order alert opens that order. |

Bottom navigation: **Dashboard · Orders · Menu · Earnings · Profile**.

### Order status flow

```
New ──Accept──▶ Accepted ──▶ Preparing ──▶ Ready for Pickup ──▶ Completed
 │
 └──Reject (Out of stock / Shop closed / Too busy / Other)──▶ Cancelled
```

- **Accepted** orders appear in the **Preparing** tab (the "in-kitchen" queue)
  with a *Mark as Preparing* button.
- Reject is only available while an order is **New**.
- Each transition stamps its time on the order's status timeline.

---

## Phase 1 decisions

| Topic | Decision |
|-------|----------|
| Accepted orders | Shown in the Preparing tab with an "Accepted" badge (no separate tab). |
| Earnings chart | Lightweight custom bar chart (`widgets/earnings_bar_chart.dart`) — the main app has no chart library, so none was added. |
| Pickup location | Vendors **multi-select** the points they serve (Main Gate / Hostel Gate); each order still carries its own pickup point. |
| Photo pickers | Real `image_picker` (camera / gallery); the image is shown from the local file only — **no upload**. |
| Dummy images | Unsplash URLs (same as the student app's food module), with an icon placeholder when offline. |
| "Today" figures | The dummy order book only contains today's orders, so Completed Today / Today's Earnings are derived live from completed orders. Week / month add static dummy figures on top. |

---

## Project structure

```
lib/
├── main.dart                 # ScreenUtil + GetMaterialApp
├── routes/app_routes.dart    # Route names + GetPage list (bindings attached)
├── theme/app_theme.dart      # AppColors, AppSpacing, AppRadius, AppShadows, AppTheme
├── controllers/              # GetX controllers (in-memory state)
│   ├── bindings.dart         # Login / Onboarding / Home bindings
│   ├── login_controller.dart
│   ├── onboarding_controller.dart
│   ├── home_shell_controller.dart   # bottom-nav tab + deep links into Orders
│   ├── shop_controller.dart         # shop profile + open/closed
│   ├── orders_controller.dart       # order list, tab filters, accept/advance/reject
│   ├── vendor_menu_controller.dart  # menu CRUD + availability
│   ├── earnings_controller.dart
│   └── notifications_controller.dart
├── data/                     # Static dummy data sources
│   ├── dummy_vendor.dart
│   ├── dummy_orders.dart     # timestamps relative to app launch
│   ├── dummy_menu.dart       # categories + icons + items
│   ├── dummy_earnings.dart
│   └── dummy_notifications.dart
├── modal/                    # Models + enums (status labels, colours, icons)
│   ├── vendor_shop.dart      # VendorShop, ShopCategory, ApprovalStatus
│   ├── vendor_order.dart     # VendorOrder, OrderItem, OrderStatus, OrderTab, RejectReason
│   ├── menu_item.dart
│   ├── pickup_point.dart
│   ├── earnings.dart         # DailyEarning, Payout, PayoutStatus
│   └── vendor_notification.dart
├── utils/formatters.dart     # ₹ (en_IN), times, "x min ago"
├── views/                    # One file per screen
└── widgets/                  # Shared UI
    ├── auth_widgets.dart     # AuthGradientScaffold, AuthCard, AuthTextField,
    │                         # AppDropdownField (bottom-sheet picker),
    │                         # AuthPrimaryButton, AuthStepProgress, AuthSegmentedControl
    ├── vendor_app_bar.dart   # Gradient app bar + MiCampus logo lockup, NotificationBell
    ├── vendor_brand.dart     # BrandLogoTile, VendorWordmark (logo + "VENDOR" tag)
    ├── common_widgets.dart   # SectionCard, StatusChip, VegBadge, EmptyState, AppSnack, dialogs
    ├── order_card.dart
    ├── order_actions.dart    # Status buttons + reject sheet
    ├── shop_form_widgets.dart# Category, pickup points, hours, photo picker
    ├── earnings_bar_chart.dart
    └── app_image.dart        # Local file → network → placeholder
```

### State & navigation

- **GetX** for state, routing and DI.
- Session controllers are registered by `HomeBinding` on the `/home` route.
  Logout calls `Get.offAllNamed('/login')`, which disposes them — the next
  login starts from fresh dummy data.
- Screens read controllers with `Get.find` and rebuild via `Obx`.

---

## Design system

Shares the MiCampus student app's identity so vendors don't feel like they are
in a different product:

- **Accent** `#FF5F15` (+ light / dark), navy text, **cream** scaffold `#F7F4EF`
- **Fonts:** Sora (headings) + Inter (body) via `google_fonts`
- **Radius:** buttons / inputs / chips 12, cards 20; soft navy card shadows
- Orange → dark gradient app bars with rounded bottom and the MiCampus logo
  lockup (same pattern as the student app's `CampusAppBar`)
- Vendor identity: MiCampus mark + **VENDOR** tag (`VendorWordmark`) on splash
  and auth screens

Tokens live in `lib/theme/app_theme.dart` — use them instead of hard-coded
values.

---

## Dependencies

| Package | Use |
|---------|-----|
| `get` | State management, routing, DI |
| `flutter_screenutil` | Responsive sizing (design size 390 × 844) |
| `google_fonts` | Sora + Inter |
| `intl` | Currency / date formatting |
| `cached_network_image` | Dummy menu / shop photos |
| `image_picker` | Local shop & item photos (iOS camera / photo-library usage strings set in `Info.plist`) |

---

## Next phase (not built yet)

- Vendor authentication (login, registration submit, admin-approval status)
- Order sync with the student-facing Food Ordering module
- Menu CRUD + image upload
- Push notifications for new orders
- Real earnings / payout data

Replace the `lib/data/dummy_*.dart` sources with repository / API classes; the
controllers' public methods (`advance`, `reject`, `add`, `updateItem`,
`toggleAvailability`, `setOpen`, …) are the integration points.
