import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/dimensions/dimensions_constants.dart';
import '../../../core/routing/routes.dart';
import '../../../core/theming/colors.dart';
import '../../../core/theming/typography_theme.dart';
import '../data/models/message_models.dart';
import '../logic/messages_cubit.dart';
import 'message_format.dart';

/// "Messages" tab: every guest feedback conversation of the client's events, newest first.
class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> with WidgetsBindingObserver {
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scroll.addListener(_onScroll);
    context.read<MessagesCubit>().load();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scroll.dispose();
    super.dispose();
  }

  // A message may have arrived while the app was in the background (push is tapped or not).
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      context.read<MessagesCubit>().load(silent: true);
    }
  }

  void _onScroll() {
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 200) {
      context.read<MessagesCubit>().loadMore();
    }
  }

  void _open(ConversationItem c) {
    Navigator.of(context).pushNamed(Routes.chatScreen, arguments: {
      'conversationId': c.conversationId,
      'guestName': c.guestName,
      'eventTitle': c.eventTitle,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryLight,
      appBar: AppBar(
        backgroundColor: AppColor.primaryDark,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'messages'.tr(),
          style: context.typography.titleLarge.copyWith(color: AppColor.primaryLight),
        ),
      ),
      body: BlocBuilder<MessagesCubit, MessagesState>(
        builder: (context, state) {
          if (state.items.isEmpty &&
              (state.status == MessagesStatus.loading || state.status == MessagesStatus.initial)) {
            return const Center(child: CircularProgressIndicator(color: AppColor.primaryDark));
          }

          if (state.items.isEmpty && state.status == MessagesStatus.error) {
            return _Centered(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('messages_load_failed'.tr(),
                      textAlign: TextAlign.center,
                      style: context.typography.bodyMedium.copyWith(color: AppColor.gray600)),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => context.read<MessagesCubit>().load(),
                    child: Text('retry'.tr()),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: AppColor.primaryDark,
            onRefresh: () => context.read<MessagesCubit>().load(silent: true),
            child: state.items.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: 400,
                        child: Center(
                          child: Text('no_messages'.tr(),
                              style: context.typography.bodyMedium.copyWith(color: AppColor.gray500)),
                        ),
                      ),
                    ],
                  )
                : ListView.separated(
                    controller: _scroll,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(edge),
                    itemCount: state.items.length + (state.hasMore ? 1 : 0),
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, i) {
                      if (i == state.items.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CircularProgressIndicator(color: AppColor.primaryDark)),
                        );
                      }
                      final c = state.items[i];
                      return _ConversationTile(item: c, onTap: () => _open(c));
                    },
                  ),
          );
        },
      ),
    );
  }
}

class _Centered extends StatelessWidget {
  final Widget child;
  const _Centered({required this.child});

  @override
  Widget build(BuildContext context) =>
      Center(child: Padding(padding: const EdgeInsets.all(24), child: child));
}

class _ConversationTile extends StatelessWidget {
  final ConversationItem item;
  final VoidCallback onTap;

  const _ConversationTile({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final unread = item.unreadCount > 0;
    final preview = item.lastMessagePreview ?? '';
    return Material(
      color: unread ? Colors.white : Colors.white.withValues(alpha: 0.7),
      borderRadius: BorderRadius.circular(radiusInner),
      child: InkWell(
        borderRadius: BorderRadius.circular(radiusInner),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColor.primaryDark,
                child: Text(initialOf(item.guestName),
                    style: const TextStyle(color: AppColor.primaryLight, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.guestName.isEmpty ? '—' : item.guestName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.typography.bodyLarge.copyWith(
                                color: AppColor.primaryDark,
                                fontWeight: unread ? FontWeight.w700 : FontWeight.w500),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(formatMessageTime(item.lastMessageAt),
                            style: context.typography.labelMedium.copyWith(color: AppColor.gray500)),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.eventTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.typography.labelMedium.copyWith(color: AppColor.gray600),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            preview,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textDirection: directionOf(preview),
                            style: context.typography.bodyMedium.copyWith(
                                color: unread ? AppColor.primaryDark : AppColor.gray600),
                          ),
                        ),
                        if (unread) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColor.primaryDark,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text('${item.unreadCount}',
                                style: const TextStyle(
                                    color: AppColor.primaryLight, fontSize: 12, fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
