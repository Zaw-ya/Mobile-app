import 'dart:developer';

import 'package:app/core/services/notification_scheduler.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/helpers/app_utilities.dart';
import '../data/models/gatekeeper_events_response.dart';
import '../data/models/event_details_response.dart';
import '../data/repo/gatekeeper_events_repo.dart';
import 'scan_history_states.dart';

class GatekeeperEventsCubit extends Cubit<ScanHistoryStates> {
  final GatekeeperEventsRepo _gatekeeperEventsRepo;

  static const String _checkInStatusKey = 'event_check_in_status_';

  // For Gatekeeper Events Pagination
  final List<EventsList> _events = [];
  int _currentPageEvents = 0; // Changed to start from 0 like old code
  int _totalPagesEvents = 1;
  bool _isLoadingEvents = false;

  // For Event Details Pagination
  final List<EventDetails> _eventDetails = [];
  int _currentPageDetails = 0; // Changed to start from 0 like old code
  int _totalPagesDetails = 1;
  bool _isLoadingDetails = false;

  GatekeeperEventsCubit(this._gatekeeperEventsRepo)
      : super(const ScanHistoryStates.initial());

  /// Reset events pagination
  void resetEventsPage() {
    _currentPageEvents = 0;
    _events.clear();
    _totalPagesEvents = 1;
  }

  /// Reset details pagination
  void resetDetailsPage() {
    _currentPageDetails = 0;
    _eventDetails.clear();
    _totalPagesDetails = 1;
  }

  /// Check if more events pages are available
  bool get hasMoreEvents => _currentPageEvents < _totalPagesEvents - 1;

  /// Check if more details pages are available
  bool get hasMoreDetails => _currentPageDetails < _totalPagesDetails - 1;

  /// Fetch paginated Gatekeeper Events
  Future<void> getGatekeeperEvents({bool isNextPage = false}) async {
    if (_isLoadingEvents || (!hasMoreEvents && isNextPage)) return;

    try {
      _isLoadingEvents = true;

      if (!isNextPage) {
        resetEventsPage();
        if (!isClosed) emit(const ScanHistoryStates.loading()); // ✅ guard
      } else {
        _currentPageEvents++;
        if (!isClosed) {
          emit(ScanHistoryStates.success(
            // ✅ guard
            GatekeeperEventsResponse(entityList: _events),
            isLoadingMore: true,
          ));
        }
      }

      final response = await _gatekeeperEventsRepo.getGatekeeperEvents(
        (_currentPageEvents + 1).toString(),
      );

      await response.when(
        success: (data) async {
          if (data.entityList != null && data.entityList!.isNotEmpty) {
            if (_currentPageEvents == 0) {
              _events.clear();
              _totalPagesEvents = data.noOfPages ?? 1;
            }
            _events.addAll(data.entityList!);
            // for (var event in data.entityList!) {
            //   // ملحوظة: لازم تتأكدي إن event هو الموديل اللي بياخده الـ Scheduler
            //   // لو الموديل مختلف، هتحتاجي تحولي البيانات لموديل CalenderEventsResponse
            //   await NotificationScheduler().scheduleNotifications(
            //     id: event.id!,
            //     eventTitle: event.eventTitle!,
            //     eventFrom: event.eventFrom!,
            //   );
            //   log("Scheduled notifications for event >>> ${event.eventTitle} Haneen Test");
            // }
            if (!isClosed) {
              emit(ScanHistoryStates.success(
                // ✅ guard
                GatekeeperEventsResponse(
                  entityList: _events,
                  noOfPages: _totalPagesEvents,
                ),
                isLoadingMore: false,
              ));
            }
            if (_currentPageEvents == 0) {
              log("--- Starting Notification Sync (Haneen Test) ---");
              for (var event in data.entityList!) {
                // بننادي الـ Scheduler لكل حدث، وهو جواه الـ Logic اللي بيقرر (Skip أو Schedule)
                // بناءً على الـ Key-Value (ID و Date) المتخزنين في الـ AppUtilities
                await NotificationScheduler().scheduleNotifications(
                  id: event.id!,
                  eventTitle: event.eventTitle!,
                  eventFrom: event.eventFrom!,
                );
              }
              log("--- Notification Sync Completed (Haneen Test) ---");
            }
          } else if (_currentPageEvents == 0) {
            if (!isClosed) {
              emit(const ScanHistoryStates.emptyInput());
            } // ✅ guard
          }
        },
        failure: (error) {
          if (!isClosed) {
            emit(ScanHistoryStates.error(message: error.toString()));
          } // ✅
        },
      );
    } catch (e) {
      if (!isClosed) {
        emit(ScanHistoryStates.error(message: 'some_error'.tr()));
      } // ✅
    } finally {
      _isLoadingEvents = false;
    }
  }

  /// Fetch paginated Event Details
  Future<void> getEventDetails(String eventId,
      {bool isNextPage = false}) async {
    // Don't proceed if already loading or trying to load next page when no more pages
    if (_isLoadingDetails || (!hasMoreDetails && isNextPage)) return;

    try {
      _isLoadingDetails = true;

      if (!isNextPage) {
        resetDetailsPage();
        emit(const ScanHistoryStates.loading());
      } else {
        _currentPageDetails++;
        emit(ScanHistoryStates.success(
          EventDetailsResponse(eventDetailsList: _eventDetails),
          isLoadingMore: true,
        ));
      }

      final response = await _gatekeeperEventsRepo.getEventDetails(
        eventId,
        (_currentPageDetails + 1)
            .toString(), // Adding 1 because API expects 1-based index
      );

      await response.when(
        success: (data) async {
          if (data.eventDetailsList != null &&
              data.eventDetailsList!.isNotEmpty) {
            if (_currentPageDetails == 0) {
              _eventDetails.clear();
              _totalPagesDetails = data.noOfPages ?? 1;
            }

            _eventDetails.addAll(data.eventDetailsList!);

            emit(ScanHistoryStates.success(
              EventDetailsResponse(
                eventDetailsList: _eventDetails,
                noOfPages: _totalPagesDetails,
              ),
              isLoadingMore: false,
            ));
          } else if (_currentPageDetails == 0) {
            emit(const ScanHistoryStates.emptyInput());
          }
        },
        failure: (error) {
          emit(ScanHistoryStates.error(message: error.toString()));
        },
      );
    } catch (e) {
      emit(ScanHistoryStates.error(message: 'some_error'.tr()));
    } finally {
      _isLoadingDetails = false;
    }
  }

  List<EventsList> get currentEvents => _events;

  List<EventDetails> get currentDetails => _eventDetails;

  Future<void> eventCheckOut(
    String eventId,
    Position position,
  ) async {
    emit(const ScanHistoryStates.loadingCheckOut());
    try {
      final response =
          await _gatekeeperEventsRepo.eventCheckOut(eventId, position);
      await response.when(
        success: (response) async {
          await markAsCheckedOut(eventId);
          debugPrint('Check-out success: $response');
          emit(ScanHistoryStates.successCheck(response));
        },
        failure: (error) async {
          debugPrint('Check-out failed: $error');
          emit(ScanHistoryStates.errorCheck(message: error.toString()));
        },
      );
    } catch (e) {
      emit(ScanHistoryStates.errorCheck(message: e.toString()));
    }
  }

  Future<void> eventCheckIn(
    String eventId,
    Position position,
    XFile? profileImage,
  ) async {
    emit(const ScanHistoryStates.loadingCheckIn());
    try {
      final response = await _gatekeeperEventsRepo.eventCheckIn(
          eventId, position, profileImage);
      await response.when(
        success: (response) async {
          await markAsCheckedIn(eventId);
          debugPrint('Check-in success: $response');
          emit(ScanHistoryStates.successCheck(response));
        },
        failure: (error) async {
          debugPrint('Check-in failed: $error');
          emit(ScanHistoryStates.errorCheck(message: error.toString()));
        },
      );
    } catch (e) {
      debugPrint('Check-in failed: $e');
      emit(ScanHistoryStates.errorCheck(message: e.toString()));
    }
  }

  void deleteEvent(
    String eventId,
  ) async {
    emit(const ScanHistoryStates.loadingDeleteEvent());
    final response = await _gatekeeperEventsRepo.deleteEvent(eventId);
    response.when(success: (response) async {
      getGatekeeperEvents();
      emit(ScanHistoryStates.successDeleteEvent(response));
      await NotificationScheduler().cancelScheduledNotifications(int.parse(eventId));
    }, failure: (error) {
      debugPrint(' in error: $error');
      if (error == "not_yet_checked") {
        debugPrint(
            'Emitting errorCheck with message: ${"not_yet_checked".tr()}');
        emit(
          ScanHistoryStates.errorCheck(
            message: "not_yet_checked".tr(),
          ),
        );
      } else {
        emit(
          ScanHistoryStates.errorDeleteEvent(
            message: error.toString(),
          ),
        );
      }
    });
  }

  /// Mark event as checked in (moved from widget)
  Future<void> markAsCheckedIn(String eventId) async {
    //await AppUtilities().setString("event_id", eventId);
    await AppUtilities().setBool(_checkInStatusKey + eventId, true);
  }

  /// Mark event as checked out (moved from widget)
  Future<void> markAsCheckedOut(String eventId) async {
    await AppUtilities().setBool(_checkInStatusKey + eventId, false);
  }

  /// Check if an event has been checked in
  Future<bool> hasCheckedIn(String eventId) async {
    final status =
        await AppUtilities().getBool(_checkInStatusKey + eventId, false);
    return status;
  }

// جوه GatekeeperEventsCubit

  // Future<void> syncNotifications() async {
  //   // بنجيب البيانات من الريبو (ممكن تستخدمي ميثود موجودة فعلاً عندك)
  //   final response = await _gatekeeperEventsRepo
  //       .getGatekeeperEvents("1"); // أول صفحة كفاية للمزامنة

  //   response.when(
  //     success: (data) async {
  //       if (data.entityList != null && data.entityList!.isNotEmpty) {
  //         // ننادي المجدول الذكي
  //         await NotificationScheduler()
  //             .scheduleMultipleNotifications(data.entityList!);
  //       }
  //     },
  //     failure: (error) => debugPrint("Notification Sync Failed: $error"),
  //   );
  // }
}
