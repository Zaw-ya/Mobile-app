import 'package:freezed_annotation/freezed_annotation.dart';

import 'submit_outcome.dart';
import 'title_change_outcome.dart';

part 'manage_guests_states.freezed.dart';

/// The list, the draft and the deadline live in ManageGuestsCubit (like the
/// pagination data of ClientEventsCubit); states tell the screen what
/// happened. [loaded] carries a revision so every change rebuilds.
@Freezed()
class ManageGuestsStates with _$ManageGuestsStates {
  const factory ManageGuestsStates.initial() = _Initial;
  const factory ManageGuestsStates.loading() = Loading;
  const factory ManageGuestsStates.loaded({required int revision}) = Loaded;
  const factory ManageGuestsStates.error({required String message}) = Error;

  /// Adding the draft to the list, [done] of [total] rows sent so far.
  const factory ManageGuestsStates.submitting(
      {required int done, required int total}) = Submitting;
  const factory ManageGuestsStates.submitResult(SubmitOutcome outcome) =
      SubmitResult;

  /// A title being changed for a group of guests already on the list.
  const factory ManageGuestsStates.titleChanging() = TitleChanging;
  const factory ManageGuestsStates.titleChangeResult(
      TitleChangeOutcome outcome) = TitleChangeResult;

  /// Update or delete of a guest already on the list.
  const factory ManageGuestsStates.actionLoading() = ActionLoading;
  const factory ManageGuestsStates.actionSuccess({required String message}) =
      ActionSuccess;
  const factory ManageGuestsStates.actionError({required String message}) =
      ActionError;
}
