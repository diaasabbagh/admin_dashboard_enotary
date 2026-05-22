part of 'admin_dashboard_controller.dart';

class AddressRotationController {
  AddressRotationController({required this.store});

  final DashboardStore store;

  void addRotation(AddressRotationRecord rotation) {
    store.rotations.insert(0, rotation);
  }

  void cancelRotation(AddressRotationRecord rotation) {
    rotation.status = 'Cancelled';
  }

  String nextRotationId() {
    return 'ROT-${5100 + store.rotations.length + 1}';
  }
}
