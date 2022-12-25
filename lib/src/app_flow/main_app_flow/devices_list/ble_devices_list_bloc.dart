

import 'package:ble_project/src/ble_manager/ble_manager.dart';
import 'package:ble_project/src/ble_manager/ble_periphiral_model.dart';

class BLEDevicesListBloc {
  BleManager bleManager = BleManager();


  // Future<void> _checkPermissions() async {
  // }

  Future<void> refreshDevicesList() async {
    bleManager.refreshDevicesList();
  }

  void connectToDevice({required BLEPeripheralModel device}) {
    bleManager.connectToDevice(deviceId: device.id);
  }
}