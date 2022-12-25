import 'package:ble_project/src/utils/enumeration.dart';

class LocalisationKeys extends Enum<String> {

  LocalisationKeys(String value) : super(value);
  static LocalisationKeys startScanningDevices = LocalisationKeys('start_scanning_devices');
  static LocalisationKeys bluetoothDevices = LocalisationKeys('bluetooth_devices');
  static LocalisationKeys deviceDetail = LocalisationKeys('device_detail');
  static LocalisationKeys bluetoothDisabledMessage = LocalisationKeys('bluetooth_disabled_message');

}
