import 'package:ble_project/src/ble_manager/ble_periphiral_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'ble_devices_list_bloc.dart';

typedef DeviceTapListener = void Function();
typedef DeviceDidSelect = void Function(BLEPeripheralModel device);


class BleDevicesListWidget extends ListView {
  BleDevicesListWidget(BLEDevicesListBloc bloc, List<BLEPeripheralModel>? devices, DeviceDidSelect didSelectDevice)
      : super.separated(
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey[300],
        height: 0,
        indent: 0,
      ),
      itemCount: devices?.length ?? 0,
      itemBuilder: (context, i) {
        return _buildRow(context, devices![i], _createTapListener(devices[i], didSelectDevice), bloc);
      });

  static DeviceTapListener _createTapListener(
      BLEPeripheralModel bleDevice, DeviceDidSelect didSelectDevice) {
    return () {
      print('Connect to device: ${bleDevice.name}');
      didSelectDevice(bleDevice);
    };
  }

  static Widget _buildRow(BuildContext context, BLEPeripheralModel device,
      DeviceTapListener deviceTapListener, BLEDevicesListBloc bloc,) {
    return  Card(
      elevation: 8,
      //shadowColor: Colors.red,
      child: ListTile(
        leading: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: _buildAvatar(context, device),
        ),
        title: _textWidget(title: device.name, style: TextStyle(fontSize: 16,)),
        trailing: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Icon(Icons.chevron_right, color: Colors.grey),
          // child: StreamBuilder<ConnectionStateUpdate>(
          //   stream: bloc.bleManager.connectingToDeviceStatusStream,
          //   builder: (context, snapshot) {
          //     if(snapshot.data == null)
          //       return Icon(Icons.chevron_right, color: Colors.grey);
          //     else {
          //       if(snapshot.data!.connectionState == DeviceConnectionState.connected) {
          //         didSelectDevice(device);
          //       }
          //       if (snapshot.data!.connectionState ==
          //           DeviceConnectionState.connecting)
          //         return CircularProgressIndicator();
          //       else
          //         return Icon(Icons.chevron_right, color: Colors.grey);
          //     }
          //   }
          // ),
        ),
        subtitle: Row(
          children: <Widget>[
            Expanded(child: _textWidget(title: device.id,),),
            _textWidget(title: '${device.rssi}',)
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        onTap: deviceTapListener,
        contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 12),
      ),
    );
  }

  static Widget _buildAvatar(BuildContext context, BLEPeripheralModel device) {
    return CircleAvatar(
        child: Icon(Icons.bluetooth),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white);
  }

  static Text _textWidget({required String title,
    TextStyle style = const TextStyle(fontSize: 10),
    int  maxLines = 1,
    TextOverflow  overflow = TextOverflow.ellipsis,
  }) {
    return Text(title,
      style: style,
      maxLines: maxLines,
      overflow: overflow,
    );
  }


}