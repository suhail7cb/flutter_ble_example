import 'dart:async';

import 'package:ble_project/src/app_flow/main_app_flow/device_detail/device_detail_bloc.dart';
import 'package:ble_project/src/localisation_manager/language_manager.dart';
import 'package:ble_project/src/localisation_manager/localisation_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class DeviceDetailScreen extends StatefulWidget {

  const DeviceDetailScreen({Key? key, required this.bloc}) : super(key: key);
  final DeviceDetailBloc bloc;

  @override
  _DeviceDetailScreenState createState() => _DeviceDetailScreenState();
}

class _DeviceDetailScreenState extends State<DeviceDetailScreen> {

  @override
  void initState() {
    super.initState();
    widget.bloc.discoverDeviceServices(widget.bloc.selectedDevice.id);
  }

  @override
  Widget build(BuildContext context) {
    print('Detail Screen');
    return WillPopScope(
      onWillPop: pop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.bloc.selectedDevice.name.isNotEmpty
              ? widget.bloc.selectedDevice.name
              : LanguageManager().localize(LocalisationKeys.deviceDetail.value)),
          leading: IconButton(icon: Icon(Icons.arrow_back),
              onPressed: () {
                pop();
              }),
        ),
        body: _detailBodyWidget(),
      ),
    );
  }

  Future<bool> pop() {
    //Give alert, device will be disconnected.
    widget.bloc.disconnectBleDevice(widget.bloc.selectedDevice.id);
    Navigator.pop(context);
    return Future.value(true);
  }

  Widget _detailBodyWidget() {

    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          _textWidget(title: 'Device UDID: '+ widget.bloc.selectedDevice.id, style: TextStyle(fontSize: 16, color: Colors.blue)),
          Expanded(
            child: Container(

              child: StreamBuilder<List<DiscoveredCharacteristic>>(
                  stream: widget.bloc.discoveredCharacteristicStream,
                  initialData: [],
                  builder: (context, snapshot) {
                    List<DiscoveredCharacteristic> allCharacteristics = snapshot.data ?? [];
                    return ListView.builder(
                        itemCount: allCharacteristics.length,
                        itemBuilder: (context, int index){

                          return Container(
                            margin: EdgeInsets.all(5),
                            child: PhysicalModel(
                              color: Colors.white,
                              elevation: 10,
                              shadowColor: Colors.black26,
                              child: _characteristicCell(allCharacteristics[index]),
                            ),
                          );
                        });
                  }
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _characteristicCell(DiscoveredCharacteristic characteristic) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 50,
        //maxHeight: 150
      ),
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _textWidget(title: 'Service UUID: ' + characteristic.serviceId.toString(), style: TextStyle(color: Colors.black,fontSize: 16),maxLines: 2),
          Container(
            margin: EdgeInsets.only(top: 5,bottom: 5),
              child: _textWidget(title: 'Characteristic ID: ' + characteristic.characteristicId.toString())),
          readValueWidget(characteristic)
        ],
      ),
    );
  }

  Widget readValueWidget(DiscoveredCharacteristic characteristic) {
      return characteristic.isReadable ?  FutureBuilder(
          future: widget.bloc.readCharacteristic(characteristic),
      builder: (BuildContext context, AsyncSnapshot<List<int>> futureData) {
          if(futureData.hasData)
            return _textWidget(title:'Value read: ' + String.fromCharCodes(futureData.data ?? []));
          else
            return Container(
              height: 40,
              child: Center(child: CircularProgressIndicator()),
            );
      }
    ) : Container(child: _textWidget(title: 'Not readable'),);
  }


  Text _textWidget({required String title,
    TextStyle style = const TextStyle(fontSize: 12),
    int  maxLines = 2,
    TextOverflow  overflow = TextOverflow.ellipsis,
  }) {
    return Text(title,
      style: style,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
  
  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }
}
