import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/device_repository.dart';
import 'device_event.dart';
import 'device_state.dart';

class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  final DeviceRepository repository;

  DeviceBloc(this.repository) : super(DeviceInitial()) {
    on<FetchDevicesEvent>((event, emit) async {
      emit(DeviceLoading());
      try {
        final devices = await repository.getAllDevices();
        final blacklists = await repository.getBlacklistedDevices();
        emit(DeviceLoaded(devices: devices, blacklistedDevices: blacklists));
      } catch (e) {
        emit(DeviceError(e.toString()));
      }
    });

    on<UnblockDeviceEvent>((event, emit) async {
      try {
        await repository.unblockDevice(event.hardwareId);
        add(FetchDevicesEvent());
      } catch (e) {
        emit(DeviceError(e.toString()));
      }
    });
  }
}
