import 'package:expireance/features/expire_items/domain/models/expire_item_model.dart';
import 'package:expireance/features/expire_items/domain/repositories/i_expire_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'expire_actor.freezed.dart';

class ExpireActor extends Cubit<ExpireActorState> {
  final IExpireRepository _expireRepository;

  ExpireActor(this._expireRepository) : super(const ExpireActorState.initial());

  Future<void> storeExpireItem(ExpireItemModel model) async {
    emit(const ExpireActorState.loading());

    final result = await _expireRepository.storeExpireItem(model: model);

    emit(
      result.fold(
        (error) => ExpireActorState.error(error.message),
        (_) => const ExpireActorState.success(),
      ),
    );
  }

  Future<void> updateExpireItem(String id, ExpireItemModel model) async {
    emit(const ExpireActorState.loading());

    final result = await _expireRepository.updateExpireItem(
      id: id,
      model: model,
    );

    emit(
      result.fold(
        (error) => ExpireActorState.error(error.message),
        (_) => const ExpireActorState.success(),
      ),
    );
  }

  Future<void> deleteExpireItem(String id) async {
    emit(const ExpireActorState.loading());

    final result = await _expireRepository.deleteExpireItem(id: id);

    emit(
      result.fold(
        (error) => ExpireActorState.error(error.message),
        (_) => const ExpireActorState.success(),
      ),
    );
  }
}

@freezed
class ExpireActorState with _$ExpireActorState {
  const factory ExpireActorState.initial() = _Initial;

  const factory ExpireActorState.loading() = _Loading;

  const factory ExpireActorState.success() = _Success;

  const factory ExpireActorState.error(String message) = _Error;
}
