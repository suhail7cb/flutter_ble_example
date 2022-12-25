import 'package:ble_project/src/app_flow/main_app_flow/device_detail/device_detail_bloc.dart';
import 'package:ble_project/src/app_flow/main_app_flow/device_detail/device_detail_screen.dart';
import 'package:ble_project/src/app_flow/main_app_flow/devices_list/ble_devices_list_bloc.dart';
import 'package:ble_project/src/ble_manager/ble_periphiral_model.dart';
import 'package:ble_project/src/localisation_manager/language_manager.dart';
import 'package:ble_project/src/localisation_manager/localisation_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'ble_devices_list_widget.dart';


class BLEDevicesListScreen extends StatefulWidget {

  BLEDevicesListScreen({required this.bloc});

  final BLEDevicesListBloc bloc;
  @override
  State<BLEDevicesListScreen> createState() => DeviceListScreenState();
}

class DeviceListScreenState extends State<BLEDevicesListScreen> {
  bool connectionStateStreamBeingListened = false;
  @override
  void initState() {
    widget.bloc.bleManager.isBluetoothAvailable.listen((bool event) {
      if(event)
        widget.bloc.bleManager.startScanningDevices(withServices: []);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LanguageManager().localize(LocalisationKeys.bluetoothDevices.value)),
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        child: StreamBuilder<bool>(
          stream: widget.bloc.bleManager.isBluetoothAvailable,
          initialData: null,
          builder: (context, snapshot) {
            if(snapshot.data == null)
              return Container();

            bool bluetoothStatus = snapshot.data ?? false;
            if(bluetoothStatus)
              return Container(
              child: StreamBuilder<List<BLEPeripheralModel>>(
                initialData: <BLEPeripheralModel>[],
                stream: widget.bloc.bleManager.discoveredDeviceStream,
                builder: (BuildContext context, snapshot) => RefreshIndicator(
                  onRefresh: widget.bloc.refreshDevicesList ,
                  child: Container(
                    padding: EdgeInsets.all(10),
                      child: BleDevicesListWidget(widget.bloc, snapshot.data, didSelectDevice )),
                ),
              ),
            );
            else
              return _errorMessageWidget(LanguageManager().localize(LocalisationKeys.bluetoothDisabledMessage.value));
          }
        ),
      ),
    );
  }

  void didSelectDevice(BLEPeripheralModel device){
    if(!connectionStateStreamBeingListened) {
      widget.bloc.bleManager.connectingToDeviceStatusStream.listen((
          ConnectionStateUpdate status) {
        if (status.connectionState == DeviceConnectionState.connected)
          Navigator.of(context).push<dynamic>(
            MaterialPageRoute<dynamic>(builder: (BuildContext context) =>
                DeviceDetailScreen(
                    bloc: DeviceDetailBloc(selectedDevice: device))
            ),);
      });
      connectionStateStreamBeingListened = true;
    }

    widget.bloc.connectToDevice(device: device);
  }

  Widget _errorMessageWidget(String title) {
    return Center(child: Text(title),);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void deactivate() {
    print("deactivate");
    super.deactivate();
  }
}

