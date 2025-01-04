import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_text.dart';

class AppPagination extends StatefulWidget {
  const AppPagination({
    super.key,
    required this.currentPage,
    required this.totalPage,
    required this.onPageChanged,
    this.decoration,
    required this.onSearched,
  });

  final int currentPage;
  final int totalPage;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<String> onSearched;
  final Decoration? decoration;

  @override
  State<AppPagination> createState() => _AppPaginationState();
}

class _AppPaginationState extends State<AppPagination> {
  late int currentPage = widget.currentPage;
  late int totalPage = widget.totalPage;
  late TextEditingController controller = TextEditingController();

  @override
  void didUpdateWidget(covariant AppPagination oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.currentPage != widget.currentPage ||
        oldWidget.totalPage != widget.totalPage) {
      setState(() {
        currentPage = widget.currentPage;
        totalPage = widget.totalPage;
      });
    }
  }

  void _updatePage(int page) {
    setState(() {
      currentPage = page;
    });
    widget.onPageChanged(page);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: 45,
            width: size.width / 6,
            child: TextFormField(
              onChanged: widget.onSearched,
              style: GoogleFonts.poppins(
                height: 1.4,
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                hintText: "Cari disini...",
                fillColor: Colors.white,
                filled: true,
                hintStyle: GoogleFonts.poppins(
                  fontSize: 14,
                  wordSpacing: 4,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const Spacer(),
          Container(
            alignment: Alignment.center,
            height: 35,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: widget.decoration ??
                BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey.shade200,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
            child: AppTextNormal.labelW500(
              currentPage.toString(),
              14,
              Colors.black,
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          AppTextNormal.labelW500(
            "dari",
            14,
            Colors.black,
          ),
          const SizedBox(
            width: 8,
          ),
          AppTextNormal.labelW500(
            totalPage.toString(),
            14,
            Colors.black,
          ),
          const SizedBox(
            width: 8,
          ),
          InkWell(
            onTap: currentPage <= 1
                ? null
                : () {
                    _updatePage(currentPage - 1);
                  },
            child: Container(
              alignment: Alignment.center,
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: currentPage > 1
                    ? const Color(0xFFE5E6E9)
                    : const Color(0xFFF1F2F4),
              ),
              child: Text(
                '«',
                style: GoogleFonts.sourceSans3(
                  fontSize: 18,
                  color: currentPage > 1 ? Colors.black : Colors.grey.shade400,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: currentPage >= totalPage
                ? null
                : () {
                    _updatePage(currentPage + 1);
                  },
            child: Container(
              alignment: Alignment.center,
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: currentPage < totalPage
                    ? const Color(0xFFE5E6E9)
                    : const Color(0xFFF1F2F4),
              ),
              child: Text(
                '»',
                style: GoogleFonts.sourceSans3(
                  fontSize: 18,
                  color: currentPage < totalPage
                      ? Colors.black
                      : Colors.grey.shade400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PageControlButton extends StatefulWidget {
  final bool enable;
  final String title;
  final VoidCallback onTap;
  const _PageControlButton(
      {required this.enable, required this.title, required this.onTap});

  @override
  _PageControlButtonState createState() => _PageControlButtonState();
}

class _PageControlButtonState extends State<_PageControlButton> {
  Color normalTextColor = const Color(0xFF0175C2);
  late Color textColor = widget.enable ? normalTextColor : Colors.grey.shade600;

  @override
  void didUpdateWidget(_PageControlButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.enable != widget.enable) {
      setState(() {
        textColor = widget.enable ? normalTextColor : Colors.grey.shade600;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: widget.enable ? widget.onTap : null,
        onHover: (b) {
          if (!widget.enable) return;
          setState(() {
            textColor = b ? normalTextColor.withAlpha(200) : normalTextColor;
          });
        },
        child: _ItemContainer(
            backgroundColor: Colors.white70,
            child: Text(
              widget.title,
              style: TextStyle(color: textColor, fontSize: 14),
            )));
  }
}

class _PageItem extends StatefulWidget {
  final int page;
  final bool isChecked;
  final ValueChanged<int> onTap;
  const _PageItem(
      {required this.page, required this.isChecked, required this.onTap});

  @override
  __PageItemState createState() => __PageItemState();
}

class __PageItemState extends State<_PageItem> {
  Color normalBackgroundColor = const Color(0xFFF3F3F3);
  Color normalHighlightColor = const Color(0xFF0175C2);

  late Color backgroundColor = normalBackgroundColor;
  late Color highlightColor = normalHighlightColor;

  @override
  void didUpdateWidget(covariant _PageItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isChecked != widget.isChecked) {
      if (!widget.isChecked) {
        setState(() {
          backgroundColor = normalBackgroundColor;
          highlightColor = normalHighlightColor;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onHover: (b) {
          if (widget.isChecked) return;
          setState(() {
            backgroundColor =
                b ? const Color(0xFFEAEAEA) : normalBackgroundColor;
            highlightColor = b ? const Color(0xFF077BC6) : normalHighlightColor;
          });
        },
        onTap: () {
          widget.onTap(widget.page);
        },
        child: _ItemContainer(
          backgroundColor: widget.isChecked ? highlightColor : backgroundColor,
          child: Text(
            widget.page.toString(),
            style: TextStyle(
                color: widget.isChecked ? Colors.white : highlightColor,
                fontWeight: FontWeight.w600,
                fontSize: 14),
          ),
        ));
  }
}

class _ItemContainer extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  const _ItemContainer({required this.child, required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      decoration: BoxDecoration(
          color: backgroundColor, borderRadius: BorderRadius.circular(4)),
      child: child,
    );
  }
}

class AppPaginationBoard extends StatefulWidget {
  const AppPaginationBoard({
    super.key,
    required this.currentPage,
    required this.totalPage,
    required this.onPageChanged,
    this.decoration,
    required this.onSearched,
  });

  final int currentPage;
  final int totalPage;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<String> onSearched;
  final Decoration? decoration;

  @override
  State<AppPaginationBoard> createState() => _AppPaginationBoardState();
}

class _AppPaginationBoardState extends State<AppPaginationBoard> {
  late int currentPage = widget.currentPage;
  late int totalPage = widget.totalPage;
  late TextEditingController controller = TextEditingController();

  @override
  void didUpdateWidget(covariant AppPaginationBoard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.currentPage != widget.currentPage ||
        oldWidget.totalPage != widget.totalPage) {
      setState(() {
        currentPage = widget.currentPage;
        totalPage = widget.totalPage;
      });
    }
  }

  void _updatePage(int page) {
    setState(() {
      currentPage = page;
    });
    widget.onPageChanged(page);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Spacer(),
          Container(
            alignment: Alignment.center,
            height: 35,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: widget.decoration ??
                BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey.shade200,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
            child: AppTextNormal.labelW500(
              currentPage.toString(),
              14,
              Colors.black,
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          AppTextNormal.labelW500(
            "dari",
            14,
            Colors.black,
          ),
          const SizedBox(
            width: 8,
          ),
          AppTextNormal.labelW500(
            totalPage.toString(),
            14,
            Colors.black,
          ),
          const SizedBox(
            width: 8,
          ),
          InkWell(
            onTap: currentPage <= 1
                ? null
                : () {
                    _updatePage(currentPage - 1);
                  },
            child: Container(
              alignment: Alignment.center,
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: currentPage > 1
                    ? const Color(0xFFE5E6E9)
                    : const Color(0xFFF1F2F4),
              ),
              child: Text(
                '«',
                style: GoogleFonts.sourceSans3(
                  fontSize: 18,
                  color: currentPage > 1 ? Colors.black : Colors.grey.shade400,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: currentPage >= totalPage
                ? null
                : () {
                    _updatePage(currentPage + 1);
                  },
            child: Container(
              alignment: Alignment.center,
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: currentPage < totalPage
                    ? const Color(0xFFE5E6E9)
                    : const Color(0xFFF1F2F4),
              ),
              child: Text(
                '»',
                style: GoogleFonts.sourceSans3(
                  fontSize: 18,
                  color: currentPage < totalPage
                      ? Colors.black
                      : Colors.grey.shade400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
