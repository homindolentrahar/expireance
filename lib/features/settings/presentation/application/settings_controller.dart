import 'package:expireance/features/settings/domain/models/settings_model.dart';
import 'package:expireance/features/settings/domain/repositories/i_settings_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_controller.freezed.dart';

class SettingsController extends Cubit<SettingsState> {
  final ISettingsRepository _repository;

  SettingsController(this._repository) : super(const SettingsState());

  void fetchSettings() {
    final result = _repository.fetchSettings();

    emit(
      result.fold(
        (error) => const SettingsState(),
        (success) => SettingsState(
          enableNotification: success.enableNotification,
        ),
      ),
    );
  }

  void enableNotificationChanged(bool value) {
    emit(
      state.copyWith(enableNotification: value),
    );
  }

  Future<void> updateSettings() async {
    final result = await _repository.updateSettings(
      model: SettingsModel(enableNotification: state.enableNotification),
    );

    result.fold(
      (error) => debugPrint(error.message),
      (_) => debugPrint("Settings updated"),
    );
  }
}

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default(false) bool enableNotification,
  }) = _SettingsState;
}
