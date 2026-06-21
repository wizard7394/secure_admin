abstract class DeviceEvent {}

class FetchDevicesEvent extends DeviceEvent {}

class UnblockDeviceEvent extends DeviceEvent {
  final String hardwareId;
  final String reason;
  UnblockDeviceEvent(this.hardwareId, this.reason);
}

class ToggleBlockEvent extends DeviceEvent {
  final int deviceId;
  final bool isBlocked;
  final String reason;
  ToggleBlockEvent(this.deviceId, this.isBlocked, this.reason);
}
