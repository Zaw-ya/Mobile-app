import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/dimensions/dimensions_constants.dart';
import '../../../core/helpers/calendar_helper.dart';
import '../../../core/helpers/extensions.dart';
import '../../../core/theming/colors.dart';
import '../../event_calender/data/models/calender_events.dart';
import '../../event_calender/logic/event_calender_cubit.dart';
import '../../event_calender/logic/event_calender_states.dart';
import 'widgets/calendar_events_panel.dart';
import 'widgets/calendar_grid.dart';
import 'widgets/calendar_header.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  late DateTime _currentMonth;
  DateTime _selectedDay = DateTime.now();
  bool _isWeekView = true;
  bool _isEventsExpanded = false;

  // GlobalKeys so we can measure fixed chrome heights after the first frame
  final _navKey = GlobalKey();
  final _dayNamesKey = GlobalKey();
  final _toggleKey = GlobalKey();

  double _measuredHeaderHeight = 0;
  bool _headerMeasured = false;

  // ── Height calculations ────────────────────────────────────────────────────

  double get _calendarHeaderHeight {
    if (_headerMeasured) return _measuredHeaderHeight + 1.0;
    // Fallback estimate until the first-frame measurement arrives
    return 61.88 + 41.88 + edge * 0.4 * 3 + 20.0 + 1.0;
  }

  double get _calendarSectionHeight {
    if (_isEventsExpanded) return 0;
    final rows = _isWeekView
        ? 1
        : CalendarHelper.buildMonthDateList(_currentMonth).length ~/ 7;
    return _calendarHeaderHeight + rows * rowHeight;
  }

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _currentMonth = DateTime(now.year, now.month);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EventCalenderCubit>().getEventsCalendar();
      _measureHeaderHeight();
    });
  }

  void _measureHeaderHeight() {
    double total = 0;
    bool allFound = true;
    for (final key in [_navKey, _dayNamesKey, _toggleKey]) {
      final box = key.currentContext?.findRenderObject() as RenderBox?;
      if (box != null) {
        total += box.size.height;
      } else {
        allFound = false;
      }
    }
    total += edge * 0.4 * 3 + 1.0; // three spacers + rounding buffer
    if (allFound && total != _measuredHeaderHeight) {
      setState(() {
        _measuredHeaderHeight = total;
        _headerMeasured = true;
      });
    }
  }

  // ── Navigation ─────────────────────────────────────────────────────────────

  void _goPrevious() => setState(() {
    if (_isWeekView) {
      _selectedDay = _selectedDay.subtract(const Duration(days: 7));
      _currentMonth = DateTime(_selectedDay.year, _selectedDay.month);
    } else {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    }
  });

  void _goNext() => setState(() {
    if (_isWeekView) {
      _selectedDay = _selectedDay.add(const Duration(days: 7));
      _currentMonth = DateTime(_selectedDay.year, _selectedDay.month);
    } else {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    }
  });

  void _onDayTap(DateTime day) => setState(() {
    _selectedDay = day;
    if (day.month != _currentMonth.month ||
        day.year != _currentMonth.year) {
      _currentMonth = DateTime(day.year, day.month);
    }
  });

  void _onToggleView() => setState(() => _isWeekView = !_isWeekView);

  void _onToggleExpand() =>
      setState(() => _isEventsExpanded = !_isEventsExpanded);

  void _onDragEnd(DragEndDetails details) {
    if (details.primaryVelocity == null) return;
    if (details.primaryVelocity! < -100) {
      setState(() => _isEventsExpanded = true);
    } else if (details.primaryVelocity! > 100) {
      setState(() => _isEventsExpanded = false);
    }
  }

  // ── Event helpers ──────────────────────────────────────────────────────────

  List<CalenderEventsResponse> _eventsForDay(
      List<CalenderEventsResponse> all,
      DateTime day,
      ) {
    return all.where((e) {
      final from = DateTime.tryParse(e.eventFrom ?? '');
      final to = DateTime.tryParse(e.eventTo ?? '');
      if (from == null || to == null) return false;
      final d = DateTime(day.year, day.month, day.day);
      final f = DateTime(from.year, from.month, from.day);
      final t = DateTime(to.year, to.month, to.day);
      return d.isAtSameMomentAs(f) ||
          d.isAtSameMomentAs(t) ||
          (d.isAfter(f) && d.isBefore(t));
    }).toList();
  }

  bool _dayHasEvents(List<CalenderEventsResponse> all, DateTime day) =>
      _eventsForDay(all, day).isNotEmpty;

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  Future<void> _launchMap(BuildContext context, String? url) async {
    if (url == null || url.isEmpty) {
      context.showErrorToast('location_not_available'.tr());
      return;
    }
    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.platformDefault);
    } catch (_) {
      if (!context.mounted) return;
      context.showErrorToast('could_not_open_map'.tr());
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EventCalenderCubit, EventCalenderStates>(
      listener: (context, state) {
        state.whenOrNull(
          error: (msg) {
            final message = msg.contains('Failed host lookup')
                ? 'no_internet'.tr()
                : msg;
            context.showErrorToast(message);
          },
          // emptyInput: () =>
          //     context.showErrorToast('no_available_events'.tr()),
          errorReservation: (msg) => context.showErrorToast(msg),
        );
      },
      builder: (context, state) {
        final allEvents = state.maybeWhen(
          success: (events, _, __, ___) => events,
          orElse: () => <CalenderEventsResponse>[],
        );

        final bool isArabic = context.locale.languageCode == 'ar';
        final monthNames = isArabic
            ? CalendarHelper.arMonthNames
            : CalendarHelper.enMonthNames;
        final monthLabel =
            '${monthNames[_currentMonth.month - 1]} ${_currentMonth.year}';

        final dayList = _isWeekView
            ? CalendarHelper.buildWeekDateList(_selectedDay)
            : CalendarHelper.buildMonthDateList(_currentMonth);

        final selectedEvents = _eventsForDay(allEvents, _selectedDay);
        final formattedDate = DateFormat(
          'd MMMM yyyy',
          isArabic ? 'ar' : 'en',
        ).format(_selectedDay);

        return Scaffold(
          backgroundColor: AppColor.whiteColor,
          body: Column(
            children: [
              // App header — hidden when the events panel is fully expanded
              AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                height: _isEventsExpanded ? 0 : null,
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(),
                child: const CalendarHeader(),
              ),

              // Gradient calendar grid
              CalendarGrid(
                sectionHeight: _calendarSectionHeight,
                navKey: _navKey,
                dayNamesKey: _dayNamesKey,
                toggleKey: _toggleKey,
                isArabic: isArabic,
                dayNames: isArabic
                    ? CalendarHelper.arDayNames
                    : CalendarHelper.enDayNames,
                monthLabel: monthLabel,
                dayList: dayList,
                isWeekView: _isWeekView,
                selectedDay: _selectedDay,
                allEvents: allEvents,
                onPrevious: _goPrevious,
                onNext: _goNext,
                onDayTap: _onDayTap,
                onToggleView: _onToggleView,
                isSameDay: _isSameDay,
                dayHasEvents: _dayHasEvents,
              ),

              // Bottom events panel
              Expanded(
                child: CalendarEventsPanel(
                  selectedEvents: selectedEvents,
                  formattedDate: formattedDate,
                  onToggleExpand: _onToggleExpand,
                  onDragEnd: _onDragEnd,
                  onLocationTap: (url) => _launchMap(context, url),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}