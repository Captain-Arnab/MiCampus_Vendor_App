import 'package:flutter/material.dart';

/// Campus hand-over points — mirrors the student app's pickup preference.
enum PickupPoint {
  mainGate,
  hostelGate,
}

extension PickupPointX on PickupPoint {
  String get label {
    switch (this) {
      case PickupPoint.mainGate:
        return 'Main Gate';
      case PickupPoint.hostelGate:
        return 'Hostel Gate';
    }
  }

  String get subtitle {
    switch (this) {
      case PickupPoint.mainGate:
        return 'Near admin block / main entrance';
      case PickupPoint.hostelGate:
        return 'Near hostel complex entrance';
    }
  }

  IconData get icon {
    switch (this) {
      case PickupPoint.mainGate:
        return Icons.apartment_rounded;
      case PickupPoint.hostelGate:
        return Icons.home_work_outlined;
    }
  }
}
