
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

abstract class BLEHandlerProtocol {
  void startScanningDevices({required List<Uuid> withServices, bool requireLocationServicesEnabled = false,});
  void connectToDevice({required String deviceId, Duration? connectionTimeout});
  void disconnectDevice({required String deviceId});
  void discoverDeviceServices({required String deviceId});
  void readCharacteristicValue({required Uuid serviceId, required Uuid characteristicId, required String deviceId});

///TODO: Add other methods like
///discover services of connected device
///connect to any service and discover its characteristics
///subscribe to any service
}