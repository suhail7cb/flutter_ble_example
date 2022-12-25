
import 'dart:async';

import 'package:ble_project/src/ble_manager/ble_manager.dart';
import 'package:ble_project/src/ble_manager/ble_periphiral_model.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:rxdart/rxdart.dart';

class DeviceDetailBloc {

  DeviceDetailBloc({required this.selectedDevice}) {
    _connectedDeviceServicesStreamSubscription = _bleManager.connectedDeviceServicesStream.listen((List<DiscoveredService> services) {
      print(services);
      allDiscoveredCharacteristic.clear();
      for(DiscoveredService service in services) {
        for(DiscoveredCharacteristic characteristic in service.characteristics) {
          allDiscoveredCharacteristic.add(characteristic);
        }
      }
      print(allDiscoveredCharacteristic.length);
      _discoveredCharacteristicObserver.sink.add(allDiscoveredCharacteristic);

    });
  }

  BLEPeripheralModel selectedDevice;
  BleManager _bleManager = BleManager();

  late StreamSubscription _connectedDeviceServicesStreamSubscription;
  List<DiscoveredCharacteristic> allDiscoveredCharacteristic = [];

  PublishSubject<List<DiscoveredCharacteristic>> _discoveredCharacteristicObserver = PublishSubject<List<DiscoveredCharacteristic>>();
  Stream<List<DiscoveredCharacteristic>> get discoveredCharacteristicStream => _discoveredCharacteristicObserver.stream;


  void discoverDeviceServices(String id) {
    _bleManager.discoverDeviceServices(deviceId: id);
  }

  void disconnectBleDevice(String id) {
    BleManager().disconnectDevice(deviceId: id);
  }

  Future<List<int>> readCharacteristic(DiscoveredCharacteristic characteristic) async {
    return _bleManager.readCharacteristicValue(serviceId: characteristic.serviceId,
        characteristicId: characteristic.characteristicId, deviceId: selectedDevice.id);
  }

  void dispose() {
    _connectedDeviceServicesStreamSubscription.cancel();
    _discoveredCharacteristicObserver.close();
  }
}