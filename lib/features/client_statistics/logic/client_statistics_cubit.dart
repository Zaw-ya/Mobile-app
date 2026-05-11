import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../../core/networking/api_result.dart';
import '../../client_events/data/models/client_event_response.dart';
import '../../client_events/data/models/client_messages_status_response.dart';
import '../data/models/client_confirmation_service_response.dart';
import '../data/models/client_messages_statistics_response.dart';
import '../data/models/guest_type_list.dart';
import '../data/repo/client_statistics_repo.dart';
import 'client_statistics_states.dart';

/// Base class for handling pagination logic
class PaginationHandler<T> {
  final List<T> items = [];
  int currentPage = 0;
  int totalPages = 1;
  bool isLoading = false;

  bool get hasMore => currentPage < totalPages - 1;

  void reset() {
    currentPage = 0;
    items.clear();
    totalPages = 1;
    isLoading = false;
  }
}

class ClientStatisticsCubit extends Cubit<ClientStatisticsStates> {
  final ClientStatisticsRepo _clientStatisticsRepo;

  ClientStatisticsCubit(this._clientStatisticsRepo)
      : super(const ClientStatisticsStates.initial());
  final _eventsHandler = PaginationHandler<ClientEventDetails>();
  TextEditingController searchController = TextEditingController(text: "");
  final _messagesHandler = PaginationHandler<ClientMessagesStatusDetails>();
  String _lastSearchQuery = "";
  bool _isSearching = false;

  void getClientMessageStatistics(String eventId) async {
    if (isClosed) return;
    _safeEmit(const ClientStatisticsStates.loading());
    final response =
        await _clientStatisticsRepo.getClientMessageStatistics(eventId);
    if (isClosed) return;
    response.when(
      success: (response) {
        final ClientMessagesStatisticsResponse events = response;

        // Extract all message statistics
        final messageTypes = [
          events.confirmationMessages,
          events.cardMessages,
          events.eventLocationMessages,
          events.reminderMessages,
          events.congratulationMessages,
          events.urgentCancellationMessages,
          events.urgentPostponementMessages
        ];

        // Check if any message type has meaningful data
        bool hasData = messageTypes.any((messageType) =>
            messageType != null &&
            (messageType.readNumber ?? 0) +
                    (messageType.deliverdNumber ?? 0) +
                    (messageType.sentNumber ?? 0) +
                    (messageType.failedNumber ?? 0) +
                    (messageType.notSentNumber ?? 0) >
                0);

        hasData
            ? _safeEmit(ClientStatisticsStates.successFetchData(response))
            : _safeEmit(const ClientStatisticsStates.emptyInput());
      },
      failure: (error) =>
          _safeEmit(ClientStatisticsStates.error(message: error.toString())),
    );
  }

  void getSentCardsServices(String eventId) async {
    if (isClosed) return;
    _safeEmit(const ClientStatisticsStates.loading());
    final response = await _clientStatisticsRepo.getSentCardsServices(eventId);
    if (isClosed) return;
    response.when(
      success: (response) {
        _safeEmit(ClientStatisticsStates.successFetchData(response));
      },
      failure: (error) =>
          _safeEmit(ClientStatisticsStates.error(message: error.toString())),
    );
  }

// Add this helper method to safely emit states
  void _safeEmit(ClientStatisticsStates state) {
    if (!isClosed) {
      emit(state);
    }
  }

  void getClientConfirmationService(String eventId) async {
    if (isClosed) return;

    _safeEmit(const ClientStatisticsStates.loading());

    try {
      final response =
          await _clientStatisticsRepo.getClientConfirmationService(eventId);

      if (isClosed) return;

      response.when(
        success: (response) {
          if (isClosed) return;

          final ClientConfirmationServiceResponse events = response;

          if (events.acceptedGuestsNumber != null ||
              events.attendedGuestsNumber != null ||
              events.declienedGuestsNumber != null ||
              events.failedGuestsNumber != null ||
              events.notSentGuestsNumber != null ||
              events.totalGuestsNumber != null) {
            _safeEmit(ClientStatisticsStates.successFetchData(response));
          } else {
            _safeEmit(const ClientStatisticsStates.emptyInput());
          }
        },
        failure: (error) {
          if (!isClosed) {
            _safeEmit(ClientStatisticsStates.error(message: error.toString()));
          }
        },
      );
    } catch (e) {
      if (!isClosed) {
        _safeEmit(ClientStatisticsStates.error(message: 'some_error'.tr()));
      }
    }
  }

  @override
  Future<void> close() {
    searchController.dispose();
    return super.close();
  }

  /// Generic method to handle paginated API calls
  Future<void> _handlePaginatedRequest<T, R>({
    required PaginationHandler<T> handler,
    required Future<ApiResult> Function(String page) apiCall,
    required List<T> Function(dynamic response) getItems,
    required int Function(dynamic response) getPages,
    required R Function(List<T>, int) createResponse,
    bool isNextPage = false,
  }) async {
    if (isClosed) return;
    if (handler.isLoading || (!handler.hasMore && isNextPage)) return;

    try {
      handler.isLoading = true;

      if (!isNextPage) {
        handler.reset();
        _safeEmit(const ClientStatisticsStates.loading());
      } else {
        handler.currentPage++;
        _safeEmit(ClientStatisticsStates.success(
          createResponse(handler.items, handler.totalPages),
          isLoadingMore: true,
        ));
      }

      final response = await apiCall((handler.currentPage + 1).toString());

      if (isClosed) return;

      await response.when(
        success: (data) async {
          final items = getItems(data);
          if (items.isNotEmpty) {
            if (handler.currentPage == 0) {
              handler.items.clear();
              handler.totalPages = getPages(data);
            }

            handler.items.addAll(items);

            _safeEmit(ClientStatisticsStates.success(
              createResponse(handler.items, handler.totalPages),
              isLoadingMore: false,
            ));
          } else if (handler.currentPage == 0) {
            _safeEmit(const ClientStatisticsStates.emptyInput());
          }
        },
        failure: (error) {
          _safeEmit(ClientStatisticsStates.error(message: error.toString()));
        },
      );
    } catch (e) {
      _safeEmit(ClientStatisticsStates.error(message: 'some_error'.tr()));
    } finally {
      handler.isLoading = false;
    }
  }

  /// Fetch paginated Client Events
  Future<void> getClientEvents({bool isNextPage = false}) async {
    await _handlePaginatedRequest<ClientEventDetails, ClientEventResponse>(
      handler: _eventsHandler,
      apiCall: _clientStatisticsRepo.getClientEvents,
      getItems: (response) =>
          (response as ClientEventResponse).eventDetailsList ?? [],
      getPages: (response) => (response as ClientEventResponse).noOfPages ?? 1,
      createResponse: (items, totalPages) => ClientEventResponse(
          eventDetailsList: List<ClientEventDetails>.from(items),
          noOfPages: totalPages),
      isNextPage: isNextPage,
    );
  }

  /// Fetch paginated Client Messages Status
  Future<void> getClientMessagesStatus(String eventId, GuestListType type,
      {bool isNextPage = false}) async {
    if (!isNextPage) {
      _isSearching = false;
      _lastSearchQuery = "";
    }

    await _handlePaginatedRequest<ClientMessagesStatusDetails,
        ClientMessagesStatusResponse>(
      handler: _messagesHandler,
      apiCall: (page) => _clientStatisticsRepo.getClientMessagesStatusDetails(
          eventId, page, _lastSearchQuery, type),
      getItems: (response) =>
          (response as ClientMessagesStatusResponse)
              .clientMessagesDetailsList ??
          [],
      getPages: (response) =>
          (response as ClientMessagesStatusResponse).noOfPages ?? 1,
      createResponse: (items, totalPages) => ClientMessagesStatusResponse(
          clientMessagesDetailsList:
              List<ClientMessagesStatusDetails>.from(items),
          noOfPages: totalPages),
      isNextPage: isNextPage,
    );
  }

  Future<void> searchMessageStatus({
    required String eventId,
    required String searchQuery,
    required GuestListType type,
    bool isNextPage = false,
  }) async {
    if (searchQuery.isEmpty) {
      clearSearch();
      getClientMessagesStatus(eventId, type);
      return;
    }

    // Update search-related states
    _lastSearchQuery = searchQuery;
    _isSearching = true;

    // Reset pagination handler if not loading next page
    if (!isNextPage) {
      _messagesHandler.reset();
    }

    // Use the same pagination handler method with search query
    await _handlePaginatedRequest<ClientMessagesStatusDetails,
        ClientMessagesStatusResponse>(
      handler: _messagesHandler,
      apiCall: (page) => _clientStatisticsRepo.getClientMessagesStatusDetails(
          eventId, page, searchQuery, type),
      getItems: (response) =>
          (response as ClientMessagesStatusResponse)
              .clientMessagesDetailsList ??
          [],
      getPages: (response) =>
          (response as ClientMessagesStatusResponse).noOfPages ?? 1,
      createResponse: (items, totalPages) => ClientMessagesStatusResponse(
          clientMessagesDetailsList:
              List<ClientMessagesStatusDetails>.from(items),
          noOfPages: totalPages),
      isNextPage: isNextPage,
    );
  }

  /// Clear search and reset state
  void clearSearch() {
    searchController.clear();
    _lastSearchQuery = "";
    _isSearching = false;
    _messagesHandler.reset();
  }

  // Public getters for state information
  bool get hasMoreEvents => _eventsHandler.hasMore;

  bool get isSearching => _isSearching;

  bool get hasMoreMessages => _messagesHandler.hasMore;
}
