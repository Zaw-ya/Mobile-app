import 'package:app/core/theming/colors.dart';
import 'package:app/core/widgets/custom_loading_indicator.dart';
import 'package:app/core/widgets/empty_widget.dart';
import 'package:app/core/widgets/title_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/widgets/public_app_bar.dart';
import '../../../generated/assets.dart';
import '../../client_statistics/data/models/client_confirmation_service_response.dart';
import '../../client_statistics/data/models/client_messages_statistics_response.dart';
import '../../client_statistics/data/models/sent_cards_services_response.dart';
import '../../client_statistics/logic/client_statistics_cubit.dart';
import '../../client_statistics/logic/client_statistics_states.dart';
import 'widgets/client_statistics_tab_button.dart';
import 'widgets/confirmation_statistics_tab.dart';
import 'widgets/messages_statistics_tab.dart';
import 'widgets/sent_cards_statistics_tab.dart';

class ClientStatisticsDetailScreen extends StatefulWidget {
  final int eventId;
  final String eventTitle;

  const ClientStatisticsDetailScreen({super.key, required this.eventId,required this.eventTitle});

  @override
  State<ClientStatisticsDetailScreen> createState() =>
      _ClientStatisticsDetailScreenState();
}

class _ClientStatisticsDetailScreenState
    extends State<ClientStatisticsDetailScreen> {
  int _selectedTab = 0;

  // Per-tab cached responses — avoids re-fetching on tab switch
  ClientConfirmationServiceResponse? _confirmationData;
  SentCardsServicesResponse? _sentCardsData;
  ClientMessagesStatisticsResponse? _messagesData;

  // Per-tab error messages
  String? _tabError;

  ScrollController? _sheetScrollController;

  @override
  void initState() {
    super.initState();
    // Load tab 0 immediately
    context
        .read<ClientStatisticsCubit>()
        .getClientMessageStatistics(widget.eventId.toString());
  }

  @override
  void dispose() {
    _sheetScrollController?.dispose();
    super.dispose();
  }

  void _switchTab(int tab) {
    if (_selectedTab == tab) return;
    setState(() {
      _selectedTab = tab;
      _tabError = null;
    });

    final cubit = context.read<ClientStatisticsCubit>();
    final eventId = widget.eventId.toString();

    switch (tab) {
      case 0:
        if (_messagesData == null) {
          cubit.getClientMessageStatistics(eventId);
        }
        break;
      case 1:
        if (_sentCardsData == null) {
          cubit.getSentCardsServices(eventId);
        }
        break;
      case 2:
        if (_confirmationData == null) {
          cubit.getClientConfirmationService(eventId);
        }
        break;
    }
  }

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClientStatisticsCubit, ClientStatisticsStates>(
      listener: (context, state) {
        state.maybeWhen(
          successFetchData: (data) {
            setState(() {
              _tabError = null;
              if (data is ClientConfirmationServiceResponse) {
                _confirmationData = data;
              } else if (data is SentCardsServicesResponse) {
                _sentCardsData = data;
              } else if (data is ClientMessagesStatisticsResponse) {
                _messagesData = data;
              }
            });
          },
          error: (msg) => setState(() => _tabError = msg),
          orElse: () {},
        );
      },
      builder: (context, state) {
        final isLoading = state is Loading;

        return ModalProgressHUD(
          inAsyncCall: isLoading,
          progressIndicator: const CustomLoadingIndicator(),
          color: Colors.black,
          opacity: 0.5,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: recordsAppBar(context, widget.eventTitle),
            body: Container(
                decoration: BoxDecoration(gradient: AppColor.greenGradient),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColor.whiteColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(containerRadius),
                      topRight: Radius.circular(containerRadius),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: edge * 1.4),

                      // ── Tab buttons ──────────────────────────────
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: edge),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              ClientStatisticsTabButton(
                                label: 'messages_statistics'.tr(),
                                isSelected: _selectedTab == 0,
                                onTap: () => _switchTab(0),
                                image: Image.asset(Assets.imagesMessages,
                                    fit: BoxFit.contain),
                              ),
                              SizedBox(width: edge * 0.4),
                              ClientStatisticsTabButton(
                                label: 'invitations_statistics'.tr(),
                                isSelected: _selectedTab == 1,
                                onTap: () => _switchTab(1),
                                image: Image.asset(
                                    Assets.imagesInviteStatistics,
                                    fit: BoxFit.contain),
                              ),
                              SizedBox(width: edge * 0.4),
                              ClientStatisticsTabButton(
                                label: 'confirmations_statistics'.tr(),
                                isSelected: _selectedTab == 2,
                                onTap: () => _switchTab(2),
                                image: Image.asset(
                                    Assets.imagesAcceptStatistics,
                                    fit: BoxFit.contain),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: edge * 0.5),

                      // // ── Tab content ──────────────────────────────
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: edge),
                          child: _buildTabContent(),
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        );
      },
    );
  }

  Widget _buildTabContent() {
    // Error state
    if (_tabError != null) {
      return Center(child: TitleText(text: _tabError!, color: Colors.red));
    }

    // Waiting for first load (cached data not yet available)
    final hasCachedData = _currentTabHasData();
    if (!hasCachedData) {
      // ModalProgressHUD is already showing — return empty while loading
      return const SizedBox.shrink();
    }

    switch (_selectedTab) {
      case 0:
        return MessagesStatisticsTab(
          data: _messagesData!,
        );

      case 1:
        return SentCardsStatisticsTab(
          data: _sentCardsData!,
          eventId: widget.eventId.toString(),
        );
      case 2:
        return ConfirmationStatisticsTab(
          data: _confirmationData!,
          eventId: widget.eventId.toString(),
        );
      default:
        return const EmptyWidget();
    }
  }

  bool _currentTabHasData() {
    switch (_selectedTab) {
      case 0:
        return _messagesData != null; // was _confirmationData
      case 1:
        return _sentCardsData != null; // correct
      case 2:
        return _confirmationData != null; // was _messagesData
      default:
        return false;
    }
  }
}
