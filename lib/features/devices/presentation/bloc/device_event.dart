abstract class DeviceEvent {}

class FetchDevicesEvent extends DeviceEvent {}

class UnblockDeviceEvent extends DeviceEvent {
  final String hardwareId;
  UnblockDeviceEvent(this.hardwareId);
}

class ToggleBlockEvent extends DeviceEvent {
  final int deviceId;
  final bool isBlocked;
  ToggleBlockEvent(this.deviceId, this.isBlocked);
}
