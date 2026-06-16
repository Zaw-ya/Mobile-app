import 'package:app/core/theming/colors.dart';
import 'package:app/core/widgets/empty_widget.dart';
import 'package:app/core/widgets/loader.dart';
import 'package:app/core/widgets/text_field_with_icon.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../client_events/data/models/client_messages_status_response.dart';
import 'client_message_item.dart';

class ClientMessagesList extends StatelessWidget {
  const ClientMessagesList({
    super.key,
    required this.items,
    required this.isLoadingMore,
    required this.scrollController,
    required this.searchController,
    required this.isDebouncing,
    required this.onClear,
  });

  final List<ClientMessagesStatusDetails> items;
  final bool isLoadingMore;
  final ScrollController scrollController;
  final TextEditingController searchController;
  final bool isDebouncing;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [


        // ── Messages header — unchanged from design ───────────────────────
        // Container(
        //   padding: EdgeInsets.symmetric(
        //     horizontal: edge * 0.8,
        //     vertical: edge * 0.7,
        //   ),
        //   decoration: BoxDecoration(
        //     color: AppColor.containerBackground,
        //     borderRadius: BorderRadius.circular(radiusInput),
        //   ),
        //   child: Row(
        //     children: [
        //       Image.asset(Assets.imagesMessages),
        //       SizedBox(width: edge * 0.6),
        //       Expanded(
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             TitleText(
        //               text: "messages_for_all_guests".tr(),
        //               fontSize: 20,
        //               color: AppColor.primaryColor,
        //             ),
        //             SizedBox(height: edge * 0.2),
        //             NormalText(
        //               text: "messages_for_all_guests_hint".tr(),
        //               fontSize: 14,
        //               color: AppColor.gray600,
        //             ),
        //           ],
        //         ),
        //       ),
        //       Icon(Icons.arrow_forward_ios, color: AppColor.primaryColor),
        //     ],
        //   ),
        // ),
        SizedBox(height: edge * 0.5),
        // ── Search field — same logic as old ClientMessagesStatusScreen ───
        Row(
          children: [
            Expanded(
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
              ),
            ),
            // const SizedBox(width: 6),
            // ElevatedButton(
            //   style: ElevatedButton.styleFrom(
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(12),
            //     ),
            //     backgroundColor: AppColor.primaryColor,
            //     foregroundColor: Colors.white,
            //   ),
            //   onPressed: onClear,
            //   child: NormalText(text: "clear".tr(), color: Colors.white),
            // ),
          ],
        ),
        SizedBox(height: edge * 0.5),
        // ── List ─────────────────────────────────────────────────────────
        if (items.isEmpty)
          const EmptyWidget()
        else
          Expanded(
            child: ListView.separated(
              controller: scrollController,
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
            ),
          ),
      ],
    );
  }
}