abstract class DeviceState {}

class DeviceInitial extends DeviceState {}

class DeviceLoading extends DeviceState {}

class DeviceLoaded extends DeviceState {
  final List<dynamic> devices;
  final List<dynamic> blacklistedDevices;

  DeviceLoaded({required this.devices, required this.blacklistedDevices});
}

class DeviceError extends DeviceState {
  final String message;
  DeviceError(this.message);
}
