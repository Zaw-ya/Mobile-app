import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theming/colors.dart';
import '../../../core/theming/typography_theme.dart';
import '../data/models/message_models.dart';
import '../logic/chat_cubit.dart';
import 'message_format.dart';

/// One guest's conversation. Opening it marks it read; the client may just read, or reply
/// (the reply is delivered to the guest on WhatsApp by the server).
class ChatScreen extends StatefulWidget {
  final String guestName;
  final String eventTitle;

  const ChatScreen({super.key, required this.guestName, required this.eventTitle});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  final _input = TextEditingController();
  bool _canSend = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _input.addListener(() {
      final can = _input.text.trim().isNotEmpty;
      if (can != _canSend) setState(() => _canSend = can);
    });
    context.read<ChatCubit>().load();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _input.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      context.read<ChatCubit>().refresh();
    }
  }

  void _send() {
    final text = _input.text;
    if (text.trim().isEmpty) return;
    _input.clear();
    context.read<ChatCubit>().send(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryLight,
      appBar: AppBar(
        backgroundColor: AppColor.primaryDark,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColor.primaryLight),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.guestName.isEmpty ? 'messages'.tr() : widget.guestName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.typography.titleLarge.copyWith(color: AppColor.primaryLight)),
            if (widget.eventTitle.isNotEmpty)
              Text(widget.eventTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.typography.labelMedium
                      .copyWith(color: AppColor.primaryLight.withValues(alpha: 0.7))),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                switch (state.status) {
                  case ChatLoadStatus.loading:
                    return const Center(child: CircularProgressIndicator(color: AppColor.primaryDark));
                  case ChatLoadStatus.notFound:
                    return Center(child: Text('messages_not_found'.tr()));
                  case ChatLoadStatus.error:
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('messages_load_failed'.tr()),
                          TextButton(
                            onPressed: () => context.read<ChatCubit>().load(),
                            child: Text('retry'.tr()),
                          ),
                        ],
                      ),
                    );
                  case ChatLoadStatus.ready:
                    return _MessageList(messages: state.messages);
                }
              },
            ),
          ),
          _InputBar(controller: _input, canSend: _canSend, onSend: _send),
        ],
      ),
    );
  }
}

class _MessageList extends StatelessWidget {
  final List<ChatMessage> messages;
  const _MessageList({required this.messages});

  @override
  Widget build(BuildContext context) {
    // Oldest first from the server; shown newest at the bottom, anchored there.
    final ordered = [...messages]..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    final reversed = ordered.reversed.toList();
    return ListView.builder(
      reverse: true,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      itemCount: reversed.length,
      itemBuilder: (context, i) => _Bubble(message: reversed[i]),
    );
  }
}

class _Bubble extends StatelessWidget {
  final ChatMessage message;
  const _Bubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final out = message.isOutgoing;
    final failed = isFailed(message);
    final bg = out ? AppColor.primaryDark : Colors.white;
    final fg = out ? AppColor.primaryLight : AppColor.primaryDark;

    return Align(
      // Start/end (not left/right) so Arabic (RTL) mirrors correctly.
      alignment: out ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(14),
            border: failed ? Border.all(color: AppColor.semanticError) : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message.body,
                textDirection: directionOf(message.body),
                style: context.typography.bodyMedium.copyWith(color: fg),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(formatMessageTime(message.createdAt),
                      style: context.typography.labelMedium.copyWith(
                          color: fg.withValues(alpha: 0.6), fontSize: 11)),
                  if (out) ...[
                    const SizedBox(width: 4),
                    _StatusIcon(message: message, color: fg.withValues(alpha: 0.7)),
                  ],
                ],
              ),
              if (failed) ...[
                const SizedBox(height: 4),
                Text(failureText(message.failureReason),
                    style: const TextStyle(color: AppColor.semanticError, fontSize: 12)),
                GestureDetector(
                  onTap: () => context.read<ChatCubit>().retry(message),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text('retry'.tr(),
                        style: const TextStyle(
                            color: AppColor.semanticError,
                            fontWeight: FontWeight.w700,
                            fontSize: 13)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusIcon extends StatelessWidget {
  final ChatMessage message;
  final Color color;
  const _StatusIcon({required this.message, required this.color});

  @override
  Widget build(BuildContext context) {
    switch (message.status) {
      case ChatStatus.sending:
        return SizedBox(
          width: 11,
          height: 11,
          child: CircularProgressIndicator(strokeWidth: 1.5, color: color),
        );
      case ChatStatus.failed:
        return const Icon(Icons.error_outline, size: 14, color: AppColor.semanticError);
      default:
        return Icon(Icons.check, size: 14, color: color);
    }
  }
}

class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final bool canSend;
  final VoidCallback onSend;

  const _InputBar({required this.controller, required this.canSend, required this.onSend});

  @override
  Widget build(BuildContext context) {
    // SafeArea keeps the field above the iPhone home indicator; the Scaffold already lifts it with the keyboard.
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
        decoration: const BoxDecoration(
          color: AppColor.primaryLight,
          border: Border(top: BorderSide(color: AppColor.gray100)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                minLines: 1,
                maxLines: 5,
                maxLength: 1000,
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                style: context.typography.bodyMedium.copyWith(color: AppColor.primaryDark),
                decoration: InputDecoration(
                  hintText: 'messages_reply_hint'.tr(),
                  counterText: '',
                  filled: true,
                  fillColor: Colors.white,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            IconButton(
              onPressed: canSend ? onSend : null,
              icon: const Icon(Icons.send_rounded),
              color: AppColor.primaryDark,
              disabledColor: AppColor.gray300,
              tooltip: 'messages_send'.tr(),
            ),
          ],
        ),
      ),
    );
  }
}
