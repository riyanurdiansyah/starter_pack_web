import 'package:flutter/material.dart';
import 'package:starter_pack_web/utils/app_extension.dart';
import 'package:starter_pack_web/utils/app_pagination.dart';

import 'app_color.dart';
import 'app_text.dart';

class AppDataTable<T> extends StatelessWidget {
  const AppDataTable({
    super.key,
    required this.headers,
    required this.datas,
    required this.buildRow,
    required this.currentPage,
    required this.totalPage,
    required this.onPageChanged,
    required this.onSearched,
  });

  final List<String> headers;
  final List<T> datas;
  final Widget Function(T data) buildRow;
  final int currentPage;
  final int totalPage;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<String> onSearched;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        // Header Tabel
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          decoration: BoxDecoration(
            color: colorPrimaryDark.withOpacity(0.6),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Row(
            children: List.generate(
              headers.length + 1,
              (index) {
                if (index == headers.length) {
                  return SizedBox(
                    width: 100,
                    child: AppTextNormal.labelBold(
                      "ACTION",
                      16,
                      Colors.white,
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return Expanded(
                  child: AppTextNormal.labelBold(
                    headers[index],
                    16,
                    Colors.white,
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
          ),
        ),
        // Body Tabel
        Column(
          children: List.generate(datas.length, (index) {
            return buildRow(datas[index]);
          }),
        ),
        10.ph,
        AppPagination(
          currentPage: currentPage,
          totalPage: totalPage,
          onPageChanged: onPageChanged,
          onSearched: onSearched,
        )
      ],
    );
  }
}
