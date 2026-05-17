import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/profile_model.dart';
import '../data/repo/profile_repo.dart';
import 'profile_states.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  final ProfileRepo _profileRepo;

  ProfileCubit(this._profileRepo) : super(const ProfileStates.initial());

  ProfileModel? get profile => state.maybeWhen(
        success: (profile) => profile,
        orElse: () => null,
      );

  void getProfileData() async {
    if (isClosed) return;
    emit(const ProfileStates.loading());

    final response = await _profileRepo.getProfile();
    if (isClosed) return;

    response.when(
      success: (profile) => emit(ProfileStates.success(profile)),
      failure: (error) => emit(ProfileStates.error(message: error.toString())),
    );
  }

  void getGkProfile({required int gatekeeperId}) async {
    if (isClosed) return;
    emit(const ProfileStates.getGatekeeperLoading());

    final response =
        await _profileRepo.getGkProfile(gatekeeperId: gatekeeperId);
    log('Gatekeeper ID: $gatekeeperId');
    if (isClosed) return;

    response.when(
      success: (profile) {
        log('Success: ${profile.firstName}');
        return emit(ProfileStates.getGatekeeperSuccess(profile));
      
      },
      failure: (error){ 
        log('Error: $error');
          return emit(ProfileStates.getGatekeeperError(message: error.toString()));},
    );
  }

  @override
  Future<void> close() async {
    await super.close();
  }
}
