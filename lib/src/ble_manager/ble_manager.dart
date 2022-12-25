
import 'package:ble_project/src/ble_manager/ble_handler_protocol.dart';
import 'package:ble_project/src/ble_manager/ble_periphiral_model.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:rxdart/rxdart.dart';

class BleManager implements BLEHandlerProtocol {

  BleManager._privateConstructor();
  static final BleManager _singleton = BleManager._privateConstructor();
  factory BleManager() {
    return _singleton;
  }

  final FlutterReactiveBle _flutterReactiveBleObject = FlutterReactiveBle();
  Stream<bool> get isBluetoothAvailable => _flutterReactiveBleObject.statusStream.map((event) => event == BleStatus.ready);

//Scanning objects
  PublishSubject<List<BLEPeripheralModel>> _discoveredDevicesObserver = PublishSubject<List<BLEPeripheralModel>>();
  Stream<List<BLEPeripheralModel>> get discoveredDeviceStream =>  _discoveredDevicesObserver.stream;

  List<BLEPeripheralModel> _discoveredDevices = [];
  List<BLEPeripheralModel> get discoveredDevices {
    _discoveredDevices.sort((device1, device2) => device2.rssi.compareTo(device1.rssi));
    return _discoveredDevices;
  }

  bool isScanning = false;
  DateTime? loginClickTime; // this will be used to sync updated devices after some defined time.

//Establishing connection
  PublishSubject<ConnectionStateUpdate> _connectingToDeviceStatus = PublishSubject<ConnectionStateUpdate>();
  Stream<ConnectionStateUpdate> get connectingToDeviceStatusStream =>  _connectingToDeviceStatus.stream;

  var _connectedDeviceStream;

  //List<DiscoveredService> connectedDevicesServices = [];
  PublishSubject<List<DiscoveredService>> _connectedDeviceServicesObserver = PublishSubject<List<DiscoveredService>>();
  Stream<List<DiscoveredService>> get connectedDeviceServicesStream =>  _connectedDeviceServicesObserver.stream;



  @override
  void startScanningDevices({required List<Uuid> withServices, bool requireLocationServicesEnabled = false}) {
    isScanning = true;
    _flutterReactiveBleObject.scanForDevices(withServices: withServices,requireLocationServicesEnabled: requireLocationServicesEnabled).listen((device) {
      ///TODO: verify if the desired device has been discovered
      /// If yes need to stop the scanning

      List<BLEPeripheralModel> _devices = _discoveredDevices.where((element) => element.id == device.id).toList();
      if(_devices.isNotEmpty) {
        _discoveredDevices.remove(_devices.first);
        _discoveredDevices.add(_devices.first);
      }
      else {
        if(device.name.isNotEmpty) //only adding peripheral gas name
          _discoveredDevices.add(BLEPeripheralModel(id: device.id, name: device.name, rssi: device.rssi));
      }

      if(loginClickTime == null){
        loginClickTime = DateTime.now();
      }
      else if(DateTime.now().difference(loginClickTime!).inSeconds > 4){
        _discoveredDevicesObserver.sink.add(discoveredDevices);
        loginClickTime = DateTime.now();
      }
    }, onError: (error) { //code for handling error
      print(error);
    });

  }

  void refreshDevicesList() {
    loginClickTime = null;
  }

  @override
  void connectToDevice({required String deviceId, Duration? connectionTimeout}) {
    _connectedDeviceStream =_flutterReactiveBleObject.connectToDevice(id: deviceId, ).listen((ConnectionStateUpdate event) {
      _connectingToDeviceStatus.sink.add(event);
    },onError: (error){
      print('Handle Error');
    });
  }

  @override
  void disconnectDevice({required String deviceId,}) {
    if(_connectedDeviceStream != null)
      _connectedDeviceStream.cancel();

    //reset all the variables
    //connectedDevicesServices.clear();
  }

  @override
  void discoverDeviceServices({required String deviceId}) {
    _flutterReactiveBleObject.discoverServices(deviceId).then((services) {
      _connectedDeviceServicesObserver.add(services);
    });
  }

  @override
  Future<List<int>> readCharacteristicValue({required Uuid serviceId,  required Uuid characteristicId, required String deviceId,}) async {
    final characteristic = QualifiedCharacteristic(serviceId: serviceId, characteristicId: characteristicId, deviceId: deviceId);
    var response = await _flutterReactiveBleObject.readCharacteristic(characteristic);
    return response;

  }
}
