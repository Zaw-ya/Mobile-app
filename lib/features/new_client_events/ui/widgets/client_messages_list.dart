import 'package:app/core/theming/colors.dart';
import 'package:app/core/widgets/empty_widget.dart';
import 'package:app/core/widgets/loader.dart';
import 'package:app/core/widgets/text_field_with_icon.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../client_events/data/models/client_messages_status_response.dart';
import 'client_message_item.dart';

/// Search field of the messages tab. Kept outside the list so it stays
/// visible when a search has no results.
class ClientMessagesSearchField extends StatelessWidget {
  const ClientMessagesSearchField({
    super.key,
    required this.searchController,
    required this.isDebouncing,
    required this.onClear,
  });

  final TextEditingController searchController;
  final bool isDebouncing;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: edge * 0.5),
      child: textFieldWithIcon(
        icon: isDebouncing
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColor.primaryDark,
                ),
              )
            : const Icon(Icons.search, color: AppColor.primaryDark),
        hint: "name/phone number".tr(),
        controller: searchController,
        suffix: ValueListenableBuilder<TextEditingValue>(
          valueListenable: searchController,
          builder: (context, value, _) => value.text.isEmpty
              ? const SizedBox.shrink()
              : GestureDetector(
                  onTap: onClear,
                  child: const Icon(Icons.close_rounded,
                      size: 18, color: AppColor.gray500),
                ),
        ),
      ),
    );
  }
}

/// Message-status rows as a sliver, so they scroll with the sheet's header.
class ClientMessagesList extends StatelessWidget {
  const ClientMessagesList({
    super.key,
    required this.items,
    required this.isLoadingMore,
  });

  final List<ClientMessagesStatusDetails> items;
  final bool isLoadingMore;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SliverToBoxAdapter(child: EmptyWidget());

    return SliverList.separated(
      itemCount: items.length + (isLoadingMore ? 1 : 0),
      separatorBuilder: (_, __) => SizedBox(height: edge * 0.5),
      itemBuilder: (context, index) {
        if (index == items.length) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(edge * 0.5),
              child: Loader(color: AppColor.primaryDark),
            ),
          );
        }
        return ClientMessageItem(item: items[index]);
      },
    );
  }
}
