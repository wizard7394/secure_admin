abstract class DeviceEvent {}

class FetchDevicesEvent extends DeviceEvent {}

class UnblockDeviceEvent extends DeviceEvent {
  final String hardwareId;
  UnblockDeviceEvent(this.hardwareId);
}
